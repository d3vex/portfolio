import 'dotenv/config';
import { DataSource } from 'typeorm';
import * as crypto from 'crypto';

const OLD_SQLITE_PATH = 'data/cvmanager.sqlite';
const Q = '`'; // backtick helper for MariaDB identifiers

const mariadbConfig = {
  type: 'mariadb' as const,
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3307', 10),
  username: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || 'root',
  database: process.env.DB_NAME || 'cvmanager',
  entities: [__dirname + '/../src/**/*.entity{.ts,.js}'],
  synchronize: true,
  logging: false,
};

interface OldProject {
  id: string; title: string; subtitle: string | null; url: string | null;
  startDate: string | null; endDate: string | null; description: string | null;
  longDescription: string | null; descriptions: string | null;
  technologies: string | null; status: string; featured: number;
  imageUrl: string | null; imageId: string | null;
  liveUrl: string | null; sourceUrl: string | null;
  educationId: string | null; order: number;
  createdAt: string; updatedAt: string;
  skillIds: string | null; categoryIds: string | null;
  timeline: string | null; links: string | null;
}

interface OldCv {
  id: string; name: string; specialization: string | null;
  titleOverride: string | null; aboutText: string | null;
  isDefault: number; pictureId: string | null;
  availability: string | null; createdAt: string; updatedAt: string;
  skillIds: string | null; languageIds: string | null;
  passionIds: string | null; experienceIds: string | null;
  projectIds: string | null; educationIds: string | null;
}

function q(s: string): string {
  return Q + s + Q;
}

function parseJson<T>(val: string | null): T[] {
  if (!val || val === '[]') return [];
  try { return JSON.parse(val); } catch { return []; }
}

async function migrateOld() {
  console.log('Connecting to MariaDB (syncing schema)...');
  const ds = new DataSource(mariadbConfig);
  await ds.initialize();
  const em = ds.manager;
  await em.query(`ALTER TABLE ${q('images')} MODIFY COLUMN ${q('data')} LONGBLOB NOT NULL`);

  console.log('Reading old SQLite data...');
  const Database = require('better-sqlite3');
  const oldDb = new Database(OLD_SQLITE_PATH, { readonly: true });

  // Clear MariaDB tables (FK-safe order)
  await em.query('SET FOREIGN_KEY_CHECKS = 0');
  const allTables = [
    'project_timeline_entries', 'links', 'project_categories', 'project_skills',
    'cv_education', 'cv_projects', 'cv_experiences',
    'cv_passions', 'cv_languages', 'cv_skills', 'cvs',
    'projects', 'experiences', 'education', 'skills', 'languages',
    'passions', 'contacts', 'profiles', 'categories', 'images', 'users',
  ];
  for (const t of allTables) {
    await em.query(`DELETE FROM ${q(t)}`);
  }

  // 1. Copy simple tables directly
  console.log('\nCopying core tables...');

  const excludeCols: Record<string, string[]> = {
    education: ['projectIds'],
    experiences: ['skillIds', 'links'],
  };

  const simpleTables = ['categories', 'contacts', 'profiles', 'skills',
    'languages', 'passions', 'education', 'experiences', 'users', 'images'];

  for (const table of simpleTables) {
    const rows = oldDb.prepare(`SELECT * FROM "${table}"`).all() as any[];
    if (rows.length === 0) continue;
    const skip = excludeCols[table] || [];
    const cols = Object.keys(rows[0]).filter(c => !skip.includes(c));
    for (const row of rows) {
      const vals = cols.map(c => {
        const v = row[c];
        if (v instanceof Buffer) return v;
        if (v == null || v === '') return null;
        return v;
      });
      const ph = cols.map(() => '?').join(', ');
      await em.query(
        `INSERT INTO ${q(table)} (${cols.map(q).join(', ')}) VALUES (${ph})`,
        vals
      );
    }
    console.log(`  ${table}: ${rows.length} rows`);
  }

  // 2. Projects (core columns only, relations handled next)
  console.log('\nCopying projects...');
  const projectRows = oldDb.prepare('SELECT * FROM projects').all() as OldProject[];

  const projCols = ['id', 'title', 'subtitle', 'url', 'startDate', 'endDate',
    'description', 'longDescription', 'descriptions', 'technologies',
    'status', 'featured', 'imageUrl', 'imageId', 'liveUrl', 'sourceUrl',
    'educationId', 'order', 'createdAt', 'updatedAt'];

  for (const p of projectRows) {
    const status = (!p.status || !['completed', 'testing', 'in-progress', 'planned'].includes(p.status)) ? 'in-progress' : p.status;
    const featured = p.featured === 1;
    const vals = [
      p.id, p.title, p.subtitle, p.url,
      p.startDate, p.endDate, p.description, p.longDescription,
      p.descriptions, p.technologies,
      status, featured,
      p.imageUrl, p.imageId, p.liveUrl, p.sourceUrl,
      p.educationId, p.order, p.createdAt, p.updatedAt,
    ];
    const ph = projCols.map(() => '?').join(', ');
    await em.query(
      `INSERT INTO ${q('projects')} (${projCols.map(q).join(', ')}) VALUES (${ph})`,
      vals
    );
  }
  console.log(`  projects: ${projectRows.length} rows`);

  // 3. CVs
  console.log('\nCopying CVs...');
  const cvRows = oldDb.prepare('SELECT * FROM cvs').all() as OldCv[];

  const cvCols = ['id', 'name', 'specialization', 'titleOverride', 'aboutText',
    'isDefault', 'pictureId', 'availability', 'createdAt', 'updatedAt'];

  for (const cv of cvRows) {
    const vals = [
      cv.id, cv.name, cv.specialization, cv.titleOverride,
      cv.aboutText, cv.isDefault === 1, cv.pictureId, cv.availability,
      cv.createdAt, cv.updatedAt,
    ];
    const ph = cvCols.map(() => '?').join(', ');
    await em.query(
      `INSERT INTO ${q('cvs')} (${cvCols.map(q).join(', ')}) VALUES (${ph})`,
      vals
    );
  }
  console.log(`  cvs: ${cvRows.length} rows`);

  // 4. Project → category join table
  console.log('\nPopulating project_categories...');
  let count = 0;
  for (const p of projectRows) {
    const catIds = parseJson<string>(p.categoryIds);
    for (const catId of catIds) {
      await em.query(
        `INSERT INTO ${q('project_categories')} (${q('projectsId')}, ${q('categoriesId')}) VALUES (?, ?)`,
        [p.id, catId]
      );
      count++;
    }
  }
  // 5. Project → timeline entries
  console.log('\nPopulating project_timeline_entries...');
  count = 0;
  for (const p of projectRows) {
    const timeline = parseJson<{ date: string; title: string; description: string; status: string; imageUrl?: string }>(p.timeline);
    const tlCols = ['id', 'date', 'title', 'description', 'status', 'imageUrl', 'projectId', 'order'];
    const ph = tlCols.map(() => '?').join(', ');
    for (let i = 0; i < timeline.length; i++) {
      const t = timeline[i];
      await em.query(
        `INSERT INTO ${q('project_timeline_entries')} (${tlCols.map(q).join(', ')}) VALUES (${ph})`,
        [crypto.randomUUID(), t.date, t.title, t.description, t.status, t.imageUrl || null, p.id, i]
      );
      count++;
    }
  }
  console.log(`  project_timeline_entries: ${count} rows`);

  // 6. Project → links
  console.log('\nPopulating links...');
  count = 0;
  for (const p of projectRows) {
    const links = parseJson<{ label: string; url: string; type?: string; icon?: string }>(p.links);
    const linkCols = ['id', 'label', 'url', 'icon', 'type', 'projectId', 'order'];
    const ph = linkCols.map(() => '?').join(', ');
    for (let i = 0; i < links.length; i++) {
      const l = links[i];
      await em.query(
        `INSERT INTO ${q('links')} (${linkCols.map(q).join(', ')}) VALUES (${ph})`,
        [crypto.randomUUID(), l.label, l.url, l.icon || null, l.type || null, p.id, i]
      );
      count++;
    }
  }
  console.log(`  links: ${count} rows`);

  // 7. CV → * join tables
  console.log('\nPopulating CV join tables...');

  for (const cv of cvRows) {
    const skillIds = parseJson<string>(cv.skillIds);
    for (const sid of skillIds) {
      await em.query(
        `INSERT INTO ${q('cv_skills')} (${q('cvsId')}, ${q('skillsId')}) VALUES (?, ?)`,
        [cv.id, sid]
      );
    }
    console.log(`  cv_skills: ${skillIds.length} rows`);

    const langIds = parseJson<string>(cv.languageIds);
    for (const lid of langIds) {
      await em.query(
        `INSERT INTO ${q('cv_languages')} (${q('cvsId')}, ${q('languagesId')}) VALUES (?, ?)`,
        [cv.id, lid]
      );
    }
    console.log(`  cv_languages: ${langIds.length} rows`);

    const passionIds = parseJson<string>(cv.passionIds);
    for (const pid of passionIds) {
      await em.query(
        `INSERT INTO ${q('cv_passions')} (${q('cvsId')}, ${q('passionsId')}) VALUES (?, ?)`,
        [cv.id, pid]
      );
    }
    console.log(`  cv_passions: ${passionIds.length} rows`);

    const expIds = parseJson<string>(cv.experienceIds);
    for (const eid of expIds) {
      await em.query(
        `INSERT INTO ${q('cv_experiences')} (${q('cvsId')}, ${q('experiencesId')}) VALUES (?, ?)`,
        [cv.id, eid]
      );
    }
    console.log(`  cv_experiences: ${expIds.length} rows`);

    const projIds = parseJson<string>(cv.projectIds);
    for (const pid of projIds) {
      await em.query(
        `INSERT INTO ${q('cv_projects')} (${q('cvsId')}, ${q('projectsId')}) VALUES (?, ?)`,
        [cv.id, pid]
      );
    }
    console.log(`  cv_projects: ${projIds.length} rows`);

    const eduIds = parseJson<string>(cv.educationIds);
    for (const eid of eduIds) {
      await em.query(
        `INSERT INTO ${q('cv_education')} (${q('cvsId')}, ${q('educationId')}) VALUES (?, ?)`,
        [cv.id, eid]
      );
    }
    console.log(`  cv_education: ${eduIds.length} rows`);
  }

  await em.query('SET FOREIGN_KEY_CHECKS = 1');
  oldDb.close();
  await ds.destroy();

  console.log('\n═══════════════════════════════════════════');
  console.log('  ✅ Migration from old schema complete!');
  console.log('═══════════════════════════════════════════');
}

migrateOld().catch(err => {
  console.error('\n❌ Migration failed:', err);
  process.exit(1);
});
