export interface ProjectTechnology {
  name: string
  icon?: string
}

export interface ProjectLink {
  id: string
  label: string
  url: string
  icon?: string
  type?: string
  order?: number
}

export interface Project {
  id: string
  title: string
  description: string
  longDescription: string
  category: 'dev' | 'infra' | 'sysadmin'
  categories: string[]
  technologies: ProjectTechnology[]
  imageUrl: string
  links: ProjectLink[]
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
  cvProjectPointIds?: string[]
  skills: unknown[]
  projects: unknown[]
  passions: unknown[]
  languages: unknown[]
  experiences: unknown[]
  education: unknown[]
  contacts: unknown[]
}

export type AiSpecialization = 'auto' | 'webdev' | 'appdev' | 'devops' | 'itsupport'
export type AiStyleId = 'auto' | CvStyleId
export type AiAboutLength = 'short' | 'medium' | 'long'
export type AiTone = 'professional' | 'enthusiastic' | 'technical'

export interface AiStatus {
  available: boolean
  model: string
  baseUrl: string
  models: string[]
  error?: string | null
}

export interface AiGenerationOptions {
  specialization?: AiSpecialization
  style?: AiStyleId
  aboutLength?: AiAboutLength
  maxExperiences?: number
  maxProjects?: number
  includeSoftSkills?: boolean
  includeLanguages?: boolean
  tone?: AiTone
  allowSkillSuggestions?: boolean
  allowBulletSuggestions?: boolean
  customInstructions?: string
}

export interface AiSuggestedSkill {
  id: string
  name: string
  description: string
  cvCategory: 'hard' | 'soft'
  categoryName: string
  level: number
  rationale: string
}

export interface AiSuggestedBullet {
  id: string
  entityType: 'project' | 'experience'
  entityId: string
  text: string
  skillIds: string[]
  rationale: string
}

export interface AiGeneratedCv {
  name: string
  candidateName: string | null
  specialization: string
  titleOverride: string
  aboutText: string
  availability: string | null
  style: CvStyleId
  pictureId?: string | null
  skillIds: string[]
  experienceIds: string[]
  projectIds: string[]
  cvProjectPointIds: string[]
  educationIds: string[]
  languageIds: string[]
  passionIds: string[]
}

export interface AiCvGenerationResult {
  cv: AiGeneratedCv
  suggestions: {
    skills: AiSuggestedSkill[]
    bullets: AiSuggestedBullet[]
  }
  justification: string
}

export interface AiApplySkillInput {
  name: string
  description?: string
  cvCategory: 'hard' | 'soft'
  categoryName: string
  level: number
  suggestionId?: string
}

export interface AiApplyBulletInput {
  entityType: 'project' | 'experience'
  entityId: string
  text: string
  skillIds: string[]
  suggestionId?: string
}

export interface AiApplyPayload {
  skills?: AiApplySkillInput[]
  bullets?: AiApplyBulletInput[]
}

export interface AiAppliedSkill {
  suggestionId: string | null
  name: string
  id: string
  categoryId: string | null
}

export interface AiAppliedBullet {
  suggestionId: string | null
  entityType: 'project' | 'experience'
  entityId: string
  pointId: string
  order: number
  index: number
}

export interface AiApplyResponse {
  skills: AiAppliedSkill[]
  bullets: AiAppliedBullet[]
}
