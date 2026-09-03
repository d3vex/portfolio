import 'reflect-metadata';
import 'dotenv/config';
import { DataSource } from 'typeorm';
import * as crypto from 'crypto';

// ─── Mock Data from front/src/lib/api/ ───────────────────────────────────────

interface MockSkill {
  id: string; name: string; category: string; level: number;
  icon: string; keywords: string[];
}

const MOCK_SKILLS: MockSkill[] = [
  { id: '1', name: 'Vue.js', category: 'dev', level: 85, icon: 'mdi:vuejs', keywords: ['Composition API', 'Pinia', 'Router', 'SSR'] },
  { id: '2', name: 'TypeScript', category: 'dev', level: 80, icon: 'mdi:language-typescript', keywords: ['Types', 'Generics', 'Interfaces'] },
  { id: '3', name: 'Python', category: 'dev', level: 85, icon: 'mdi:language-python', keywords: ['Flask', 'Async', 'Testing'] },
  { id: '4', name: 'Node.js', category: 'dev', level: 75, icon: 'mdi:nodejs', keywords: ['Express', 'API', 'WebSocket'] },
  { id: '5', name: 'Go', category: 'dev', level: 60, icon: 'mdi:language-go', keywords: ['CLI', 'Concurrency', 'HTTP'] },
  { id: '6', name: 'React', category: 'dev', level: 25, icon: 'mdi:react', keywords: ['Hooks', 'Next.js', 'Tailwind'] },
  { id: '7', name: 'Rust', category: 'dev', level: 15, icon: 'mdi:language-rust', keywords: ['Memory Safety', 'Concurrency', 'Performance'] },
  { id: '8', name: 'Docker', category: 'infra', level: 90, icon: 'mdi:docker', keywords: ['Compose', 'Dockerfile'] },
  { id: '9', name: 'Kubernetes', category: 'infra', level: 75, icon: 'mdi:kubernetes', keywords: ['Pods', 'Services', 'Helm', 'ArgoCD'] },
  { id: '10', name: 'Proxmox', category: 'infra', level: 75, icon: 'cib:proxmox', keywords: ['HA', 'Virtualization', 'Storage'] },
  { id: '11', name: 'Linux', category: 'sysadmin', level: 90, icon: 'mdi:linux', keywords: ['Shell', 'Systemd', 'Security'] },
  { id: '12', name: 'CI/CD', category: 'infra', level: 75, icon: 'cib:azure-pipelines', keywords: ['GitHub Actions', 'GitLab CI', 'Jenkins'] },
  { id: '13', name: 'MariaDB', category: 'dev', level: 80, icon: 'mdi:database', keywords: ['SQL', 'Indexing', 'Migration'] },
  { id: '14', name: 'Redis', category: 'infra', level: 70, icon: 'cib:redis', keywords: ['Caching', 'Pub/Sub', 'Session'] },
  { id: '15', name: 'MongoDB', category: 'dev', level: 10, icon: 'cib:mongodb', keywords: ['NoSQL', 'Aggregation', 'Indexes'] },
  { id: '16', name: 'Networking', category: 'sysadmin', level: 80, icon: 'mdi:wan', keywords: ['TCP/IP', 'DNS', 'Firewall', 'VPN'] },
  { id: '17', name: 'Git', category: 'dev', level: 85, icon: 'mdi:git', keywords: ['Versionning', 'Contribution', 'Workflows'] },
];

interface MockTimelineEvent {
  id: string; type: 'education' | 'experience';
  startDate: string; endDate?: string;
  title: string; subtitle: string; description: string;
  tags: string[]; icon: string;
  subProjects?: { title: string; description: string; tags: string[]; imageUrl?: string; link?: string }[];
}

const MOCK_TIMELINE: MockTimelineEvent[] = [
  {
    id: '1', type: 'education',
    startDate: '2021-09', endDate: '2024-07',
    title: "Baccalauréat in Science",
    subtitle: 'Lycée Paul Sabatier',
    description: 'Specializing in physics - chemical and Mathematics. I was developping in paralel my skills in IT and infrastructure through personal projects and online courses.',
    tags: ['Science', 'Baccalaureate', 'Mathematics', 'Physics', 'Chemistry'],
    icon: 'mdi:school',
    subProjects: [
      { title: 'Wallet Stealer', description: 'Built a wallet stealer in Python using multiprocessing, Mnemonic and BitcoinChain API.', tags: ['Python', 'threading', 'Crypto', 'API'], imageUrl: '/images/Wallet-Extractor.png' },
      { title: 'Crypto Market Analyzer', description: 'Designed a real-time cryptocurrency market analyzer using Python and WebSocket.', tags: ['Python', 'WebSocket', 'Crypto', 'Telegram Bot'] },
      { title: 'Discord Account Generator', description: 'Developed a Discord account generator with Yolo AI to bypass captcha.', tags: ['Python', 'Yolo', 'AI', 'Requests'] },
      { title: "Vinted Scraper & Auto-Buyer", description: "Created a Vinted scraper and auto-buyer using Node.js and fetch.", tags: ['Node.js', 'Fetch', 'Web Scraping', 'Automation', 'AI'], imageUrl: '/images/Vinted-bot-embed-item.png' },
    ],
  },
  {
    id: '2', type: 'education',
    startDate: '2024-09', endDate: '2027-08',
    title: 'IT Student - Infrastructure & DevOps',
    subtitle: 'Montpellier Ynov Campus - France',
    description: 'I learn the good practices I have been missing in my projects, and I am deepening my knowledge in infrastructure, networking, security and DevOps.',
    tags: ['Network', 'Linux', 'Automation', 'Cloud', 'Security', 'DevOps'],
    icon: 'mdi:account-school',
    subProjects: [
      { title: "HomeLab", description: "Built and maintained a home server running services such as Nextcloud, Nginx Proxy Manager, Jellyfin, Prometheus/Grafana.", tags: ['Self-hosting', 'Docker', 'Monitoring', 'Proxmox'] },
      { title: "Jellyfin Plugin", description: "Developed a plugin for Jellyfin that allows users to view media from byse.sx provider.", tags: ['Jellyfin', 'Plugin Development', 'C#'] },
      { title: "Byse.sx Uploader", description: "A script that automates video uploads to the platform.", tags: ['Python', 'Node.js', 'EJS', 'Automation'] },
      { title: "Discord Translator Bot", description: "A Discord bot for automatic message translation across language-specific channels.", tags: ['Node.js', 'Discord.js', 'Translation'] },
      { title: "Chief of Projects", description: "Led a team of 5 developers across a project (ProbaX).", tags: ['Project Management', 'Leadership', 'Trello'] },
    ],
  },
  {
    id: '3', type: 'experience',
    startDate: '2025-06', endDate: '2025-09',
    title: 'Administrative Assistant',
    subtitle: 'SAD - France',
    description: 'Provided administrative support to the team, including scheduling, managing correspondence, tracking process, and helping in comptability. This experience allowed me to develop organizational and communication skills, as well as a better understanding of the inner workings of a company.',
    tags: ['Web Development', 'Automation', 'Organization', 'Communication'],
    icon: 'mdi:briefcase-account',
  },
  {
    id: '4', type: 'experience',
    startDate: '2025-11', endDate: '2026-04',
    title: 'Full Stack Developer Intern',
    subtitle: 'NEEFT.fr - France',
    description: 'I worked as a full stack developer intern, contributing to various features and learning deeper technologies. I was involved in the development of many new features and helped while thinking about UX of the platform. I also had the opportunity to work closely with the CTO, which allowed me to gain valuable insights into the industry and further develop my skills.',
    tags: ['Web Development', 'Full Stack', 'NestJS', 'Vue.js', 'UX', 'UI', 'Teamwork'],
    icon: 'mdi:briefcase',
  },
];

interface MockProject {
  id: string; title: string; description: string; longDescription: string;
  category: string; technologies: string[]; imageUrl: string;
  liveUrl?: string; sourceUrl?: string;
  status: string; featured: boolean;
  timeline: { date: string; title: string; description: string; status: string; imageUrl?: string }[];
  createdAt: string; updatedAt: string;
}

const MOCK_PROJECTS: MockProject[] = [
  {
    id: '1', title: 'Portfolio Website',
    description: 'This interactive portfolio with terminal and animations elements',
    longDescription: 'Interactive portfolio built with Vue 3 featuring a terminal simulator, server animations, particle network background, and full i18n support.',
    category: 'dev',
    technologies: ['Vue 3', 'TypeScript', 'Three.js', 'Tailwind CSS', 'SCSS'],
    imageUrl: '', liveUrl: '', sourceUrl: '',
    status: 'in-progress', featured: true,
    timeline: [
      { date: '2025-11', title: 'Project setup', description: 'Developping a first version with main idea of styling', status: 'done' },
      { date: '2026-02', title: 'Ending project', description: 'I stopped working on it for a while due to other commitments', status: 'done' },
      { date: '2026-05', title: 'Restarting project', description: 'Not anymore in match with the first version, i started development of the current version', status: 'done' },
      { date: '2026-05', title: 'Seeding Data', description: 'Add all my projects, my experience and my skills', status: 'in-progress' },
      { date: '2026-06', title: 'Adding API', description: 'Adding an API to make all data accessible from the frontend and avoid mocking', status: 'todo' },
      { date: '2026-06', title: 'Adding feature', description: 'Adding a huge features for integrating kubernetes into the portfolio', status: 'todo' },
    ],
    createdAt: '2025-11-01', updatedAt: '2026-05-26',
  },
  {
    id: '2', title: 'Vinted Scrapper bot',
    description: 'This bot allows to easily track new items on Vinted and get notified when they are available based on user filter.',
    longDescription: 'This bot allows to easily track new items on Vinted and get notified when they are available based on user filter. It also allows to connect to the Vinted Account to automatically buy items when they are available or buy in one click listed item by the bot. The bot was able to get item in realtime and buy it in less than 2 seconds after it was listed.',
    category: 'dev',
    technologies: ['Node.JS', 'Proxy', 'Web-Scraping', 'AI', 'UX'],
    imageUrl: '', liveUrl: 'https://discord.gg/DuRMdjeT9u', sourceUrl: '',
    status: 'completed', featured: true,
    timeline: [
      { date: '2024-06', title: 'Project setup', description: 'Finding how to create the bot', status: 'done' },
      { date: '2024-06', title: 'Development', description: 'I made the bot connecting to vinted-API and fetch all new articles', status: 'done' },
      { date: '2024-07', title: 'Improve UX', description: 'Improve interaction with the bot on Discord', status: 'done' },
      { date: '2024-08', title: 'Managing first client', description: 'Handling the first client and their requests', status: 'done' },
      { date: '2024-08', title: 'Improvement', description: 'Trying to improve the bot performance to make it scrap even more articles (was stuck at 400/s)', status: 'done' },
      { date: '2024-09', title: 'Stopping project', description: 'Finding a better solution was taking too long', status: 'done' },
    ],
    createdAt: '2024-06-12', updatedAt: '2024-09-18',
  },
  {
    id: '3', title: 'Homelab',
    description: 'A personal home lab for experimenting with new technologies and hosting personal projects/tools',
    longDescription: 'My home-lab, built with Proxmox over two linked node allow me to experiment with new technologies and host personal projects/tools. It is also a good way to learn about infrastructure and sysadmin topics, and to have fun with it by creating cool projects and automations.',
    category: 'sysadmin',
    technologies: ['Proxmox', 'Kubernetes', 'Docker', 'Linux', 'Networking', 'Monitoring', 'Automation', 'Security', 'VXLAN', 'File sharing', 'Wireguard'],
    imageUrl: '', liveUrl: '', sourceUrl: '',
    status: 'in-progress', featured: false,
    timeline: [
      { date: '2025-12', title: 'Project setup', description: 'Setting up my first node with firewall and networking', status: 'done' },
      { date: '2025-12', title: 'Setting first service', description: 'I hosted my first service on the homelab', status: 'done' },
      { date: '2026-01', title: 'Adding more service', description: 'Adding new services such as Nextcloud, Obsidian Sync Server', status: 'done' },
      { date: '2026-03', title: 'Improving infrastructure', description: 'Adding a new 6TB storage array', status: 'done' },
      { date: '2026-03', title: 'Improving infrastructure', description: 'Adding new low-power node', status: 'done' },
      { date: '2026-03', title: 'Improving network', description: 'Linking my 2 nodes sub-network by a VXLAN', status: 'done' },
      { date: '2026-03', title: 'Improving utility', description: 'Adding a Wake-on-LAN feature', status: 'done' },
      { date: '2026-05', title: 'More service', description: 'Implementing additional services', status: 'done' },
      { date: '2026-07', title: 'Expanding services', description: 'Implement much services and starting hosting my project for real on it', status: 'in-progress' },
    ],
    createdAt: '2024-01-10', updatedAt: '2024-06-20',
  },
  {
    id: '4', title: "ProbabilityX",
    description: "A multi-tool project to regroup data allowing user to analyse financial market easier",
    longDescription: "ProbabilityX is a multi-tool project to regroup data from multi-sources such as X, Yahoo, Spotify, Youtube, and other, allowing user to analyse financial market easier.",
    category: 'dev',
    technologies: ['Angular', 'C#', 'Dotnet', 'Entity Framework', 'Financial Analysis', 'Data Visualization'],
    imageUrl: '', liveUrl: 'https://probax.swebystudio.fr', sourceUrl: '',
    status: 'in-progress', featured: false,
    timeline: [
      { date: '2024-10', title: 'Project setup', description: 'I joined this project as a Student', status: 'done' },
      { date: '2024-11', title: 'API development', description: 'Developing the API with C# and dotnet', status: 'done' },
      { date: '2025-01', title: 'Role change', description: 'I kept the role of a Student, but now I focus on infrastructure', status: 'done' },
      { date: '2026-01', title: 'Continued working on Frontend', description: 'Implement new UI components, improve UX', status: 'done' },
      { date: '2026-03', title: 'Feature development', description: 'Refactored authentification system with SSO and WebAuthN', status: 'done' },
    ],
    createdAt: '2024-10-15', updatedAt: '2025-01-10',
  },
  {
    id: '5', title: "ProbabilityX - Infrastructure",
    description: "The ProbaX multi-tool project, but with a focus on the infrastructure side",
    longDescription: "ProbabilityX is a multi-tool project to regroup data from multi-sources. I worked on setting up and maintaining the infrastructure to support the development and deployment of the project. I set up a Kubernetes cluster on our homelab to host the different services, implemented CI/CD pipelines using ArgoCD, and optimized performance with caching and load balancing.",
    category: 'infra',
    technologies: ['Kubernetes', 'ArgoCD', 'Docker', 'HA', 'CI/CD'],
    imageUrl: '', liveUrl: 'https://probax.swebystudio.fr', sourceUrl: '',
    status: 'in-progress', featured: false,
    timeline: [
      { date: '2024-10', title: 'Project setup', description: 'I joined this project as a Student', status: 'done' },
      { date: '2024-11', title: 'API development', description: 'Developing the API with C# and dotnet', status: 'done' },
      { date: '2025-01', title: 'Role change', description: 'I focus on infrastructure', status: 'done' },
      { date: '2026-01', title: 'Continued working on Frontend', description: 'Implement new UI components', status: 'done' },
      { date: '2026-03', title: 'Feature development', description: 'Refactored authentification system with SSO and WebAuthN', status: 'done' },
    ],
    createdAt: '2024-10-15', updatedAt: '2025-01-10',
  },
];

// ─── Helpers ─────────────────────────────────────────────────────────────────

function sha256(password: string): string {
  return crypto.createHash('sha256').update(password).digest('hex');
}

// ─── Main Seed Function ──────────────────────────────────────────────────────

async function seed() {
  const ds = new DataSource({
    type: 'mariadb',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306', 10),
    username: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'cvmanager',
    entities: [__dirname + '/**/*.entity{.ts,.js}'],
    synchronize: true,
    logging: false,
  });

  await ds.initialize();
  // The seed uses double-quoted identifiers (SQLite/Postgres style); MariaDB
  // only treats `"..."` as identifiers with ANSI_QUOTES enabled, so scope it
  // to this connection's session instead of rewriting every query.
  await ds.query('SET SESSION sql_mode = CONCAT(@@sql_mode, ",ANSI_QUOTES")');
  console.log('📦 Connected to database\n');

  const em = ds.manager;

  // ── 1. Clear existing data (order matters for FK constraints) ──────────
  console.log('🗑️  Clearing existing data...');
  await em.query('DELETE FROM skills');
  await em.query('DELETE FROM projects');
  await em.query('DELETE FROM experiences');
  await em.query('DELETE FROM education');
  await em.query('DELETE FROM languages');
  await em.query('DELETE FROM passions');
  await em.query('DELETE FROM contacts');
  await em.query('DELETE FROM profiles');
  await em.query('DELETE FROM categories');
  await em.query('DELETE FROM users');
  await em.query('DELETE FROM cvs');
  console.log('   Done\n');

  // ── 2. Categories ──────────────────────────────────────────────────────
  console.log('🏷️  Seeding categories...');
  const categories: { id: string; name: string; label: string; icon: string; description: string; order: number }[] = [];
  const catData = [
    { name: 'dev',       label: 'Development',        icon: 'mdi:code',                description: 'Web development, software engineering, and application development' },
    { name: 'infra',     label: 'Infrastructure',      icon: 'mdi:server',              description: 'Infrastructure, DevOps, and cloud technologies' },
    { name: 'sysadmin',  label: 'System Administration', icon: 'mdi:monitor-dashboard', description: 'System administration, networking, and IT support' },
  ];
  for (let i = 0; i < catData.length; i++) {
    const c = catData[i];
    const result = await em.query(
      `INSERT INTO categories (id, name, label, icon, description, "order") VALUES (?, ?, ?, ?, ?, ?) RETURNING id`,
      [crypto.randomUUID(), c.name, c.label, c.icon, c.description, i]
    );
    categories.push({ id: result[0].id, ...c, order: i });
    console.log(`   ✅ Category: ${c.label}`);
  }

  // Build lookup maps
  const categoryByName: Record<string, string> = {};
  for (const c of categories) categoryByName[c.name] = c.id;

  // ── 3. Contacts ────────────────────────────────────────────────────────
  console.log('\n📞 Seeding contacts...');
  const contactData = [
    { label: 'Phone number', value: '+33 7 64 02 11 78',        icon: 'mdi:telephone', type: 'info', isPrivate: false },
    { label: 'Email',        value: 'loanmata4@gmail.com',      icon: 'mdi:email',     type: 'info', isPrivate: false },
    { label: 'City',         value: 'Combaillaux, 34980',       icon: 'mdi:map-marker', type: 'info', isPrivate: true },
    { label: 'LinkedIn',     value: 'https://linkedin.com/in/loan-mata', icon: 'mdi:linkedin', type: 'link', isPrivate: false },
    { label: 'GitHub',       value: 'https://github.com/d3vex', icon: 'mdi:github',    type: 'link', isPrivate: false },
  ];
  for (let i = 0; i < contactData.length; i++) {
    const c = contactData[i];
    await em.query(
      `INSERT INTO contacts (id, label, value, icon, type, "isPrivate", "order") VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [crypto.randomUUID(), c.label, c.value, c.icon, c.type, c.isPrivate, i]
    );
    console.log(`   ✅ Contact: ${c.label}`);
  }

  // ── 4. Profile ─────────────────────────────────────────────────────────
  console.log('\n👤 Seeding profile...');
  await em.query(
    `INSERT INTO profiles (id, "firstName", "lastName", initials, "photoUrl", availability, about, specialization) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      crypto.randomUUID(),
      'Loan', 'MATA', 'LM', '',
      "Recherche d'alternance: 1 sem ecole/ 2 semaine entreprise",
      `I am a passionate Full-Stack developer and infrastructure enthusiast currently studying at Montpellier Ynov Campus. I have hands-on experience with Vue 3, TypeScript, Python, Docker, Kubernetes, and cloud technologies. I love building interactive web applications, automating workflows, and experimenting with homelab infrastructure. I am always looking for new challenges and opportunities to learn and grow in the field of IT.`,
      'webdev',
    ]
  );
  console.log('   ✅ Profile: Loan MATA');

  // ── 5. Skills ──────────────────────────────────────────────────────────
  console.log('\n🔧 Seeding skills...');
  const skillIds: Record<string, string> = {};
  for (let i = 0; i < MOCK_SKILLS.length; i++) {
    const s = MOCK_SKILLS[i];
    const id = crypto.randomUUID();
    const categoryId = categoryByName[s.category] || null;
    const cvCategory = s.category === 'sysadmin' ? 'soft' : 'hard';
    await em.query(
      `INSERT INTO skills (id, name, icon, "categoryId", "cvCategory", description, level, "order") VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [id, s.name, s.icon, categoryId, cvCategory, null, s.level, i]
    );
    for (const kw of s.keywords) {
      await em.query(
        `INSERT INTO skill_keywords ("skillId", value) VALUES (?, ?)`,
        [id, kw]
      );
    }
    skillIds[s.id] = id;
    console.log(`   ✅ Skill: ${s.name} (${s.level}%)`);
  }

  // ── 6. Languages ───────────────────────────────────────────────────────
  console.log('\n🌐 Seeding languages...');
  const langData = [
    { name: 'Français', level: 'Maternelle' },
    { name: 'Anglais',  level: 'TOEIC 785/990' },
  ];
  const languageIds: string[] = [];
  for (let i = 0; i < langData.length; i++) {
    const l = langData[i];
    const id = crypto.randomUUID();
    await em.query(
      `INSERT INTO languages (id, name, level, "order") VALUES (?, ?, ?, ?)`,
      [id, l.name, l.level, i]
    );
    languageIds.push(id);
    console.log(`   ✅ Language: ${l.name}`);
  }

  // ── 7. Passions ────────────────────────────────────────────────────────
  console.log('\n🔥 Seeding passions...');
  const passionData = [
    { name: 'Informatique', description: 'Passionate about IT, programming, and new technologies', icon: 'mdi:computer' },
    { name: 'Calisthenie',  description: 'Bodyweight training and fitness', icon: 'arcticons:calisteniapp' },
    { name: 'Engagement',   description: 'Committed to projects, teamwork, and community', icon: 'mdi:people' },
  ];
  const passionIds: string[] = [];
  for (let i = 0; i < passionData.length; i++) {
    const p = passionData[i];
    const id = crypto.randomUUID();
    await em.query(
      `INSERT INTO passions (id, name, description, icon, "order") VALUES (?, ?, ?, ?, ?)`,
      [id, p.name, p.description, p.icon, i]
    );
    passionIds.push(id);
    console.log(`   ✅ Passion: ${p.name}`);
  }

  // Helper to link skill keywords / points to skills by name
  const skillIdByName: Record<string, string> = {};
  for (const ms of MOCK_SKILLS) {
    skillIdByName[ms.name.toLowerCase()] = skillIds[ms.id];
  }
  const skillIdsFor = (names: string[]): string[] =>
    names
      .map((n) => skillIdByName[n.toLowerCase()])
      .filter((id): id is string => Boolean(id));

  // ── 8. Education (from timeline mock data) ──────────────────────────────
  console.log('\n🎓 Seeding education...');
  const educationIds: Record<string, string> = {};
  const timelineEducations = MOCK_TIMELINE.filter(e => e.type === 'education');
  for (let i = 0; i < timelineEducations.length; i++) {
    const e = timelineEducations[i];
    const id = crypto.randomUUID();
    await em.query(
      `INSERT INTO education (id, title, school, "startDate", "endDate", description, "order") VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [id, e.title, e.subtitle, e.startDate, e.endDate || null, e.description, i]
    );
    for (const tag of e.tags) {
      await em.query(
        `INSERT INTO education_tags ("educationId", value) VALUES (?, ?)`,
        [id, tag]
      );
    }
    educationIds[e.id] = id;
    console.log(`   ✅ Education: ${e.title} @ ${e.subtitle}`);
  }

  // ── 9. Experiences (from timeline mock data) ────────────────────────────
  console.log('\n💼 Seeding experiences...');
  const experienceIds: Record<string, string> = {};
  const timelineExperiences = MOCK_TIMELINE.filter(e => e.type === 'experience');
  for (let i = 0; i < timelineExperiences.length; i++) {
    const e = timelineExperiences[i];
    const id = crypto.randomUUID();
    await em.query(
      `INSERT INTO experiences (id, title, company, "startDate", "endDate", description, "order") VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [id, e.title, e.subtitle, e.startDate, e.endDate || null, e.description, i]
    );
    for (const tag of e.tags) {
      await em.query(
        `INSERT INTO experience_tags ("experienceId", value) VALUES (?, ?)`,
        [id, tag]
      );
    }
    // One point per experience, derived from its description
    const pointId = crypto.randomUUID();
    await em.query(
      `INSERT INTO experience_points (id, text, "order", "experienceId") VALUES (?, ?, ?, ?)`,
      [pointId, e.description, 0, id]
    );
    for (const skillId of skillIdsFor(e.tags)) {
      await em.query(
        `INSERT INTO experience_point_skills ("pointId", "skillId") VALUES (?, ?)`,
        [pointId, skillId]
      );
    }
    experienceIds[e.id] = id;
    console.log(`   ✅ Experience: ${e.title} @ ${e.subtitle}`);
  }

  // ── 10. Projects (from mock data) ───────────────────────────────────────
  console.log('\n📁 Seeding projects...');
  const projectIds: string[] = [];
  for (const mp of MOCK_PROJECTS) {
    const id = crypto.randomUUID();
    const catId = categoryByName[mp.category];
    await em.query(
      `INSERT INTO projects (id, title, description, "longDescription", status, featured, "imageUrl", "createdAt", "updatedAt", "order") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        id, mp.title, mp.description, mp.longDescription,
        mp.status, mp.featured ? 1 : 0,
        mp.imageUrl || null,
        mp.createdAt, mp.updatedAt, projectIds.length,
      ]
    );
    if (catId) {
      await em.query(
        `INSERT INTO project_categories ("projectsId", "categoriesId") VALUES (?, ?)`,
        [id, catId]
      );
    }
    for (const tech of mp.technologies) {
      await em.query(
        `INSERT INTO project_technologies ("projectId", name) VALUES (?, ?)`,
        [id, tech]
      );
    }
    // Project links: demo/live link first (as the primary), then source link
    let linkOrder = 0;
    const demoUrl = mp.liveUrl || mp.sourceUrl;
    if (demoUrl) {
      await em.query(
        `INSERT INTO links (id, label, url, type, "order", "projectId") VALUES (?, ?, ?, ?, ?, ?)`,
        [crypto.randomUUID(), 'Demo', demoUrl, 'demo', linkOrder++, id]
      );
    }
    if (mp.sourceUrl && mp.sourceUrl !== mp.liveUrl) {
      await em.query(
        `INSERT INTO links (id, label, url, type, "order", "projectId") VALUES (?, ?, ?, ?, ?, ?)`,
        [crypto.randomUUID(), 'Source', mp.sourceUrl, 'source', linkOrder++, id]
      );
    }
    // Project points derived from the timeline entries, with skill links
    const techSkillIds = skillIdsFor(mp.technologies);
    for (let ti = 0; ti < mp.timeline.length; ti++) {
      const t = mp.timeline[ti];
      await em.query(
        `INSERT INTO project_timeline_entries (id, date, title, description, status, "imageUrl", "projectId", "order") VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        [crypto.randomUUID(), t.date, t.title, t.description, t.status, t.imageUrl || null, id, ti]
      );
      const pointId = crypto.randomUUID();
      await em.query(
        `INSERT INTO project_points (id, text, "order", "projectId") VALUES (?, ?, ?, ?)`,
        [pointId, t.description, ti, id]
      );
      for (const skillId of techSkillIds) {
        await em.query(
          `INSERT INTO project_point_skills ("pointId", "skillId") VALUES (?, ?)`,
          [pointId, skillId]
        );
      }
    }
    projectIds.push(id);
    console.log(`   ✅ Project: ${mp.title}`);
  }

  // ── 11. CV ──────────────────────────────────────────────────────────────
  console.log('\n📄 Seeding CV...');
  const cvId = crypto.randomUUID();
  const allSkillIds = Object.values(skillIds);
  const allExperienceIds = Object.values(experienceIds);
  const allEducationIds = Object.values(educationIds);
  await em.query(
    `INSERT INTO cvs (id, name, specialization, "aboutText", availability, "isDefault", style) VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [
      cvId, 'Loan MATA', 'webdev',
      'I am a passionate Full-Stack developer and infrastructure enthusiast currently studying at Montpellier Ynov Campus. I have hands-on experience with Vue 3, TypeScript, Python, Docker, Kubernetes, and cloud technologies.',
      "Recherche d'alternance: 1 sem ecole/ 2 semaine entreprise",
      1,
      'classic',
    ]
  );
  for (let i = 0; i < allSkillIds.length; i++) {
    await em.query(
      `INSERT INTO cv_skills ("cvId", "skillId", "order") VALUES (?, ?, ?)`,
      [cvId, allSkillIds[i], i]
    );
  }
  for (const lid of languageIds) {
    await em.query(
      `INSERT INTO cv_languages ("cvsId", "languagesId") VALUES (?, ?)`,
      [cvId, lid]
    );
  }
  for (let i = 0; i < passionIds.length; i++) {
    await em.query(
      `INSERT INTO cv_passions ("cvId", "passionId", "order") VALUES (?, ?, ?)`,
      [cvId, passionIds[i], i]
    );
  }
  for (const eid of allExperienceIds) {
    await em.query(
      `INSERT INTO cv_experiences ("cvsId", "experiencesId") VALUES (?, ?)`,
      [cvId, eid]
    );
  }
  for (let i = 0; i < projectIds.length; i++) {
    await em.query(
      `INSERT INTO cv_projects ("cvId", "projectId", "order") VALUES (?, ?, ?)`,
      [cvId, projectIds[i], i]
    );
  }
  // Select the first two points of every project so point bullets render on
  // the seeded CV (keeps a representative subset per project).
  const selectedPointIds: string[] = [];
  for (const projectId of projectIds) {
    const rows: { id: string }[] = await em.query(
      `SELECT id FROM project_points WHERE "projectId" = ? ORDER BY "order" LIMIT 2`,
      [projectId]
    );
    for (const row of rows) selectedPointIds.push(row.id);
  }
  for (const projectPointId of selectedPointIds) {
    await em.query(
      `INSERT INTO cv_project_points ("cvId", "projectPointId") VALUES (?, ?)`,
      [cvId, projectPointId]
    );
  }
  for (const eid of allEducationIds) {
    await em.query(
      `INSERT INTO cv_education ("cvsId", "educationId") VALUES (?, ?)`,
      [cvId, eid]
    );
  }
  console.log('   ✅ CV: Loan MATA (default)\n');

  // ── 12. Default User ────────────────────────────────────────────────────
  console.log('🔐 Seeding default user...');
  await em.query(
    `INSERT INTO users (id, username, password, role) VALUES (?, ?, ?, ?)`,
    [crypto.randomUUID(), 'admin', sha256('password'), 'editor']
  );
  console.log('   ✅ User: admin / password\n');

  // ── Done ───────────────────────────────────────────────────────────────
  await ds.destroy();

  console.log('═══════════════════════════════════════════');
  console.log('  ✅  Seeding complete!');
  console.log('───────────────────────────────────────────');
  console.log(`  Categories:  ${categories.length}`);
  console.log(`  Contacts:    ${contactData.length}`);
  console.log(`  Profile:     1`);
  console.log(`  Skills:      ${MOCK_SKILLS.length}`);
  console.log(`  Languages:   ${langData.length}`);
  console.log(`  Passions:    ${passionData.length}`);
  console.log(`  Education:   ${timelineEducations.length}`);
  console.log(`  Experiences: ${timelineExperiences.length}`);
  console.log(`  Projects:    ${MOCK_PROJECTS.length}`);
  console.log(`  CVs:         1`);
  console.log(`  Users:       1`);
  console.log('═══════════════════════════════════════════');
}

seed().catch(err => {
  console.error('\n❌ Seeding failed:', err);
  process.exit(1);
});
