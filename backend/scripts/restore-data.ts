import 'dotenv/config';
import mysql from 'mysql2/promise';
import * as crypto from 'crypto';

const q = (s: string): string => '`' + s.replace(/`/g, '``') + '`';

const LIVE = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306', 10),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || '',
  database: process.env.DB_NAME || 'cvmanager',
};

const SCRATCH = { ...LIVE, database: process.env.SCRATCH_DB || 'cvmanager_scratch' };

async function readJsonRows(
  cn: mysql.Connection,
  table: string,
  idColumn: string,
  jsonColumn: string,
): Promise<Map<string, unknown>> {
  const map = new Map<string, unknown>();
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

async function restoreKeywords(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring skills.keywords -> skill_keywords...');
  const map = await readJsonRows(scratch, 'skills', 'id', 'keywords');
  let count = 0;
  for (const [id, value] of map) {
    const keywords = Array.isArray(value) ? value.filter((k): k is string => typeof k === 'string') : [];
    for (const kw of keywords) {
      const [r] = await live.query(`INSERT IGNORE INTO skill_keywords (${q('skillId')}, value) VALUES (?, ?)`, [id, kw]);
      count += (r as mysql.ResultSetHeader).affectedRows;
    }
  }
  console.log(`  ${count} skill_keywords rows written`);
}

async function restoreEducationTags(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring education.tags -> education_tags...');
  const map = await readJsonRows(scratch, 'education', 'id', 'tags');
  let count = 0;
  for (const [id, value] of map) {
    const tags = Array.isArray(value) ? value.filter((t): t is string => typeof t === 'string') : [];
    for (const tag of tags) {
      const [r] = await live.query(`INSERT IGNORE INTO education_tags (${q('educationId')}, value) VALUES (?, ?)`, [id, tag]);
      count += (r as mysql.ResultSetHeader).affectedRows;
    }
  }
  console.log(`  ${count} education_tags rows written`);
}

async function restoreExperienceTags(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring experiences.tags -> experience_tags...');
  const map = await readJsonRows(scratch, 'experiences', 'id', 'tags');
  let count = 0;
  for (const [id, value] of map) {
    const tags = Array.isArray(value) ? value.filter((t): t is string => typeof t === 'string') : [];
    for (const tag of tags) {
      const [r] = await live.query(`INSERT IGNORE INTO experience_tags (${q('experienceId')}, value) VALUES (?, ?)`, [id, tag]);
      count += (r as mysql.ResultSetHeader).affectedRows;
    }
  }
  console.log(`  ${count} experience_tags rows written`);
}

async function restoreProjectTechnologies(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring projects.technologies -> project_technologies...');
  const map = await readJsonRows(scratch, 'projects', 'id', 'technologies');
  let count = 0;
  for (const [id, value] of map) {
    const techs = Array.isArray(value)
      ? value.filter((t): t is { name?: unknown; icon?: unknown } => typeof t === 'object' && t !== null)
      : [];
    for (const tech of techs) {
      const name = typeof tech.name === 'string' ? tech.name : null;
      if (!name) continue;
      const icon = typeof tech.icon === 'string' ? tech.icon : null;
      const [r] = await live.query(
        `INSERT IGNORE INTO project_technologies (${q('projectId')}, name, icon) VALUES (?, ?, ?)`,
        [id, name, icon],
      );
      count += (r as mysql.ResultSetHeader).affectedRows;
    }
  }
  console.log(`  ${count} project_technologies rows written`);
}

async function restoreProjectLinks(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring projects.url/liveUrl/sourceUrl -> links...');
  const [cols] = await scratch.query(`SHOW COLUMNS FROM projects`);
  const colNames = new Set<string>((cols as mysql.RowDataPacket[]).map((c) => String(c.Field)));
  const liveUrlPresent = colNames.has('liveUrl');
  const sourceUrlPresent = colNames.has('sourceUrl');
  const urlPresent = colNames.has('url');
  if (!liveUrlPresent && !sourceUrlPresent && !urlPresent) {
    console.log('  No legacy url columns present, skipping');
    return;
  }

  const select = ['id'];
  if (urlPresent) select.push('url');
  if (liveUrlPresent) select.push('liveUrl');
  if (sourceUrlPresent) select.push('sourceUrl');
  const [rows] = await scratch.query(`SELECT ${select.map(q).join(', ')} FROM projects`);

  let written = 0;
  for (const row of rows as mysql.RowDataPacket[]) {
    const id = String(row.id);
    const pairs: { type: string; url: string }[] = [];
    if (urlPresent && row.url) pairs.push({ type: 'demo', url: String(row.url) });
    if (liveUrlPresent && row.liveUrl) pairs.push({ type: 'demo', url: String(row.liveUrl) });
    if (sourceUrlPresent && row.sourceUrl) pairs.push({ type: 'source', url: String(row.sourceUrl) });
    if (!pairs.length) continue;
    const existing = await live.query(`SELECT COUNT(*) AS c FROM links WHERE ${q('projectId')} = ?`, [id]);
    const count = Number((existing[0] as mysql.RowDataPacket[])[0].c);
    if (count > 0) continue;
    const seen = new Set<string>();
    let order = 0;
    for (const pair of pairs) {
      if (seen.has(pair.url)) continue;
      seen.add(pair.url);
      const label = pair.type === 'demo' ? 'Demo' : 'Source';
      await live.query(
        `INSERT INTO links (id, label, url, type, ${q('order')}, ${q('projectId')}) VALUES (?, ?, ?, ?, ?, ?)`,
        [crypto.randomUUID(), label, pair.url, pair.type, order, id],
      );
      order++;
      written++;
    }
  }
  console.log(`  ${written} links written`);
}

async function restorePointSkillIds(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring project_points.skillIds / experience_points.skillIds -> point skill joins...');
  const projMap = await readJsonRows(scratch, 'project_points', 'id', 'skillIds');
  let projCount = 0;
  for (const [pointId, value] of projMap) {
    const ids = Array.isArray(value) ? value.filter((i): i is string => typeof i === 'string') : [];
    for (const skillId of ids) {
      const [r] = await live.query(
        `INSERT IGNORE INTO project_point_skills (${q('pointId')}, ${q('skillId')}) VALUES (?, ?)`,
        [pointId, skillId],
      );
      projCount += (r as mysql.ResultSetHeader).affectedRows;
    }
  }
  const expMap = await readJsonRows(scratch, 'experience_points', 'id', 'skillIds');
  let expCount = 0;
  for (const [pointId, value] of expMap) {
    const ids = Array.isArray(value) ? value.filter((i): i is string => typeof i === 'string') : [];
    for (const skillId of ids) {
      const [r] = await live.query(
        `INSERT IGNORE INTO experience_point_skills (${q('pointId')}, ${q('skillId')}) VALUES (?, ?)`,
        [pointId, skillId],
      );
      expCount += (r as mysql.ResultSetHeader).affectedRows;
    }
  }
  console.log(`  ${projCount} project_point_skills, ${expCount} experience_point_skills rows written`);
}

async function restoreCvProjectBullets(live: mysql.Connection, scratch: mysql.Connection): Promise<void> {
  console.log('Restoring cv.projectBullets -> cv_project_points...');
  const map = await readJsonRows(scratch, 'cvs', 'id', 'projectBullets');
  for (const [cvId, value] of map) {
    if (!value || typeof value !== 'object') continue;
    const bullets = value as Record<string, number[]>;
    const [projRows] = await live.query(`SELECT ${q('projectId')} FROM cv_projects WHERE ${q('cvId')} = ?`, [cvId]);
    const cvProjectIds = new Set<string>((projRows as mysql.RowDataPacket[]).map((r) => String(r.projectId)));
    for (const [projectId, indices] of Object.entries(bullets)) {
      if (!cvProjectIds.has(projectId)) continue;
      const [pts] = await live.query(
        `SELECT id FROM project_points WHERE ${q('projectId')} = ? ORDER BY ${q('order')}`,
        [projectId],
      );
      const pointRows = pts as mysql.RowDataPacket[];
      for (const idx of indices) {
        const point = pointRows[idx];
        if (!point) continue;
        await live.query(
          `INSERT IGNORE INTO cv_project_points (${q('cvId')}, ${q('projectPointId')}) VALUES (?, ?)`,
          [cvId, String(point.id)],
        );
      }
    }
  }
  console.log('  cv project bullets resolved to point links');
}

async function main() {
  const live = await mysql.createConnection(LIVE);
  const scratch = await mysql.createConnection(SCRATCH);

  console.log('Restoring legacy relational data from scratch DB into live DB...\n');

  await live.beginTransaction();
  try {
    await restoreKeywords(live, scratch);
    await restoreEducationTags(live, scratch);
    await restoreExperienceTags(live, scratch);
    await restoreProjectTechnologies(live, scratch);
    await restoreProjectLinks(live, scratch);
    await restorePointSkillIds(live, scratch);
    await restoreCvProjectBullets(live, scratch);
    await live.commit();
  } catch (err) {
    await live.rollback();
    throw err;
  }

  await live.end();
  await scratch.end();
  console.log('\n✓ Restore complete');
}

main().catch((err) => {
  console.error('Restore failed:', err);
  process.exit(1);
});
