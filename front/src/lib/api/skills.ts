import type { Skill } from '@/lib/types'

const API_BASE = 'http://localhost:3001/api'

let categoryCache: Record<string, string> | null = null

async function getCategoryMap(): Promise<Record<string, string>> {
  if (categoryCache) return categoryCache
  const res = await fetch(`${API_BASE}/categories`)
  if (!res.ok) throw new Error('Failed to fetch categories')
  const categories = await res.json()
  const map: Record<string, string> = {}
  for (const cat of categories) {
    map[cat.id] = cat.name
  }
  categoryCache = map
  return map
}

function mapSkill(s: any, catMap: Record<string, string>): Skill {
  return {
    id: s.id,
    name: s.name,
    category: (catMap[s.categoryId] || 'dev') as Skill['category'],
    cvCategory: (s.cvCategory === 'soft' ? 'soft' : 'hard') as Skill['cvCategory'],
    level: s.level || 0,
    icon: s.icon || '',
    keywords: s.keywords || [],
  }
}

export async function getSkills() {
  try {
    const [skills, catMap] = await Promise.all([
      fetch(`${API_BASE}/skills`).then(r => {
        if (!r.ok) throw new Error('Failed to fetch skills')
        return r.json()
      }),
      getCategoryMap(),
    ])
    return {
      data: skills.map((s: any) => mapSkill(s, catMap)),
      error: null as string | null,
      loading: false as const,
    }
  } catch (e) {
    return {
      data: [] as Skill[],
      error: e instanceof Error ? e.message : 'Failed to fetch skills',
      loading: false as const,
    }
  }
}

export async function getSkillsByCategory(category: Skill['category']) {
  const result = await getSkills()
  if (result.error) return { data: [], error: result.error, loading: false as const }
  return { data: result.data.filter((s: Skill) => s.category === category), error: null as string | null, loading: false as const }
}
