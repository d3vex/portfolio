import type { Experience } from '@/domain/models';

export const mockExperiences: Experience[] = [
  {
    id: '1',
    companyName: 'TechCorp Solutions',
    role: 'Senior Frontend Developer',
    jobLabel: 'Full-time',
    description: 'Led development of enterprise web applications using Vue.js and TypeScript',
    fullDescription: `# Senior Frontend Developer at TechCorp Solutions

## Role Overview
Led a team of 5 developers in building scalable enterprise applications.

## Key Responsibilities
- Architected and developed multiple client-facing applications
- Mentored junior developers and conducted code reviews
- Established coding standards and best practices
- Collaborated with UX/UI designers and backend teams

## Major Achievements
- Reduced page load times by 60% through optimization
- Implemented comprehensive testing strategy (90% coverage)
- Led migration from Vue 2 to Vue 3
- Introduced TypeScript across all projects

## Technologies Used
Vue.js, TypeScript, Vite, Pinia, Vitest, Cypress, Docker, AWS

## Team & Culture
Worked in an agile environment with 2-week sprints. Participated in daily standups, sprint planning, and retrospectives.`,
    startDate: new Date('2022-03-01'),
    endDate: new Date('2024-11-30'),
    pictureUrl: 'https://via.placeholder.com/200x200/3b82f6/ffffff?text=TechCorp',
    companyDetails: {
      name: 'TechCorp Solutions',
      description: 'Leading provider of enterprise software solutions for Fortune 500 companies',
      industry: 'Software Development',
      size: '500-1000 employees',
      website: 'https://techcorp-solutions.example.com',
      location: 'San Francisco, CA',
    },
    changelog: [
      {
        id: 'e1',
        date: new Date('2022-03-01'),
        title: 'Started Position',
        description: 'Joined as Senior Frontend Developer',
        type: 'milestone',
      },
      {
        id: 'e2',
        date: new Date('2022-06-15'),
        title: 'Vue 3 Migration',
        description: 'Successfully led migration of main application to Vue 3',
        type: 'milestone',
      },
      {
        id: 'e3',
        date: new Date('2023-01-10'),
        title: 'Team Lead Promotion',
        description: 'Promoted to team lead, managing 5 developers',
        type: 'milestone',
      },
      {
        id: 'e4',
        date: new Date('2023-08-20'),
        title: 'Performance Optimization',
        description: 'Implemented lazy loading and code splitting, reducing bundle size by 40%',
        type: 'improvement',
      },
    ],
    createdAt: new Date('2022-03-01'),
    updatedAt: new Date('2024-11-30'),
  },
  {
    id: '2',
    companyName: 'StartupHub',
    role: 'Frontend Developer',
    jobLabel: 'Full-time',
    description: 'Developed responsive web applications and contributed to design system',
    fullDescription: `# Frontend Developer at StartupHub

## Role Overview
Contributed to building a modern SaaS platform from ground up.

## Key Responsibilities
- Developed new features and maintained existing codebase
- Created reusable component library
- Implemented responsive designs
- Participated in agile ceremonies

## Major Achievements
- Built component library used across 5+ products
- Improved mobile experience, increasing mobile traffic by 45%
- Reduced bug count by 30% through better testing practices

## Technologies Used
Vue.js, JavaScript, Sass, Jest, Git

## Learning & Growth
Gained solid foundation in modern web development practices and agile methodologies.`,
    startDate: new Date('2020-06-01'),
    endDate: new Date('2022-02-28'),
    pictureUrl: 'https://via.placeholder.com/200x200/10b981/ffffff?text=StartupHub',
    companyDetails: {
      name: 'StartupHub',
      description: 'Innovative SaaS platform connecting startups with investors and mentors',
      industry: 'Technology / SaaS',
      size: '50-100 employees',
      website: 'https://startuphub.example.com',
      location: 'Austin, TX',
    },
    changelog: [
      {
        id: 'e5',
        date: new Date('2020-06-01'),
        title: 'Joined StartupHub',
        description: 'Started as Frontend Developer',
        type: 'milestone',
      },
      {
        id: 'e6',
        date: new Date('2020-09-15'),
        title: 'Component Library',
        description: 'Released v1.0 of company component library',
        type: 'feature',
      },
      {
        id: 'e7',
        date: new Date('2021-03-20'),
        title: 'Mobile Redesign',
        description: 'Led mobile-first redesign initiative',
        type: 'improvement',
      },
    ],
    createdAt: new Date('2020-06-01'),
    updatedAt: new Date('2022-02-28'),
  },
  {
    id: '3',
    companyName: 'Freelance',
    role: 'Full Stack Developer',
    jobLabel: 'Contract',
    description: 'Building custom web solutions for various clients',
    fullDescription: `# Freelance Full Stack Developer

## Overview
Providing end-to-end web development services for diverse clients.

## Services Offered
- Custom web application development
- UI/UX implementation
- API development and integration
- Performance optimization
- Technical consulting

## Notable Projects
- E-commerce platform for retail client
- Real estate listing portal
- Event management system
- Multiple portfolio and business websites

## Technologies
Vue.js, React, Node.js, Express, MongoDB, PostgreSQL, TypeScript

## Client Satisfaction
Maintained 5-star rating with 100% client satisfaction rate.`,
    startDate: new Date('2024-12-01'),
    pictureUrl: 'https://via.placeholder.com/200x200/8b5cf6/ffffff?text=Freelance',
    companyDetails: {
      name: 'Freelance',
      description: 'Independent software development consultant',
      industry: 'Software Consulting',
      location: 'Remote',
    },
    changelog: [
      {
        id: 'e8',
        date: new Date('2024-12-01'),
        title: 'Started Freelancing',
        description: 'Began accepting freelance projects',
        type: 'milestone',
      },
    ],
    createdAt: new Date('2024-12-01'),
    updatedAt: new Date('2024-12-01'),
  },
];
