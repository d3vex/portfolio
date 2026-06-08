import type { ApiResponse } from '@/lib/types'

const API_BASE = 'http://localhost:3001/api'

function getToken(): string | null {
  return localStorage.getItem('cv_token')
}

async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(options.headers as Record<string, string>),
  }
  const token = getToken()
  if (token) {
    headers['Authorization'] = `Bearer ${token}`
  }
  const res = await fetch(`${API_BASE}${path}`, { ...options, headers })
  if (res.status === 401 && !path.startsWith('/auth/')) {
    localStorage.removeItem('cv_token')
    localStorage.removeItem('cv_user')
    window.location.href = '/admin/login'
    throw new Error('Session expired. Please login again.')
  }
  if (!res.ok) {
    const err = await res.json().catch(() => ({ message: res.statusText }))
    throw new Error(err.message || err.error || 'Request failed')
  }
  return res.json()
}

export function login(username: string, password: string) {
  return request<{ access_token: string; user: { id: string; username: string; role: string } }>(
    '/auth/login',
    { method: 'POST', body: JSON.stringify({ username, password }) }
  )
}

export function register(username: string, password: string) {
  return request<{ access_token: string; user: { id: string; username: string; role: string } }>(
    '/auth/register',
    { method: 'POST', body: JSON.stringify({ username, password }) }
  )
}

export function getProfile() { return request<any[]>('/profile') }
export function getContacts() { return request<any[]>('/contact') }
export function getSkills() { return request<any[]>('/skills') }
export function getLanguages() { return request<any[]>('/languages') }
export function getPassions() { return request<any[]>('/passions') }
export function getExperiences() { return request<any[]>('/experiences') }
export function getProjects() { return request<any[]>('/projects') }
export function getEducation() { return request<any[]>('/education') }
export function getTimeline() { return request<any[]>('/timeline') }

export function getCvs() { return request<any[]>('/cv') }
export function getCv(id: string) { return request<any>(`/cv/${id}`) }
export function getCvStats() { return request<any>('/cv/stats') }
export function createCv(data: any) {
  return request<any>('/cv', { method: 'POST', body: JSON.stringify(data) })
}
export function updateCv(id: string, data: any) {
  return request<any>(`/cv/${id}`, { method: 'PATCH', body: JSON.stringify(data) })
}
export function deleteCv(id: string) {
  return request<any>(`/cv/${id}`, { method: 'DELETE' })
}

const entityPathMap: Record<string, string> = {
  skills: 'skills',
  experiences: 'experiences',
  projects: 'projects',
  education: 'education',
  languages: 'languages',
  passions: 'passions',
  contacts: 'contact',
  profile: 'profile',
  categories: 'categories',
}

function entityPath(entity: string): string {
  return entityPathMap[entity] || entity
}

export function getEntity(entity: string) {
  return request<any[]>(`/${entityPath(entity)}`)
}

export function createEntity(entity: string, data: any) {
  return request<any>(`/${entityPath(entity)}`, { method: 'POST', body: JSON.stringify(data) })
}
export function updateEntity(entity: string, id: string, data: any) {
  return request<any>(`/${entityPath(entity)}/${id}`, { method: 'PATCH', body: JSON.stringify(data) })
}
export function deleteEntity(entity: string, id: string) {
  return request<any>(`/${entityPath(entity)}/${id}`, { method: 'DELETE' })
}
