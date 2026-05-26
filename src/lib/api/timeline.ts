import { mockFetch } from './client'
import type { TimelineEvent } from '@/lib/types'

const MOCK_TIMELINE: TimelineEvent[] = [
  {
    id: '1',
    type: 'education',
    date: '2023-09',
    title: "Bachelor's in Computer Science",
    subtitle: 'University of Technology',
    description: 'Specializing in software engineering and network infrastructure. Coursework includes algorithms, network protocols, database systems, and web development.',
    tags: ['Computer Science', 'Networks', 'Algorithms'],
    icon: 'mdi:school',
    subProjects: [
      {
        title: 'Network Protocol Analyzer',
        description: 'Built a packet-level network analyzer in Python using Scapy. Captures and dissects TCP/IP, DNS, and HTTP traffic with a real-time web dashboard.',
        tags: ['Python', 'Scapy', 'Flask', 'D3.js'],
        imageUrl: 'https://picsum.photos/seed/net-analyzer/600/300',
      },
      {
        title: 'Smart Campus IoT Gateway',
        description: 'Designed an IoT gateway using Raspberry Pi that aggregates sensor data from classroom modules and pushes it to a cloud dashboard via MQTT.',
        tags: ['Raspberry Pi', 'MQTT', 'Node.js', 'InfluxDB'],
        imageUrl: 'https://picsum.photos/seed/iot-gateway/600/300',
      },
      {
        title: 'Database Benchmarking Suite',
        description: 'Developed a benchmarking tool comparing PostgreSQL, MongoDB, and Redis performance across read/write workloads with visual reports.',
        tags: ['PostgreSQL', 'MongoDB', 'Redis', 'Go'],
      },
    ],
  },
  {
    id: '2',
    type: 'experience',
    date: '2024-06',
    title: 'IT Intern',
    subtitle: 'Tech Company',
    description: 'Assisted with network configuration, server maintenance, and internal tool development. Gained hands-on experience with enterprise infrastructure.',
    tags: ['Network', 'Linux', 'Automation'],
    icon: 'mdi:briefcase',
  },
  {
    id: '3',
    type: 'education',
    date: '2025-09',
    title: "Master's in IT & Infrastructure",
    subtitle: 'Engineering School',
    description: 'Advanced studies in distributed systems, cloud infrastructure, cybersecurity, and advanced software architecture.',
    tags: ['Cloud', 'Security', 'Distributed Systems'],
    icon: 'mdi:school',
    subProjects: [
      {
        title: 'Distributed File System Simulator',
        description: 'Implemented a simplified GFS-like distributed file system in Go with replication, fault tolerance, and a CLI interface.',
        tags: ['Go', 'gRPC', 'Distributed Systems'],
        imageUrl: 'https://picsum.photos/seed/dist-fs/600/300',
      },
      {
        title: 'Kubernetes Cluster Autoscaler Plugin',
        description: 'Built a custom Kubernetes autoscaler that scales pods based on custom application-level metrics exposed via a metrics API.',
        tags: ['Kubernetes', 'Go', 'Prometheus'],
      },
    ],
  },
  {
    id: '4',
    type: 'experience',
    date: '2025-02',
    title: 'Freelance Developer & Sysadmin',
    subtitle: 'Self-employed',
    description: 'Building web applications and managing server infrastructure for small businesses. Full-stack development and deployment.',
    tags: ['Vue', 'Docker', 'DevOps'],
    icon: 'mdi:code-tags',
  },
  {
    id: '5',
    type: 'experience',
    date: '2024-01',
    title: 'Homelab & Self-hosting',
    subtitle: 'Personal Projects',
    description: 'Built and maintained a home server running 15+ services including Nextcloud, Pi-hole, Jellyfin, Prometheus/Grafana monitoring, and automated backups.',
    tags: ['Self-hosting', 'Docker', 'Monitoring'],
    icon: 'mdi:server',
  },
]

export async function getTimeline() {
  return mockFetch(MOCK_TIMELINE)
}

export async function getTimelineByType(type: TimelineEvent['type']) {
  const filtered = MOCK_TIMELINE.filter(e => e.type === type)
  return mockFetch(filtered)
}
