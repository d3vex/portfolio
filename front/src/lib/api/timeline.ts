import type { TimelineEvent } from '@/lib/types'

const API_BASE = 'http://localhost:3001/api'

export async function getTimeline() {
  try {
    const res = await fetch(`${API_BASE}/timeline`)
    if (!res.ok) throw new Error('Failed to fetch timeline')
    const data: TimelineEvent[] = await res.json()
    return { data, error: null as string | null, loading: false as const }
  } catch (e) {
    return { data: [], error: e instanceof Error ? e.message : 'Failed to fetch timeline', loading: false as const }
  }
}

export async function getTimelineByType(type: TimelineEvent['type']) {
  const result = await getTimeline()
  if (result.error) return { data: [], error: result.error, loading: false as const }
  return { data: result.data.filter(e => e.type === type), error: null as string | null, loading: false as const }
}
