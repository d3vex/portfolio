# Modern Liquid Glass Portfolio

A stunning, modern portfolio website featuring liquid glass morphism design with a fully functional admin panel. Built with Vue.js 3, TypeScript, and following SOLID principles with domain-driven architecture.

## ✨ Features

### Client-Side Features
- **Home Page**: Elegant landing page with your name and navigation
- **Projects Showcase**: Display all projects with cards showing:
  - Title, description, creation date
  - Tech stack with styled badges
  - Project image
  - Direct link to live project
  - Detailed view with full README-style content
  - Interactive changelog timeline
  
- **Experience Timeline**: Professional experience displayed as cards with:
  - Company name, role, and job label
  - Employment duration calculator
  - Company logo
  - Detailed view with full description
  - Company details section
  - Career milestones timeline
  
- **Contact Form**: Fully validated contact form with:
  - Name, email, subject, and message fields
  - Real-time validation
  - Success/error messaging
  - Glass morphism styling

### Admin Panel Features (work in progress)
- **Dashboard**: Overview with statistics
  - Total projects, experiences, and messages count
  - Unread messages counter
  - Recent messages preview
  - Quick action buttons
  
- **Contact Management**:
  - View all contact form submissions
  - Mark messages as read/unread
  - Delete messages
  - Unread message counter
  
- **Projects & Experiences Management**: (Expandable architecture ready)
  - CRUD operations for projects and experiences
  - Changelog management
  - Image upload support

## 🎨 Design Features

- **Liquid Glass Morphism**: Beautiful frosted glass effects with backdrop blur
- **Animated Background**: Gradient shifts and floating particles
- **Smooth Transitions**: Page transitions and hover effects
- **Responsive Design**: Mobile-first approach
- **Custom Scrollbars**: Themed scrollbars matching the design
- **Modern Typography**: Clean and readable font system

## 🏗️ Architecture

This project follows **domain-driven design** principles with a clean separation of concerns:

```
src/
├── domain/
│   ├── models/        # Core domain entities
│   ├── dtos/          # Data transfer objects
│   └── presenters/    # Transform models to DTOs
├── stores/            # Pinia state management
│   └── mockData/      # Mock data for development
├── services/          # Business logic layer (ready for API integration)
├── composables/       # Reusable composition functions
├── components/        # Reusable UI components
├── pages/
│   ├── client/        # Client-facing pages
│   └── admin/         # Admin panel pages
├── router/            # Vue Router configuration
└── plugins/           # Future API integration layer

```
## 📱 Routes

### Client Routes
- `/` - Home page
- `/projects` - Projects list
- `/projects/:id` - Project detail with changelog
- `/experiences` - Experience list
- `/experiences/:id` - Experience detail with changelog
- `/contact` - Contact form

### Admin Routes (Work In Progress)
- `/admin` - Admin dashboard
- `/admin/projects` - Manage projects (expandable)
- `/admin/experiences` - Manage experiences (expandable)
- `/admin/contacts` - View and manage contact messages

## 🎯 Technology Stack

- **Frontend Framework**: Vue.js 3 with Composition API
- **Language**: TypeScript
- **State Management**: Pinia
- **Routing**: Vue Router 4
- **Build Tool**: Vite
- **Styling**: Tailwind 4 with custom style



## TODO

### Add Backend Integration

The architecture is ready for backend integration:

1. Create API services in `/src/plugins/`
2. Update stores to call API services instead of using mock data
3. Implement authentication for admin panel

Example API service structure:
```typescript
// src/plugins/api.ts
export const projectApi = {
  getAll: () => fetch('/api/projects').then(r => r.json()),
  getById: (id: string) => fetch(`/api/projects/${id}`).then(r => r.json()),
  create: (data) => fetch('/api/projects', { method: 'POST', body: JSON.stringify(data) }),
  // ... other methods
}
```

## 📝 Component Library

### Glass Components
- `GlassCard` - Glassmorphism card container
- `GlassButton` - Styled button with variants (primary, secondary, danger)
- `GlassInput` - Form input with label and error support

### Feature Components
- `ProjectCard` - Project display card
- `ExperienceCard` - Experience display card
- `ChangelogTimeline` - Vertical timeline for changelogs

## 📦 Project Structure Benefits

- **Scalable**: Easy to add new features
- **Maintainable**: Clear separation of concerns
- **Testable**: Isolated business logic
- **Type-Safe**: Full TypeScript coverage
- **Performant**: Optimized bundle with Vite

## 🚧 Future Enhancements

- [ ] Fully integrate tailwind and remove raw CSS
- [ ] Backend API integration (Express.js + TypeScript)
- [ ] Admin authentication
- [ ] Full CRUD operations for projects/experiences
- [ ] Image upload functionality
- [ ] Rich text editor for descriptions
- [ ] Project filtering and search
- [ ] Dark/light theme toggle
- [ ] Multi-language support
- [ ] Analytics integration
- [ ] Blog section

## 📄 License

This project is open source and available under the APACHE 2.0 License.
