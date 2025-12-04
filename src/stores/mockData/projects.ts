import type { Project } from '@/domain/models';

export const mockProjects: Project[] = [
  {
    id: '1',
    title: 'E-Commerce Platform',
    description: 'A full-featured e-commerce platform with real-time inventory management',
    fullDescription: `# E-Commerce Platform

## Overview
A comprehensive e-commerce solution built with modern web technologies.

## Features
- Real-time inventory tracking
- Advanced search and filtering
- Secure payment processing
- Order management system
- Customer analytics dashboard

## Technical Details
Built using microservices architecture with event-driven design patterns.
Implemented caching strategies for optimal performance.

## Challenges & Solutions
- **Challenge**: Handling high concurrent user traffic
- **Solution**: Implemented Redis caching and load balancing

## Results
- 99.9% uptime
- 50% improvement in page load times
- Successfully processed 10,000+ orders in first month`,
    dateCreated: new Date('2024-01-15'),
    stack: ['Vue.js', 'TypeScript', 'Node.js', 'PostgreSQL', 'Redis', 'Docker'],
    pictureUrl: 'https://via.placeholder.com/400x300/4f46e5/ffffff?text=E-Commerce',
    projectUrl: 'https://example.com/ecommerce',
    changelog: [
      {
        id: 'c1',
        date: new Date('2024-01-15'),
        title: 'Project Initialization',
        description: 'Set up project architecture and initial dependencies',
        type: 'milestone',
      },
      {
        id: 'c2',
        date: new Date('2024-02-01'),
        title: 'Payment Integration',
        description: 'Integrated Stripe payment gateway',
        type: 'feature',
      },
      {
        id: 'c3',
        date: new Date('2024-03-10'),
        title: 'Performance Optimization',
        description: 'Implemented Redis caching for product catalog',
        type: 'improvement',
      },
    ],
    createdAt: new Date('2024-01-15'),
    updatedAt: new Date('2024-03-10'),
  },
  {
    id: '2',
    title: 'Task Management App',
    description: 'Collaborative task management tool with real-time synchronization',
    fullDescription: `# Task Management App

## Overview
A modern task management application designed for remote teams.

## Features
- Real-time collaboration
- Kanban boards
- Time tracking
- Team chat integration
- Advanced reporting

## Tech Stack
Leverages WebSocket for real-time updates and Vue 3 Composition API for reactive state management.`,
    dateCreated: new Date('2023-08-20'),
    stack: ['Vue.js', 'TypeScript', 'Express', 'MongoDB', 'Socket.io'],
    pictureUrl: 'https://via.placeholder.com/400x300/10b981/ffffff?text=Task+Manager',
    changelog: [
      {
        id: 'c4',
        date: new Date('2023-08-20'),
        title: 'Initial Release',
        description: 'Launched MVP with core features',
        type: 'milestone',
      },
      {
        id: 'c5',
        date: new Date('2023-10-05'),
        title: 'Real-time Sync',
        description: 'Added WebSocket-based real-time collaboration',
        type: 'feature',
      },
    ],
    createdAt: new Date('2023-08-20'),
    updatedAt: new Date('2023-10-05'),
  },
  {
    id: '3',
    title: 'Portfolio Website',
    description: 'Modern liquid glass portfolio with admin panel',
    fullDescription: `# Portfolio Website

## Overview
A stunning portfolio website featuring liquid glass morphism design.

## Features
- Glassmorphism UI
- Admin panel for content management
- Contact form
- Project showcase
- Experience timeline

## Implementation
Built with Vue 3, TypeScript, and follows SOLID principles with domain-driven architecture.`,
    dateCreated: new Date('2025-11-30'),
    stack: ['Vue.js', 'TypeScript', 'Vite', 'Pinia'],
    pictureUrl: 'https://via.placeholder.com/400x300/8b5cf6/ffffff?text=Portfolio',
    changelog: [
      {
        id: 'c6',
        date: new Date('2025-11-30'),
        title: 'Project Setup',
        description: 'Initialized project with domain-driven architecture',
        type: 'milestone',
      },
    ],
    createdAt: new Date('2025-11-30'),
    updatedAt: new Date('2025-11-30'),
  },
];
