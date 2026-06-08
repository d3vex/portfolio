import { mockFetch, mockPaginatedFetch } from './client'
import type { Project } from '@/lib/types'

const MOCK_PROJECTS: Project[] = [
  {
    id: '1',
    title: 'Portfolio Website',
    description: 'This interactive portfolio with terminal and animations elements',
    longDescription: 'Interactive portfolio built with Vue 3 featuring a terminal simulator, server animations, particle network background, and full i18n support.',
    category: 'dev',
    technologies: ['Vue 3', 'TypeScript', 'Three.js', 'Tailwind CSS', 'SCSS'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'in-progress',
    featured: true,
    timeline: [
      { date: '2025-11', title: 'Project setup', description: 'Developping a first version with main idea of styling', status: 'done' },
      { date: '2026-02', title: 'Ending project', description: 'I stopped working on it for a while due to other commitments', status: 'done' },
      { date: '2026-05', title: 'Restarting project', description: 'Not anymore in match with the first version, i started development of the current version', status: 'done' },
      { date: '2026-05', title: 'Seeding Data', description: 'Add all my projects, my experience and my skills', status: 'in-progress' },
      { date: '2026-06', title: 'Adding API', description: 'Adding an API to make all data accessible from the frontend and avoid mocking', status: 'todo' },
      { date: '2026-06', title: 'Adding feature', description: 'Adding a huge features for integrating kubernetes into the portfolio, allowing to bring to life all my project easily for all users and only consume resources when needed', status: 'todo' },
      
    ],
    createdAt: '2025-11-01',
    updatedAt: '2026-05-26',
  },
  {
    id: '2',
    title: 'Vinted Scrapper bot',
    description: 'This bot allows to easily track new items on Vinted and get notified when they are available based on user filter. It also allows to connect to the Vinted Account to automatically buy items when they are available or buy in one click listed item by the bot.',
    longDescription: 'This bot allows to easily track new items on Vinted and get notified when they are available based on user filter. It also allows to connect to the Vinted Account to automatically buy items when they are available or buy in one click listed item by the bot. The setup was allowing user to selected their prefered payment method and shipping address. The bot was able to get item in realtime and buy it in less than 2 seconds after it was listed, allowing to get very popular items that are sold out in few seconds. Also, the bot was integrating AI to allow user to easily create new offers to re-sell items by just describing the item and the bot was proposing an optimized title and description to maximize the chances of selling it.',
    category: 'dev',
    technologies: ['Node.JS', 'Proxy', 'Web-Scraping', 'AI', 'UX'],
    imageUrl: '',
    liveUrl: 'https://discord.gg/DuRMdjeT9u',
    sourceUrl: '',
    status: 'completed',
    featured: true,
    timeline: [
      { date: '2024-06', title: 'Project setup', description: 'Finding how to create the bot', status: 'done' },
      { date: '2024-06', title: 'Development', description: 'I made the bot connecting to vinted-API and fetch all new articles with the filter and delay compensation', status: 'done' },
      { date: '2024-07', title: 'Improve UX', description: 'Improve interaction with the bot on Discord, specially over the vinted connection system', status: 'done' },
      { date: '2024-08', title: 'Managing first client', description: 'Handling the first client and their requests', status: 'done' },
      { date: '2024-08', title: 'Improvement', description: 'Trying to improve the bot\'s performance to make it scrap even more articles (was stuck at 400/s)', status: 'done' },
      { date: '2024-09', title: 'Stopping project', description: 'Finding a better solution was taking too long, and client wanted a faster implementation', status: 'done' },
      
    ],
    createdAt: '2024-06-12',
    updatedAt: '2024-09-18',
  },
  {
    id: '3',
    title: 'Homelab',
    description: 'A personal home lab for experimenting with new technologies and hosting personal projects/tools',
    longDescription: 'My home-lab, built with Proxmox over two linked node allow me to experiment with new technologies and host personal projects/tools. It is also a good way to learn about infrastructure and sysadmin topics, and to have fun with it by creating cool projects and automations. I currently host my portfolio website on it, a kubernetes cluster to experiment and run some projects, open-source tools such as Obsidian Sync Server, Prometheus, Grafana, Mail server, Nextcloud and many others. I experimented files system with ZFS, LVM, NFS and also defined a proxmox cluster to have high availability and failover. I also manage all the network using VXLAN to link node virtual network together, manage the Firewall with rocky linux and defined a wireguard VPN to get external access to the homelab when needed.',
    category: "sysadmin",
    technologies: ['Proxmox', 'Kubernetes', 'Docker', 'Linux', 'Networking', 'Monitoring', 'Automation', 'Security', 'VXLAN', 'File sharing', 'Wireguard'],
    imageUrl: '',
    liveUrl: '',
    sourceUrl: '',
    status: 'in-progress',
    featured: false,
    timeline: [
      { date: '2025-12', title: 'Project setup', description: 'Setting up my first node with firewall and networking', status: 'done' },
      { date: '2025-12', title: 'Setting first service', description: 'I hosted my first service on the homelab, it was a Fead the Beast minecraft server. Running behind a reverse proxy with a strict network security to avoid any external access to my home network.', status: 'done' },
      { date: '2026-01', title: 'Adding more service', description: 'Adding new services such as Nextcloud, Obsidian Sync Server, and other tools', status: 'done' },
      { date: '2026-03', title: 'Improving infrastructure', description: 'Adding a new 6TB storage array, and configuring it with dedicated volume for different task', status: 'done' },
      { date: '2026-03', title: 'Improving infrastructure', description: 'Adding new node that is smaller but can run lightweight services and consomming less electricity. Usefull for low-power applications and allow to economize on energy consumption by shuting down main node.', status: 'done' },
      { date: '2026-03', title: 'Improving network', description: 'Linking my 2 nodes sub-network by a VXLAN', status: 'done' },
      { date: '2026-03', title: 'Improving utility', description: 'Adding a Wake-on-LAN feature to allow remote power on main node from small one', status: 'done' },
      { date: '2026-05', title: 'More service', description: 'Implementing additional services such as a media server, a mail server, and a satisfactory game server', status: 'done' },
      { date: '2026-07', title: 'Expanding services', description: 'Implement much services and starting hosting my project for real on it', status: 'in-progress' },

    ],
    createdAt: '2024-01-10',
    updatedAt: '2024-06-20',

  },
  {
    id: '4',
    title: "ProbabilityX",
    description: "A multi-tool project to regroup data allowing user to analyse financial market easier",
    longDescription: "ProbabilityX is a multi-tool project to regroup data from multi-sources such as X, Yahoo, Spotify, Youtube, and other, allowing user to analyse financial market easier. It includes a web application that allow user to easily visualise and analyse financial data, and also a Data-fetcher to make prediction of the market direction in live. The web application is built with Angular and Tailwind CSS, and the API is made using C# with dotnet and Entity Framework. The project is still in development, but the goal is to provide a comprehensive tool for financial analysis, including features such as portfolio management, risk analysis, and market forecasting.",
    category: 'dev',
    technologies: ['Angular', 'C#', 'Dotnet', 'Entity Framework', 'Financial Analysis', 'Data Visualization'],
    imageUrl: '',
    liveUrl: 'https://probax.swebystudio.fr',
    sourceUrl: '',
    status: 'in-progress',
    featured: false,
    timeline: [
      { date: '2024-10', title: 'Project setup', description: 'I joined this project as a Student and it was the beginning of it.', status: 'done' },
      { date: '2024-11', title: 'API development', description: 'Developing the API with C# and dotnet, and implementing new features.', status: 'done' },
      { date: '2025-01', title: 'Role change', description: 'I kept the role of a Student, but now I focus on infrastructure.', status: 'done' },
      { date: '2026-01', title: 'Continued working on Frontend', description: 'I worked on front-end to implement new UI components, improve UX and make it responsive', status: 'done' },
      { date: '2026-03', title: 'Feature development', description: 'I worked as a Full-Stack developer to refactor all the authentification system, that now include SSO and WebAuthN', status: 'done' },

    ],
    createdAt: '2024-10-15',
    updatedAt: '2025-01-10',
  },
    {
    id: '5',
    title: "ProbabilityX - Infrastructure",
    description: "The ProbaX multi-tool project, but with a focus on the infrastructure side, where I worked on setting up and maintaining the infrastructure to support the development and deployment of the project.",
    longDescription: "ProbabilityX is a multi-tool project to regroup data from multi-sources such as X, Yahoo, Spotify, Youtube, and other, allowing user to analyse financial market easier. It includes a web application that allow user to easily visualise and analyse financial data, and also a Data-fetcher to make prediction of the market direction in live. But to make a better prediction, we need a very low down time and a good performance, so I worked on setting up and maintaining the infrastructure to support the development and deployment of the project. I set up a Kubernetes cluster on our homelab to host the different services of the project, and also implemented CI/CD pipelines using ArgoCD to automate the deployment process. I also worked on optimizing the performance of the API by implementing caching and load balancing strategies, and monitoring the infrastructure to ensure its reliability and scalability.",
    category: 'infra',
    technologies: ['Kubernetes', 'ArgoCD', 'Docker', 'HA', 'CI/CD'],
    imageUrl: '',
    liveUrl: 'https://probax.swebystudio.fr',
    sourceUrl: '',
    status: 'in-progress',
    featured: false,
    timeline: [
      { date: '2024-10', title: 'Project setup', description: 'I joined this project as a Student and it was the beginning of it.', status: 'done' },
      { date: '2024-11', title: 'API development', description: 'Developing the API with C# and dotnet, and implementing new features.', status: 'done' },
      { date: '2025-01', title: 'Role change', description: 'I kept the role of a Student, but now I focus on infrastructure.', status: 'done' },
      { date: '2026-01', title: 'Continued working on Frontend', description: 'I worked on front-end to implement new UI components, improve UX and make it responsive', status: 'done' },
      { date: '2026-03', title: 'Feature development', description: 'I worked as a Full-Stack developer to refactor all the authentification system, that now include SSO and WebAuthN', status: 'done' },

    ],
    createdAt: '2024-10-15',
    updatedAt: '2025-01-10',
  }
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
