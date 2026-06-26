import 'dotenv/config';
import { DataSource } from 'typeorm';
import * as crypto from 'crypto';
const Database = require('better-sqlite3');

const sqlitePath = 'data/cvmanager.sqlite';

async function migrate() {
  const ds = new DataSource({
    type: 'mariadb',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3307', 10),
    username: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || 'root',
    database: process.env.DB_NAME || 'cvmanager',
    entities: [__dirname + '/../src/**/*.entity{.ts,.js}'],
    synchronize: false,
    logging: false,
  });
  await ds.initialize();
  const em = ds.manager;

  const sqlite = new Database(sqlitePath, { readonly: true });

  // ── Migrate project_points ──────────────────────────────
  console.log('\nMigrating project descriptions -> project_points...');
  const projectRows = sqlite.prepare('SELECT id, descriptions FROM projects').all() as any[];
  let projCount = 0;
  for (const p of projectRows) {
    const descs = parseJson<any[]>(p.descriptions);
    for (let i = 0; i < descs.length; i++) {
      const d = descs[i];
      const id = crypto.randomUUID();
      await em.query(
        `INSERT INTO project_points (id, text, \`order\`, skillIds, projectId) VALUES (?, ?, ?, ?, ?)`,
        [id, d.text, i, JSON.stringify(d.skillIds || []), p.id]
      );
      projCount++;
    }
  }
  console.log(`  project_points: ${projCount} rows`);

  // ── Migrate experience_points ───────────────────────────
  console.log('\nMigrating experience descriptions -> experience_points...');
  const expRows = sqlite.prepare('SELECT id, descriptions FROM experiences').all() as any[];
  let expCount = 0;
  for (const e of expRows) {
    const descs = parseJson<any[]>(e.descriptions);
    for (let i = 0; i < descs.length; i++) {
      const d = descs[i];
      const id = crypto.randomUUID();
      await em.query(
        `INSERT INTO experience_points (id, text, \`order\`, skillIds, experienceId) VALUES (?, ?, ?, ?, ?)`,
        [id, d.text, i, JSON.stringify(d.skillIds || []), e.id]
      );
      expCount++;
    }
  }
  console.log(`  experience_points: ${expCount} rows`);

  sqlite.close();
  await ds.destroy();

  console.log('\n✅ Migration complete!');
}

function parseJson<T>(val: string | null): T {
  if (!val || val === '[]') return [] as unknown as T;
  try { return JSON.parse(val); } catch { return [] as unknown as T; }
}

migrate().catch(err => {
  console.error('❌ Migration failed:', err);
  process.exit(1);
});
