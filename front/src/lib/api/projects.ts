import type { Project } from '@/lib/types'

const API_BASE = 'http://localhost:3001/api'

interface CategoryMeta {
  name: string
  order: number
}

let categoryCache: Record<string, CategoryMeta> | null = null

async function getCategoryMap(): Promise<Record<string, CategoryMeta>> {
  if (categoryCache) return categoryCache
  const res = await fetch(`${API_BASE}/categories`)
  if (!res.ok) throw new Error('Failed to fetch categories')
  const categories = await res.json()
  const map: Record<string, CategoryMeta> = {}
  for (const cat of categories) {
    map[cat.id] = { name: cat.name, order: cat.order ?? 0 }
  }
  categoryCache = map
  return map
}

function pickDisplayCategory(p: any, catMap: Record<string, CategoryMeta>): string {
  const ids = p.categories || []
  if (!ids.length) return 'dev'
  return ids
    .filter((c: any) => c?.id)
    .map((c: any) => ({ id: c.id, order: catMap[c.id]?.order ?? 0 }))
    .sort((a: { order: number }, b: { order: number }) => b.order - a.order)[0].id
}

function mapProject(p: any, catMap: Record<string, CategoryMeta>): Project {
  const categoryId = pickDisplayCategory(p, catMap)
  return {
    id: p.id,
    title: p.title,
    description: p.description || '',
    longDescription: p.longDescription || '',
    category: (catMap[categoryId]?.name || 'dev') as Project['category'],
    categories: (p.categories || [])
      .filter((c: any) => c?.id)
      .sort((a: any, b: any) => (catMap[a.id]?.order ?? 0) - (catMap[b.id]?.order ?? 0))
      .map((c: any) => catMap[c.id]?.name || c.name || c.id),
    technologies: (p.technologies || []).map((t: any) => ({
      name: typeof t === 'string' ? t : t.name,
      icon: typeof t === 'string' ? undefined : t.icon,
    })),
    imageUrl: p.imageUrl || '',
    links: (p.links || []).map((l: any) => ({
      id: l.id,
      label: l.label,
      url: l.url,
      icon: l.icon,
      type: l.type,
      order: l.order,
    })),
    status: p.status || 'in-progress',
    featured: p.featured || false,
    timeline: (p.timelineEntries || []).map((t: any) => ({
      date: t.date,
      title: t.title,
      description: t.description,
      status: t.status,
      imageUrl: t.imageUrl,
    })),
    createdAt: typeof p.createdAt === 'string' ? p.createdAt : p.createdAt?.split('T')[0] || '',
    updatedAt: typeof p.updatedAt === 'string' ? p.updatedAt : p.updatedAt?.split('T')[0] || '',
  }
}

export async function getProjects(page = 1, pageSize = 10) {
  try {
    const [projects, catMap] = await Promise.all([
      fetch(`${API_BASE}/projects`).then(r => {
        if (!r.ok) throw new Error('Failed to fetch projects')
        return r.json()
      }),
      getCategoryMap(),
    ])
    const mapped = projects.map((p: any) => mapProject(p, catMap))
    const start = (page - 1) * pageSize
    const paginated = mapped.slice(start, start + pageSize)
    return {
      data: paginated,
      error: null as string | null,
      loading: false as const,
      total: mapped.length,
      page,
      pageSize,
    }
  } catch (e) {
    return {
      data: [] as Project[],
      error: e instanceof Error ? e.message : 'Failed to fetch projects',
      loading: false as const,
      total: 0,
      page,
      pageSize,
    }
  }
}

export async function getProject(id: string) {
  try {
    const [project, catMap] = await Promise.all([
      fetch(`${API_BASE}/projects/${id}`).then(r => {
        if (!r.ok) throw new Error('Project not found')
        return r.json()
      }),
      getCategoryMap(),
    ])
    return { data: mapProject(project, catMap), error: null as string | null, loading: false as const }
  } catch (e) {
    return { data: null, error: e instanceof Error ? e.message : 'Project not found', loading: false as const }
  }
}

export async function getFeaturedProjects() {
  const result = await getProjects(1, 100)
  if (result.error) return { data: [], error: result.error, loading: false as const }
  return { data: result.data.filter((p: Project) => p.featured), error: null as string | null, loading: false as const }
}

export async function getProjectsByCategory(category: Project['category']) {
  const result = await getProjects(1, 100)
  if (result.error) return { data: [], error: result.error, loading: false as const }
  return { data: result.data.filter((p: Project) => p.category === category), error: null as string | null, loading: false as const }
}
