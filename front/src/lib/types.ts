export interface Project {
  id: string
  title: string
  description: string
  longDescription: string
  category: 'dev' | 'infra' | 'sysadmin'
  technologies: string[]
  imageUrl: string
  liveUrl?: string
  sourceUrl?: string
  status: 'completed' | 'testing' | 'in-progress' | 'planned'
  featured: boolean
  timeline: TimelineEntry[]
  createdAt: string
  updatedAt: string
}

export interface TimelineEntry {
  date: string
  title: string
  description: string
  status: 'done' | 'testing' | 'in-progress' | 'todo'
  imageUrl?: string
}

export interface Skill {
  id: string
  name: string
  category: 'dev' | 'infra' | 'sysadmin'
  cvCategory: 'hard' | 'soft'
  level: number
  icon: string
  keywords: string[]
}

export interface TimelineEvent {
  id: string
  type: 'education' | 'experience'
  startDate: string
  endDate?: string
  title: string
  subtitle: string
  description: string
  tags: string[]
  icon: string
  subProjects?: SubProject[]
}

export interface SubProject {
  title: string
  description: string
  tags: string[]
  imageUrl?: string
  link?: string
}

export interface BlogPost {
  id: string
  title: string
  slug: string
  excerpt: string
  content: string
  tags: string[]
  publishedAt: string
  readingTime: number
  coverImage: string
}

export interface ContactForm {
  name: string
  email: string
  message: string
}

export interface ApiResponse<T> {
  data: T | null
  error: string | null
  loading: boolean
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  total: number
  page: number
  pageSize: number
}

export type CvStyleId = 'classic' | 'ats' | 'two-column-blue'

export interface CvStyle {
  id: CvStyleId
  name: string
  description: string
  accent: string
  sidebar: string
}

export interface Cv {
  id: string
  name: string
  candidateName?: string
  specialization?: string
  titleOverride?: string
  aboutText?: string
  availability?: string
  isDefault: boolean
  style: CvStyleId
  projectBullets?: Record<string, number[]>
  skills: unknown[]
  projects: unknown[]
  passions: unknown[]
  languages: unknown[]
  experiences: unknown[]
  education: unknown[]
  contacts: unknown[]
}
