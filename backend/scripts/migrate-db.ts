import 'dotenv/config';
import { DataSource } from 'typeorm';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const Database = require('better-sqlite3');
import mysql from 'mysql2/promise';

const sqlitePath = 'data/cvmanager.sqlite';

const mariadbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3307', 10),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || 'root',
  database: process.env.DB_NAME || 'cvmanager',
  multipleStatements: true,
};

const tablesInOrder = [
  'images',
  'categories',
  'skills',
  'languages',
  'passions',
  'education',
  'projects',
  'experiences',
  'links',
  'project_timeline_entries',
  'contacts',
  'cvs',
  'users',
  'profiles',
  'project_categories',
  'project_skills',
  'experience_skills',
  'cv_skills',
  'cv_languages',
  'cv_passions',
  'cv_experiences',
  'cv_projects',
  'cv_education',
];

async function migrate() {
  console.log('Creating MariaDB schema via TypeORM sync...');
  const syncDs = new DataSource({
    type: 'mariadb',
    host: mariadbConfig.host,
    port: mariadbConfig.port,
    username: mariadbConfig.user,
    password: mariadbConfig.password,
    database: mariadbConfig.database,
    entities: [__dirname + '/../src/**/*.entity{.ts,.js}'],
    synchronize: true,
    logging: false,
  });
  await syncDs.initialize();
  await syncDs.destroy();
  console.log('  Schema created');

  const cn = await mysql.createConnection(mariadbConfig);
  await cn.execute('ALTER TABLE `images` MODIFY COLUMN `data` LONGBLOB NOT NULL');

  console.log('Opening SQLite...');
  const sqlite = new Database(sqlitePath, { readonly: true });

  await cn.execute('SET FOREIGN_KEY_CHECKS = 0');

  const quoted = (s: string) => '`' + s.replace(/`/g, '``') + '`';

  for (const table of tablesInOrder) {
    const rows = sqlite.prepare(`SELECT * FROM "${table}"`).all() as Record<string, unknown>[];
    if (rows.length === 0) {
      console.log(`  ${table}: 0 rows (skipped)`);
      continue;
    }

    await cn.execute(`TRUNCATE TABLE ${quoted(table)}`);

    const columns = Object.keys(rows[0]);
    const placeholders = columns.map(() => '?').join(', ');
    const insertSql = `INSERT INTO ${quoted(table)} (${columns.map(quoted).join(', ')}) VALUES (${placeholders})`;

    // Check which columns in MariaDB are nullable (accept NULL)
    const [colInfo] = await cn.execute(`SHOW COLUMNS FROM ${quoted(table)}`);
    const nullableColumns = new Set<string>();
    for (const col of colInfo as { Field: string; Null: string }[]) {
      if (col.Null === 'YES') nullableColumns.add(col.Field);
    }

    for (const row of rows) {
      const values = columns.map(col => {
        const val = row[col];
        if (val instanceof Buffer) return val;
        if (val === null || val === undefined) return null;
        if (typeof val === 'string') {
          // Only convert empty string to NULL if the column accepts NULL
          if (val === '' && nullableColumns.has(col)) return null;
          return val;
        }
        if (typeof val === 'number') return val;
        if (typeof val === 'boolean') return val;
        return String(val);
      });
      await cn.execute(insertSql, values as mysql.ExecuteValues[]);
    }

    console.log(`  ${table}: ${rows.length} rows migrated`);
  }

  await cn.execute('SET FOREIGN_KEY_CHECKS = 1');
  sqlite.close();
  await cn.end();
  console.log('✓ Migration complete');
}

migrate().catch(err => {
  console.error('Migration failed:', err);
  process.exit(1);
});
