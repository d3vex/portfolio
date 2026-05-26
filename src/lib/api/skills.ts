import { mockFetch } from './client'
import type { Skill } from '@/lib/types'

const MOCK_SKILLS: Skill[] = [
  { id: '1', name: 'Vue.js', category: 'dev', level: 85, icon: 'mdi:vuejs', keywords: ['Composition API', 'Pinia', 'Router', 'SSR'] },
  { id: '2', name: 'TypeScript', category: 'dev', level: 80, icon: 'mdi:language-typescript', keywords: ['Types', 'Generics', 'Interfaces'] },
  { id: '3', name: 'Python', category: 'dev', level: 85, icon: 'mdi:language-python', keywords: ['Flask', 'Async', 'Testing'] },
  { id: '4', name: 'Node.js', category: 'dev', level: 75, icon: 'mdi:nodejs', keywords: ['Express', 'API', 'WebSocket'] },
  { id: '5', name: 'Go', category: 'dev', level: 60, icon: 'mdi:language-go', keywords: ['CLI', 'Concurrency', 'HTTP'] },
  { id: '6', name: 'React', category: 'dev', level: 25, icon: 'mdi:react', keywords: ['Hooks', 'Next.js', 'Tailwind'] },
  { id: '7', name: 'Rust', category: 'dev', level: 15, icon: 'mdi:language-rust', keywords: ['Memory Safety', 'Concurrency', 'Performance'] },
  { id: '8', name: 'Docker', category: 'infra', level: 90, icon: 'mdi:docker', keywords: ['Compose', 'Dockerfile'] },
  { id: '9', name: 'Kubernetes', category: 'infra', level: 75, icon: 'mdi:kubernetes', keywords: ['Pods', 'Services', 'Helm', 'ArgoCD'] },
  { id: '10', name: 'Linux', category: 'sysadmin', level: 90, icon: 'mdi:linux', keywords: ['Shell', 'Systemd', 'Security'] },
  { id: '11', name: 'CI/CD', category: 'infra', level: 75, icon: 'mdi:pipeline', keywords: ['GitHub Actions', 'GitLab CI', 'Jenkins'] },
  { id: '12', name: 'MariaDB', category: 'dev', level: 80, icon: 'mdi:database', keywords: ['SQL', 'Indexing', 'Migration'] },
  { id: '13', name: 'Redis', category: 'infra', level: 70, icon: 'mdi:redis', keywords: ['Caching', 'Pub/Sub', 'Session'] },
  { id: '14', name: 'MongoDB', category: 'dev', level: 10, icon: 'mdi:mongodb', keywords: ['NoSQL', 'Aggregation', 'Indexes'] },
  { id: '15', name: 'Networking', category: 'sysadmin', level: 80, icon: 'mdi:wan', keywords: ['TCP/IP', 'DNS', 'Firewall', 'VPN'] },
  { id: '16', name: 'Git', category: 'dev', level: 85, icon: 'mdi:git', keywords: ['Branching', 'Rebase', 'Workflows'] },
]

export async function getSkills() {
  return mockFetch(MOCK_SKILLS)
}

export async function getSkillsByCategory(category: Skill['category']) {
  const filtered = MOCK_SKILLS.filter(s => s.category === category)
  return mockFetch(filtered)
}
