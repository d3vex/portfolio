import 'dotenv/config';
import mysql from 'mysql2/promise';
import * as crypto from 'crypto';

const q = (s: string): string => '`' + s.replace(/`/g, '``') + '`';

async function hasColumn(
  cn: mysql.Connection,
  table: string,
  column: string,
): Promise<boolean> {
  try {
    const [rows] = await cn.query(`SHOW COLUMNS FROM ${q(table)}`);
    return (rows as mysql.RowDataPacket[]).some((r) => String(r.Field) === column);
  } catch {
    return false;
  }
}

async function hasTable(cn: mysql.Connection, table: string): Promise<boolean> {
  try {
    await cn.query(`SELECT 1 FROM ${q(table)} LIMIT 1`);
    return true;
  } catch {
    return false;
  }
}

async function readJsonColumn(
  cn: mysql.Connection,
  table: string,
  idColumn: string,
  jsonColumn: string,
): Promise<Map<string, unknown>> {
  const map = new Map<string, unknown>();
  if (!(await hasColumn(cn, table, jsonColumn))) return map;
  const [rows] = await cn.query(`SELECT ${q(idColumn)}, ${q(jsonColumn)} FROM ${q(table)}`);
  for (const row of rows as mysql.RowDataPacket[]) {
    const raw = row[jsonColumn];
    if (raw == null) continue;
    let value: unknown = raw;
    if (typeof raw === 'string') {
      try {
        value = JSON.parse(raw);
      } catch {
        continue;
      }
    }
    map.set(String(row[idColumn]), value);
  }
  return map;
}

async function migrateSkillKeywords(cn: mysql.Connection): Promise<void> {
  console.log('Migrating skills.keywords -> skill_keywords...');
  const map = await readJsonColumn(cn, 'skills', 'id', 'keywords');
  if (map.size === 0) {
    console.log('  No legacy keywords JSON column/data, skipping');
    return;
  }
  for (const [id, value] of map) {
    const keywords = Array.isArray(value) ? value.filter((k): k is string => typeof k === 'string') : [];
    for (const kw of keywords) {
      await cn.query(
        `INSERT IGNORE INTO skill_keywords (${q('skillId')}, value) VALUES (?, ?)`,
        [id, kw],
      );
    }
  }
  console.log(`  Done: keywords from ${map.size} skills`);
}

async function migrateEducationTags(cn: mysql.Connection): Promise<void> {
  console.log('Migrating education.tags -> education_tags...');
  const map = await readJsonColumn(cn, 'education', 'id', 'tags');
  if (map.size === 0) {
    console.log('  No legacy tags JSON column/data, skipping');
    return;
  }
  for (const [id, value] of map) {
    const tags = Array.isArray(value) ? value.filter((t): t is string => typeof t === 'string') : [];
    for (const tag of tags) {
      await cn.query(
        `INSERT IGNORE INTO education_tags (${q('educationId')}, value) VALUES (?, ?)`,
        [id, tag],
      );
    }
  }
  console.log(`  Done: tags from ${map.size} education rows`);
}

async function migrateExperienceTags(cn: mysql.Connection): Promise<void> {
  console.log('Migrating experience.tags -> experience_tags...');
  const map = await readJsonColumn(cn, 'experiences', 'id', 'tags');
  if (map.size === 0) {
    console.log('  No legacy tags JSON column/data, skipping');
    return;
  }
  for (const [id, value] of map) {
    const tags = Array.isArray(value) ? value.filter((t): t is string => typeof t === 'string') : [];
    for (const tag of tags) {
      await cn.query(
        `INSERT IGNORE INTO experience_tags (${q('experienceId')}, value) VALUES (?, ?)`,
        [id, tag],
      );
    }
  }
  console.log(`  Done: tags from ${map.size} experience rows`);
}

async function migrateProjectTechnologies(cn: mysql.Connection): Promise<void> {
  console.log('Migrating project.technologies -> project_technologies...');
  const map = await readJsonColumn(cn, 'projects', 'id', 'technologies');
  if (map.size === 0) {
    console.log('  No legacy technologies JSON column/data, skipping');
    return;
  }
  for (const [id, value] of map) {
    const techs = Array.isArray(value)
      ? value.filter((t): t is { name?: unknown; icon?: unknown } => typeof t === 'object' && t !== null)
      : [];
    for (const tech of techs) {
      const name = typeof tech.name === 'string' ? tech.name : null;
      if (!name) continue;
      const icon = typeof tech.icon === 'string' ? tech.icon : null;
      await cn.query(
        `INSERT IGNORE INTO project_technologies (${q('projectId')}, name, icon) VALUES (?, ?, ?)`,
        [id, name, icon],
      );
    }
  }
  console.log(`  Done: technologies from ${map.size} projects`);
}

async function migrateProjectLinks(cn: mysql.Connection): Promise<void> {
  console.log('Migrating project.url/liveUrl/sourceUrl -> links...');
  if (!(await hasTable(cn, 'projects'))) return;
  const livePresent = await hasColumn(cn, 'projects', 'liveUrl');
  const sourcePresent = await hasColumn(cn, 'projects', 'sourceUrl');
  const urlPresent = await hasColumn(cn, 'projects', 'url');
  if (!livePresent && !sourcePresent && !urlPresent) {
    console.log('  No legacy url columns present, skipping');
    return;
  }

  const cols = ['id'];
  if (livePresent) cols.push('liveUrl');
  if (sourcePresent) cols.push('sourceUrl');
  if (urlPresent) cols.push('url');
  const [rows] = await cn.query(
    `SELECT ${cols.map(q).join(', ')} FROM projects`,
  );

  let written = 0;
  for (const row of rows as mysql.RowDataPacket[]) {
    const id = String(row.id);
    const pairs: { type: string; url: string | null }[] = [];
    if (urlPresent && row.url) pairs.push({ type: 'demo', url: String(row.url) });
    if (livePresent && row.liveUrl) pairs.push({ type: 'demo', url: String(row.liveUrl) });
    if (sourcePresent && row.sourceUrl) pairs.push({ type: 'source', url: String(row.sourceUrl) });
    if (!pairs.length) continue;
    const existing = await cn.query(
      `SELECT COUNT(*) AS c FROM links WHERE ${q('projectId')} = ?`,
      [id],
    );
    const count = Number((existing[0] as mysql.RowDataPacket[])[0].c);
    if (count > 0) {
      console.log(`  project ${id}: links already present (${count}), skipping`);
      continue;
    }
    const seen = new Set<string>();
    let order = 0;
    for (const pair of pairs) {
      if (seen.has(pair.url)) continue;
      seen.add(pair.url);
      const label = pair.type === 'demo' ? 'Demo' : 'Source';
      await cn.query(
        `INSERT INTO links (id, label, url, type, ${q('order')}, ${q('projectId')}) VALUES (?, ?, ?, ?, ?, ?)`,
        [crypto.randomUUID(), label, pair.url, pair.type, order, id],
      );
      order++;
      written++;
    }
  }
  console.log(`  Done: ${written} links written`);
}

async function migrateM2mSkills(cn: mysql.Connection): Promise<void> {
  console.log('Migrating experience_skills / project_skills M2M -> point skill joins...');

  const expTable = 'experience_skills';
  if (await hasTable(cn, expTable)) {
    const expColumns = new Set<string>();
    try {
      const [rows] = await cn.query(`SHOW COLUMNS FROM ${q(expTable)}`);
      for (const r of rows as mysql.RowDataPacket[]) expColumns.add(String(r.Field));
    } catch {
    }
    const expSkillCol = expColumns.has('skillId') ? 'skillId' : 'skillsId';
    const expIdCol = expColumns.has('experienceId') ? 'experienceId' : 'experiencesId';

    const [skills] = await cn.query(`SELECT id FROM skills`);
    const knownSkillIds = new Set<string>((skills as mysql.RowDataPacket[]).map((r) => String(r.id)));

    const [exps] = await cn.query(`SELECT id FROM experiences`);
    const knownExpIds = new Set<string>((exps as mysql.RowDataPacket[]).map((r) => String(r.id)));

    const [rows] = await cn.query(`SELECT ${q(expIdCol)}, ${q(expSkillCol)} FROM ${q(expTable)}`);
    const group = new Map<string, Set<string>>();
    for (const row of rows as mysql.RowDataPacket[]) {
      const eid = String(row[expIdCol]);
      const sid = String(row[expSkillCol]);
      if (!group.has(eid)) group.set(eid, new Set());
      group.get(eid)!.add(sid);
    }
    for (const [eid, skillSet] of group) {
      if (!knownExpIds.has(eid)) continue;
      const pointId = crypto.randomUUID();
      await cn.query(
        `INSERT INTO experience_points (id, text, ${q('order')}, ${q('experienceId')}) VALUES (?, ?, ?, ?)`,
        [pointId, '', 0, eid],
      );
      let order = 0;
      for (const sid of skillSet) {
        if (!knownSkillIds.has(sid)) continue;
        await cn.query(
          `INSERT IGNORE INTO experience_point_skills (${q('pointId')}, ${q('skillId')}) VALUES (?, ?)`,
          [pointId, sid],
        );
        order++;
      }
    }
    console.log(`  experience_skills: ${group.size} experiences had M2M skills`);
  } else {
    console.log('  experience_skills table absent, skipping');
  }

  const projTable = 'project_skills';
  if (await hasTable(cn, projTable)) {
    const projColumns = new Set<string>();
    try {
      const [rows] = await cn.query(`SHOW COLUMNS FROM ${q(projTable)}`);
      for (const r of rows as mysql.RowDataPacket[]) projColumns.add(String(r.Field));
    } catch {
    }
    const projSkillCol = projColumns.has('skillId') ? 'skillId' : 'skillsId';
    const projIdCol = projColumns.has('projectId') ? 'projectId' : 'projectsId';

    const [skills] = await cn.query(`SELECT id FROM skills`);
    const knownSkillIds = new Set<string>((skills as mysql.RowDataPacket[]).map((r) => String(r.id)));

    const [projs] = await cn.query(`SELECT id, description, longDescription FROM projects`);
    const knownProj = new Map<string, string>((projs as mysql.RowDataPacket[]).map((r) => [String(r.id), String(r.longDescription || r.description || '')]));

    const [rows] = await cn.query(`SELECT ${q(projIdCol)}, ${q(projSkillCol)} FROM ${q(projTable)}`);
    const group = new Map<string, Set<string>>();
    for (const row of rows as mysql.RowDataPacket[]) {
      const pid = String(row[projIdCol]);
      const sid = String(row[projSkillCol]);
      if (!group.has(pid)) group.set(pid, new Set());
      group.get(pid)!.add(sid);
    }
    for (const [pid, skillSet] of group) {
      const text = knownProj.get(pid) || '';
      const pointId = crypto.randomUUID();
      await cn.query(
        `INSERT INTO project_points (id, text, ${q('order')}, ${q('projectId')}) VALUES (?, ?, ?, ?)`,
        [pointId, text, 0, pid],
      );
      for (const sid of skillSet) {
        if (!knownSkillIds.has(sid)) continue;
        await cn.query(
          `INSERT IGNORE INTO project_point_skills (${q('pointId')}, ${q('skillId')}) VALUES (?, ?)`,
          [pointId, sid],
        );
      }
    }
    console.log(`  project_skills: ${group.size} projects had M2M skills`);
  } else {
    console.log('  project_skills table absent, skipping');
  }
}

async function migratePointSkillIds(cn: mysql.Connection): Promise<void> {
  console.log('Migrating project_points.skillIds / experience_points.skillIds JSON -> point skill joins...');

  const projMap = await readJsonColumn(cn, 'project_points', 'id', 'skillIds');
  for (const [pointId, value] of projMap) {
    const ids = Array.isArray(value) ? value.filter((i): i is string => typeof i === 'string') : [];
    for (const skillId of ids) {
      await cn.query(
        `INSERT IGNORE INTO project_point_skills (${q('pointId')}, ${q('skillId')}) VALUES (?, ?)`,
        [pointId, skillId],
      );
    }
  }

  const expMap = await readJsonColumn(cn, 'experience_points', 'id', 'skillIds');
  for (const [pointId, value] of expMap) {
    const ids = Array.isArray(value) ? value.filter((i): i is string => typeof i === 'string') : [];
    for (const skillId of ids) {
      await cn.query(
        `INSERT IGNORE INTO experience_point_skills (${q('pointId')}, ${q('skillId')}) VALUES (?, ?)`,
        [pointId, skillId],
      );
    }
  }

  console.log(`  Done: ${projMap.size} project points, ${expMap.size} experience points`);
}

async function migrateCvProjectBullets(cn: mysql.Connection): Promise<void> {
  console.log('Migrating cv.projectBullets JSON -> cv_project_points...');
  if (!(await hasColumn(cn, 'cvs', 'projectBullets'))) {
    console.log('  No legacy projectBullets column present, skipping');
    return;
  }
  const [rows] = await cn.query(`SELECT id, ${q('projectBullets')} FROM cvs`);
  for (const row of rows as mysql.RowDataPacket[]) {
    const cvId = String(row.id);
    const raw = row.projectBullets;
    if (raw == null) continue;
    let bullets: Record<string, number[]> = raw;
    if (typeof raw === 'string') {
      try {
        bullets = JSON.parse(raw);
      } catch {
        continue;
      }
    }
    if (typeof bullets !== 'object' || bullets === null) continue;

    const [projRows] = await cn.query(
      `SELECT ${q('projectId')} FROM cv_projects WHERE ${q('cvId')} = ?`,
      [cvId],
    );
    const cvProjectIds = new Set<string>((projRows as mysql.RowDataPacket[]).map((r) => String(r.projectId)));

    for (const [projectId, indices] of Object.entries(bullets)) {
      if (!cvProjectIds.has(projectId)) continue;
      const [pts] = await cn.query(
        `SELECT id FROM project_points WHERE ${q('projectId')} = ? ORDER BY ${q('order')}`,
        [projectId],
      );
      const pointRows = pts as mysql.RowDataPacket[];
      for (const idx of indices) {
        const point = pointRows[idx];
        if (!point) continue;
        await cn.query(
          `INSERT IGNORE INTO cv_project_points (${q('cvId')}, ${q('projectPointId')}) VALUES (?, ?)`,
          [cvId, String(point.id)],
        );
      }
    }
  }
  console.log('  Done: cv project bullets resolved to point links');
}

async function main() {
  const cn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'cvmanager',
  });

  console.log('Restructuring legacy JSON/M2M data into relational join tables...\n');

  await cn.beginTransaction();
  try {
    await migrateSkillKeywords(cn);
    await migrateEducationTags(cn);
    await migrateExperienceTags(cn);
    await migrateProjectTechnologies(cn);
    await migrateProjectLinks(cn);
    await migrateM2mSkills(cn);
    await migratePointSkillIds(cn);
    await migrateCvProjectBullets(cn);
    await cn.commit();
  } catch (err) {
    await cn.rollback();
    throw err;
  }

  await cn.end();
  console.log('\n✓ Restructure data migration complete');
}

main().catch((err) => {
  console.error('Restructure data migration failed:', err);
  process.exit(1);
});
