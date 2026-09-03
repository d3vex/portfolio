import 'dotenv/config';
import mysql from 'mysql2/promise';
import * as crypto from 'crypto';

const q = (s: string): string => '`' + s.replace(/`/g, '``') + '`';

interface JunctionSpec {
  table: string;
  childTable: string;
  childColumn: string;
  oldChildColumn: string;
}

const JUNCTIONS: JunctionSpec[] = [
  { table: 'cv_skills', childTable: 'skills', childColumn: 'skillId', oldChildColumn: 'skillsId' },
  { table: 'cv_projects', childTable: 'projects', childColumn: 'projectId', oldChildColumn: 'projectsId' },
  { table: 'cv_passions', childTable: 'passions', childColumn: 'passionId', oldChildColumn: 'passionsId' },
];

async function convertJunction(cn: mysql.Connection, spec: JunctionSpec): Promise<void> {
  const { table, childTable, childColumn, oldChildColumn } = spec;
  const newTable = `${table}_new`;

  let columns: string[] | null = null;
  try {
    const [rows] = await cn.execute(`SHOW COLUMNS FROM ${q(table)}`);
    columns = (rows as mysql.RowDataPacket[]).map((r) => String(r.Field));
  } catch {
  }
  if (!columns) {
    console.log(`  ${table}: table does not exist, skipping`);
    return;
  }
  if (columns.includes('id')) {
    console.log(`  ${table}: already in new shape, skipping`);
    return;
  }
  if (!columns.includes('cvsId') || !columns.includes(oldChildColumn)) {
    console.log(`  ${table}: unexpected columns (${columns.join(', ')}), skipping`);
    return;
  }

  await cn.beginTransaction();
  try {
    console.log(`  ${table}: converting (old columns: ${columns.join(', ')})`);

    await cn.execute(
      `CREATE TABLE ${q(newTable)} (${q('id')} UUID NOT NULL PRIMARY KEY, ${q('cvId')} UUID NOT NULL, ${q(childColumn)} UUID NOT NULL, ${q('order')} INT NOT NULL DEFAULT 0)`
    );

    const [oldRows] = await cn.query(`SELECT ${q('cvsId')}, ${q(oldChildColumn)} FROM ${q(table)}`);
    const old = oldRows as mysql.RowDataPacket[];

    // Map child entity id -> its global order (replicates today's display order).
    const [childRows] = await cn.query(`SELECT id, ${q('order')} FROM ${q(childTable)}`);
    const childOrder = new Map<string, number>();
    for (const row of childRows as mysql.RowDataPacket[]) {
      childOrder.set(String(row.id), Number(row.order ?? 0));
    }

    // Only keep links whose CV still exists (orphan drop).
    const [cvRows] = await cn.query(`SELECT id FROM ${q('cvs')}`);
    const cvIds = new Set<string>((cvRows as mysql.RowDataPacket[]).map((row) => String(row.id)));

    const entries: { cvsId: string; childId: string; childOrder: number; index: number }[] = [];
    for (let i = 0; i < old.length; i++) {
      const cvsId = String(old[i].cvsId);
      const childId = String(old[i][oldChildColumn]);
      const ord = childOrder.get(childId);
      if (ord === undefined) {
        console.log(`    dropping orphan row (child ${childId} missing from ${childTable})`);
        continue;
      }
      if (!cvIds.has(cvsId)) {
        console.log(`    dropping orphan row (cv ${cvsId} missing from cvs)`);
        continue;
      }
      entries.push({ cvsId, childId, childOrder: ord, index: i });
    }

    let written = 0;
    const groups = new Map<string, typeof entries>();
    for (const e of entries) {
      const group = groups.get(e.cvsId);
      if (group) group.push(e);
      else groups.set(e.cvsId, [e]);
    }
    for (const [cvsId, group] of groups) {
      const sorted = [...group].sort((a, b) => a.childOrder - b.childOrder || a.index - b.index);
      const seen = new Set<string>();
      let order = 0;
      for (const e of sorted) {
        if (seen.has(e.childId)) continue;
        seen.add(e.childId);
        await cn.execute(
          `INSERT INTO ${q(newTable)} (${q('id')}, ${q('cvId')}, ${q(childColumn)}, ${q('order')}) VALUES (?, ?, ?, ?)`,
          [crypto.randomUUID(), cvsId, e.childId, order]
        );
        order++;
        written++;
      }
    }

    await cn.execute(`DROP TABLE ${q(table)}`);
    await cn.execute(`RENAME TABLE ${q(newTable)} TO ${q(table)}`);

    console.log(`  ${table}: ${old.length} rows read, ${written} rows written (${old.length - entries.length} orphan rows dropped, ${entries.length - written} duplicates deduped)`);
    await cn.commit();
  } catch (err) {
    await cn.rollback();
    throw err;
  }
}

async function main() {
  const cn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'cvmanager',
  });

  console.log('Migrating CV junction tables to explicit shape with order...');
  for (const spec of JUNCTIONS) {
    await convertJunction(cn, spec);
  }
  await cn.end();
  console.log('✓ Junction migration complete');
}

main().catch((err) => {
  console.error('Junction migration failed:', err);
  process.exit(1);
});
