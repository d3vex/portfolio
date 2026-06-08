import { mockFetch } from './client'
import type { TimelineEvent } from '@/lib/types'

const MOCK_TIMELINE: TimelineEvent[] = [
  {
    id: '1',
    type: 'education',
    startDate: '2021-09',
    endDate: '2024-07',
    title: "Baccalauréat in Science",
    subtitle: 'Lycée Paul Sabatier',
    description: 'Specializing in physics - chemical and Mathematics. I was developping in paralel my skills in IT and infrastructure through personal projects and online courses.',
    tags: ['Science', 'Baccalaureate', 'Mathematics', 'Physics', 'Chemistry'],
    icon: 'mdi:school',
    subProjects: [
      {
        title: 'Wallet Stealer',
        description: 'Built a wallet stealer in Python using multiprocessing, Mnemonic and BitcoinChain API.',
        tags: ['Python', 'threading', 'Crypto', 'API'],
        imageUrl: '/images/Wallet-Extractor.png',
      },
      {
        title: 'Crypto Market Analyzer',
        description: 'Designed a real-time cryptocurrency market analyzer using Python and WebSocket. It provides live updates on price movements and trading volumes based on indicators.',
        tags: ['Python', 'WebSocket', 'Crypto', 'Telegram Bot'],
      },
      {
        title: 'Discord Account Generator',
        description: 'Developed a Discord account generator with Yolo AI to bypass captcha. This project was capable of generating a hundred accounts per hours',
        tags: ['Python', 'Yolo', 'AI', 'Requests'],
      },
      {
        title: "Vinted Scraper & Auto-Buyer",
        description: "Created a Vinted scraper and auto-buyer using Node.js and fetch. It monitored items and filter them by what user wanted, and automatically purchased them if user wanted, or simply display in a discord channel. Main concurrent to V-tools, with AI integration for better experience.",
        tags: ['Node.js', 'Fetch', 'Web Scraping', 'Automation', 'AI'],
        imageUrl: '/images/Vinted-bot-embed-item.png',
      }
    ],
  },
  {
    id: '2',
    type: 'education',
    startDate: '2024-09',
    endDate: '2027-08',
    title: 'IT Student - Infrastructure & DevOps',
    subtitle: 'Montpellier Ynov Campus - France',
    description: 'I learn the good practices I have been missing in my projects, and I am deepening my knowledge in infrastructure, networking, security and DevOps.',
    tags: ['Network', 'Linux', 'Automation', 'Cloud', 'Security', 'DevOps',],
    icon: 'mdi:account-school',
    subProjects: [
      {title: "HomeLab", description: "Built and maintained a home server running services such as Nextcloud, Nginx Proxy Manager, Jellyfin, Prometheus/Grafana, Obsidian Live-sync, and other, with automated backups.", tags: ['Self-hosting', 'Docker', 'Monitoring', 'Proxmox']},
      {title: "Jellyfin Plugin", description: "Developed a plugin for Jellyfin that allows users to view media from byse.sx provider.", tags: ['Jellyfin', 'Plugin Development', 'C#']},
      {title: "Byse.sx Uploader", description: "I was boring of manually upload videos to the platform, so i decided to make a script that automates the process and do everything in background on remote server!", tags: ['Python', 'Node.js', 'EJS', 'Automation']},
      {title: "Discord Translator Bot", description: "Created a Discord bot that allow user to set channel language, and group them so all message automatically get translated in the right language and send in the right channel. Powered by OpenSource translator, it was very accurate", tags: ['Node.js', 'Discord.js', 'Translation'] },
      {title: "Chief of Projects", description: "Led a team of 5 developers across a project. Managing team and resources to ship features on time. (ProbaX)", tags: ['Project Management', 'Leadership', 'Trello'] },
    ]
  },
  {
    id: '3',
    type: 'experience',
    startDate: '2025-06',
    endDate: '2025-09',
    title: 'Administrative Assistant',
    subtitle: 'SAD - France',
    description: 'Provided administrative support to the team, including scheduling, managing correspondence, tracking process, and helping in comptability. This experience allowed me to develop organizational and communication skills, as well as a better understanding of the inner workings of a company.',
    tags: ['Web Development', 'Automation', 'Organization', 'Communication'],
    icon: 'mdi:briefcase-account',
  },
  {
    id: '4',
    type: 'experience',
    startDate: '2025-11',
    endDate: '2026-04',
    title: 'Full Stack Developer Intern',
    subtitle: 'NEEFT.fr - France',
    description: 'I worked as a full stack developer intern, contributing to various features and learning deeper technologies. I was involved in the development of many new features and helped while thinking about UX of the platform. I also had the opportunity to work closely with the CTO, which allowed me to gain valuable insights into the industry and further develop my skills.',
    tags: ['Web Development', 'Full Stack', 'NestJS', 'Vue.js', 'UX', 'UI', 'Teamwork'],
    icon: 'mdi:briefcase'
  }
]

export async function getTimeline() {
  return mockFetch(MOCK_TIMELINE)
}

export async function getTimelineByType(type: TimelineEvent['type']) {
  const filtered = MOCK_TIMELINE.filter(e => e.type === type)
  return mockFetch(filtered)
}
