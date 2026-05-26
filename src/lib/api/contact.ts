import { mockFetch, mockError } from './client'
import type { ContactForm } from '@/lib/types'

export async function submitContactForm(form: ContactForm) {
  if (!form.name || !form.email || !form.message) {
    return mockError('All fields are required')
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!emailRegex.test(form.email)) {
    return mockError('Invalid email address')
  }

  console.log('[MOCK] Contact form submitted:', form)
  return mockFetch({ success: true })
}

export async function getContactInfo() {
  return mockFetch({
    email: 'loanmata4@gmail.com',
    github: 'https://github.com/D3vex',
    linkedin: 'https://linkedin.com/in/loan-mata',
    location: 'France',
  })
}
