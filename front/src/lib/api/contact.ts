import type { ContactForm } from '@/lib/types'

const API_BASE = 'http://localhost:3001/api'

export async function submitContactForm(form: ContactForm) {
  if (!form.name || !form.email || !form.message) {
    return { data: null, error: 'All fields are required', loading: false as const }
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(form.email)) {
    return { data: null, error: 'Invalid email address', loading: false as const }
  }

  try {
    const res = await fetch(`${API_BASE}/contact`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        label: form.name,
        value: form.email,
        type: 'inquiry',
      }),
    })
    if (!res.ok) {
      const err = await res.json().catch(() => ({ message: res.statusText }))
      return { data: null, error: err.message || 'Failed to send message', loading: false as const }
    }
    return { data: { success: true }, error: null as string | null, loading: false as const }
  } catch (e) {
    return { data: null, error: e instanceof Error ? e.message : 'Network error', loading: false as const }
  }
}

export async function getContactInfo() {
  try {
    const res = await fetch(`${API_BASE}/contact`)
    if (!res.ok) throw new Error('Failed to fetch contact info')
    const contacts: { label: string; value: string; type: string }[] = await res.json()

    const info: Record<string, string> = {}
    for (const c of contacts) {
      if (c.label === 'Email') info.email = c.value
      if (c.label === 'GitHub') {
        info.github = c.value
        info.githubName = c.value.replace('https://github.com/', '')
      }
      if (c.label === 'LinkedIn') {
        info.linkedin = c.value
        info.linkedinName = c.value.replace('https://linkedin.com/in/', '')
      }
      if (c.label === 'City') info.location = c.value
      if (c.label === 'Phone number') info.phone = c.value
    }

    return {
      data: {
        email: info.email || 'loanmata4@gmail.com',
        github: info.github || 'https://github.com/D3vex',
        linkedin: info.linkedin || 'https://linkedin.com/in/loan-mata',
        linkedinName: info.linkedinName || 'Loan Mata',
        location: info.location || 'France',
      },
      error: null as string | null,
      loading: false as const,
    }
  } catch (e) {
    return {
      data: {
        email: 'loanmata4@gmail.com',
        github: 'https://github.com/D3vex',
        linkedin: 'https://linkedin.com/in/loan-mata',
        linkedinName: 'Loan Mata',
        location: 'France',
      },
      error: e instanceof Error ? e.message : 'Failed to fetch contact info',
      loading: false as const,
    }
  }
}
