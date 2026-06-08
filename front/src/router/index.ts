import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: () => import('@/pages/HomePage.vue'),
    },
    {
      path: '/about',
      name: 'about',
      component: () => import('@/pages/AboutPage.vue'),
    },
    {
      path: '/projects',
      name: 'projects',
      component: () => import('@/pages/ProjectsPage.vue'),
    },
    {
      path: '/projects/:id',
      name: 'project-detail',
      component: () => import('@/pages/ProjectDetailPage.vue'),
    },
    {
      path: '/timeline',
      name: 'timeline',
      component: () => import('@/pages/TimelinePage.vue'),
    },
    {
      path: '/blog/:slug',
      name: 'blog-post',
      component: () => import('@/pages/BlogPostPage.vue'),
    },
    {
      path: '/contact',
      name: 'contact',
      component: () => import('@/pages/ContactPage.vue'),
    },
    {
      path: '/admin/login',
      name: 'cv-login',
      component: () => import('@/pages/cv/CvLogin.vue'),
    },
    {
      path: '/admin/',
      name: 'admin',
      component: () => import('@/pages/cv/CvDashboard.vue'),
    },
    {
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      component: () => import('@/pages/cv/CvDashboard.vue'),
    },
    {
      path: '/admin/cvs',
      name: 'admin-cv-list',
      component: () => import('@/pages/cv/CvList.vue'),
    },
    {
      path: '/admin/cvs/new',
      name: 'admin-cv-new',
      component: () => import('@/pages/cv/CvBuilder.vue'),
    },
    {
      path: '/admin/cvs/:id',
      name: 'admin-cv-view',
      component: () => import('@/pages/cv/CvView.vue'),
    },
    {
      path: '/admin/cvs/:id/edit',
      name: 'admin-cv-edit',
      component: () => import('@/pages/cv/CvBuilder.vue'),
    },
    {
      path: '/admin/manage/:entity',
      name: 'admin-manage',
      component: () => import('@/pages/cv/CvEntityManager.vue'),
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('@/pages/NotFoundPage.vue'),
    },
  ],
})

router.beforeEach((to) => {
  if (to.path.startsWith('/admin') && to.path !== '/admin/login') {
    const token = localStorage.getItem('cv_token')
    if (!token) return '/admin/login'
  }
  if (to.path === '/admin/login' && localStorage.getItem('cv_token')) {
    return '/admin/dashboard'
  }
})

router.afterEach(() => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
})

export default router
