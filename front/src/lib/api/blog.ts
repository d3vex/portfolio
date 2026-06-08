import { mockFetch, mockPaginatedFetch } from './client'
import type { BlogPost } from '@/lib/types'

const MOCK_BLOG: BlogPost[] = [
  {
    id: '1',
    title: 'Setting Up a Kubernetes Cluster at Home',
    slug: 'homelab-kubernetes',
    excerpt: 'A step-by-step guide to setting up a production-like Kubernetes cluster on your own hardware.',
    content: '# Setting Up a Kubernetes Cluster at Home\n\nKubernetes at home is easier than ever...',
    tags: ['Kubernetes', 'Docker', 'DevOps', 'Homelab'],
    publishedAt: '2025-02-15',
    readingTime: 12,
    coverImage: '',
  },
  {
    id: '2',
    title: 'Vue 3 Composition API: A Practical Guide',
    slug: 'vue3-composition-api',
    excerpt: 'Learn how to write cleaner, more maintainable Vue components with the Composition API.',
    content: '# Vue 3 Composition API\n\nThe Composition API is a game changer...',
    tags: ['Vue', 'TypeScript', 'Frontend'],
    publishedAt: '2025-01-20',
    readingTime: 8,
    coverImage: '',
  },
  {
    id: '3',
    title: 'Building a CI/CD Pipeline with GitHub Actions',
    slug: 'cicd-github-actions',
    excerpt: 'Automate your testing and deployment workflow with GitHub Actions and Docker.',
    content: '# CI/CD with GitHub Actions\n\nContinuous integration is essential...',
    tags: ['CI/CD', 'GitHub Actions', 'DevOps', 'Docker'],
    publishedAt: '2024-12-10',
    readingTime: 10,
    coverImage: '',
  },
  {
    id: '4',
    title: 'Network Security Basics for Developers',
    slug: 'network-security-basics',
    excerpt: 'Essential network security concepts every developer should know.',
    content: '# Network Security Basics\n\nUnderstanding network security...',
    tags: ['Network', 'Security', 'Basics'],
    publishedAt: '2024-11-05',
    readingTime: 6,
    coverImage: '',
  },
]

export async function getBlogPosts(page = 1, pageSize = 10) {
  return mockPaginatedFetch(MOCK_BLOG, page, pageSize)
}

export async function getBlogPost(slug: string) {
  const post = MOCK_BLOG.find(p => p.slug === slug)
  if (!post) {
    return { data: null, error: 'Blog post not found', loading: false }
  }
  return mockFetch(post)
}

export async function getBlogTags() {
  const tags = [...new Set(MOCK_BLOG.flatMap(p => p.tags))]
  return mockFetch(tags)
}
