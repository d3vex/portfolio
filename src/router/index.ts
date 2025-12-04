import { createRouter, createWebHistory } from 'vue-router';

// Client Pages
import HomePage from '@/pages/client/HomePage.vue';
import ProjectsPage from '@/pages/client/ProjectsPage.vue';
import ProjectDetailPage from '@/pages/client/ProjectDetailPage.vue';
import ExperiencesPage from '@/pages/client/ExperiencesPage.vue';
import ExperienceDetailPage from '@/pages/client/ExperienceDetailPage.vue';
import ContactPage from '@/pages/client/ContactPage.vue';

// Admin Pages
import AdminLayout from '@/pages/admin/AdminLayout.vue';
import AdminDashboard from '@/pages/admin/AdminDashboard.vue';
import AdminContacts from '@/pages/admin/AdminContacts.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomePage,
    },
    {
      path: '/projects',
      name: 'projects',
      component: ProjectsPage,
    },
    {
      path: '/projects/:id',
      name: 'project-detail',
      component: ProjectDetailPage,
    },
    {
      path: '/experiences',
      name: 'experiences',
      component: ExperiencesPage,
    },
    {
      path: '/experiences/:id',
      name: 'experience-detail',
      component: ExperienceDetailPage,
    },
    {
      path: '/contact',
      name: 'contact',
      component: ContactPage,
    },
    {
      path: '/admin',
      component: AdminLayout,
      children: [
        {
          path: '',
          name: 'admin-dashboard',
          component: AdminDashboard,
        },
        {
          path: 'contacts',
          name: 'admin-contacts',
          component: AdminContacts,
        },
        // Placeholder routes for future admin pages
        {
          path: 'projects',
          name: 'admin-projects',
          component: AdminDashboard, // Temporary
        },
        {
          path: 'experiences',
          name: 'admin-experiences',
          component: AdminDashboard, // Temporary
        },
      ],
    },
  ],
  scrollBehavior() {
    return { top: 0 };
  },
});

export default router;
