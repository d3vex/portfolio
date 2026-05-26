import { mockFetch, mockPaginatedFetch } from './client'
import type { Project } from '@/lib/types'

const MOCK_PROJECTS: Project[] = [
  {
    id: '1',
    title: 'Cloud Infrastructure Manager',
    description: 'Dashboard for managing cloud resources across multiple providers',
    longDescription: 'A comprehensive dashboard built with Vue 3 that allows managing virtual machines, containers, and network configurations across AWS, GCP, and Azure from a single interface. Features real-time monitoring, cost tracking, and automated deployment pipelines.',
    category: 'infra',
    technologies: ['Vue 3', 'TypeScript', 'WebSocket', 'Docker', 'Kubernetes', 'Terraform'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'in-progress',
    featured: true,
    timeline: [
      { date: '2025-01', title: 'Project planning', description: 'Defined architecture and tech stack', status: 'done' },
      { date: '2025-02', title: 'Core dashboard UI', description: 'Built main dashboard layout with real-time widgets', status: 'done', imageUrl: 'https://picsum.photos/seed/cloud-dash/600/340' },
      { date: '2025-03', title: 'API integration', description: 'Connected to cloud provider APIs', status: 'in-progress', imageUrl: 'https://picsum.photos/seed/cloud-api/600/340' },
      { date: '2025-04', title: 'Deployment automation', description: 'Add one-click deployment pipelines', status: 'todo' },
    ],
    createdAt: '2025-01-15',
    updatedAt: '2025-03-10',
  },
  {
    id: '2',
    title: 'Homelab Monitoring Stack',
    description: 'Full observability platform for home server infrastructure',
    longDescription: 'Complete monitoring solution using Prometheus, Grafana, and Loki to track metrics, logs, and alerts across a homelab environment with 10+ services.',
    category: 'sysadmin',
    technologies: ['Prometheus', 'Grafana', 'Docker', 'Linux', 'Bash', 'NGINX'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'completed',
    featured: true,
    timeline: [
      { date: '2024-09', title: 'Architecture design', description: 'Planned monitoring architecture', status: 'done', imageUrl: 'https://picsum.photos/seed/monitor-arch/600/340' },
      { date: '2024-10', title: 'Stack deployment', description: 'Deployed Prometheus + Grafana stack', status: 'done' },
      { date: '2024-11', title: 'Alerting setup', description: 'Configured alerting rules and notifications', status: 'done', imageUrl: 'https://picsum.photos/seed/monitor-alert/600/340' },
      { date: '2024-12', title: 'Documentation', description: 'Wrote setup guide and documentation', status: 'done' },
    ],
    createdAt: '2024-09-01',
    updatedAt: '2024-12-15',
  },
  {
    id: '3',
    title: 'Portfolio Website',
    description: 'This interactive portfolio with terminal and 3D elements',
    longDescription: 'Interactive portfolio built with Vue 3 featuring a terminal simulator, 3D server rack visualization, particle network background, and full i18n support.',
    category: 'dev',
    technologies: ['Vue 3', 'TypeScript', 'Three.js', 'Tailwind CSS', 'SCSS'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'in-progress',
    featured: true,
    timeline: [
      { date: '2025-03', title: 'Project setup', description: 'Scaffolded Vue 3 + Vite project', status: 'done' },
      { date: '2025-03', title: 'Design system', description: 'Created UI components and theming', status: 'done' },
      { date: '2025-04', title: 'Terminal feature', description: 'Built interactive terminal simulator', status: 'in-progress' },
      { date: '2025-04', title: '3D elements', description: 'Add 3D server rack and particles', status: 'todo' },
    ],
    createdAt: '2025-03-01',
    updatedAt: '2025-03-20',
  },
  {
    id: '4',
    title: 'CI/CD Pipeline Automation',
    description: 'Automated build, test, and deploy pipeline for microservices',
    longDescription: 'End-to-end CI/CD pipeline using GitHub Actions, Docker, and ArgoCD for automated testing, building, and deployment of microservices architecture.',
    category: 'infra',
    technologies: ['GitHub Actions', 'Docker', 'ArgoCD', 'Kubernetes', 'Helm', 'Go'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'completed',
    featured: false,
    timeline: [
      { date: '2024-06', title: 'Pipeline design', description: 'Designed CI/CD workflow', status: 'done' },
      { date: '2024-07', title: 'Implementation', description: 'Built GitHub Actions workflows', status: 'done' },
      { date: '2024-08', title: 'ArgoCD setup', description: 'Configured GitOps deployment', status: 'done' },
    ],
    createdAt: '2024-06-01',
    updatedAt: '2024-08-20',
  },
  {
    id: '5',
    title: 'Network Traffic Analyzer',
    description: 'Real-time network traffic monitoring and analysis tool',
    longDescription: 'Python-based network traffic analyzer with a web dashboard for visualizing packet flow, detecting anomalies, and generating reports.',
    category: 'sysadmin',
    technologies: ['Python', 'Scapy', 'Flask', 'React', 'D3.js', 'Wireshark'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'completed',
    featured: false,
    timeline: [
      { date: '2024-04', title: 'Packet capture engine', description: 'Built packet capture module', status: 'done' },
      { date: '2024-05', title: 'Analysis algorithms', description: 'Implemented traffic analysis', status: 'done' },
      { date: '2024-06', title: 'Dashboard', description: 'Created visualization dashboard', status: 'done' },
    ],
    createdAt: '2024-04-01',
    updatedAt: '2024-06-15',
  },
]

export async function getProjects(page = 1, pageSize = 10) {
  return mockPaginatedFetch(MOCK_PROJECTS, page, pageSize)
}

export async function getProject(id: string) {
  const project = MOCK_PROJECTS.find(p => p.id === id)
  if (!project) {
    return { data: null, error: 'Project not found', loading: false }
  }
  return mockFetch(project)
}

export async function getFeaturedProjects() {
  const featured = MOCK_PROJECTS.filter(p => p.featured)
  return mockFetch(featured)
}

export async function getProjectsByCategory(category: Project['category']) {
  const filtered = MOCK_PROJECTS.filter(p => p.category === category)
  return mockFetch(filtered)
}
