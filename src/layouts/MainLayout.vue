<template>
  <div class="flex min-h-screen">
    <div>        
    </div>
    <aside class="sidebar">
      <nav class="nav-container">
        <router-link
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          class="nav-item"
          :class="{ active: isActive(item.path) }"
          :title="item.label"
        >
          <div class="nav-icon-wrapper">
            <component :is="item.icon" class="nav-icon" />
          </div>
        </router-link>
      </nav>
    </aside>
    
    <div class="content-wrapper">
      <Header />
      <main class="main-content">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import ThemeToggle from '@/components/ThemeToggle.vue';
import { computed, h } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();

interface NavItem {
  path: string;
  label: string;
  icon: () => any;
}

// SVG Icons as functional components
const HomeIcon = () => h('svg', {
  xmlns: 'http://www.w3.org/2000/svg',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
}, [
  h('path', { d: 'M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z' }),
  h('polyline', { points: '9,22 9,12 15,12 15,22' }),
]);

const ProjectsIcon = () => h('svg', {
  xmlns: 'http://www.w3.org/2000/svg',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
}, [
  h('path', { d: 'M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z' }),
  h('path', { d: 'M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z' }),
]);

const ExperiencesIcon = () => h('svg', {
  xmlns: 'http://www.w3.org/2000/svg',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
}, [
  h('rect', { x: '2', y: '7', width: '20', height: '14', rx: '2', ry: '2' }),
  h('path', { d: 'M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16' }),
]);

const StudiesIcon = () => h('svg', {
  xmlns: 'http://www.w3.org/2000/svg',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
}, [
  h('path', { d: 'M22 10v6M2 10l10-5 10 5-10 5z' }),
  h('path', { d: 'M6 12v5c3 3 9 3 12 0v-5' }),
]);

const ContactIcon = () => h('svg', {
  xmlns: 'http://www.w3.org/2000/svg',
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  'stroke-width': '2',
  'stroke-linecap': 'round',
  'stroke-linejoin': 'round',
}, [
  h('path', { d: 'M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z' }),
  h('polyline', { points: '22,6 12,13 2,6' }),
]);

const navItems = computed<NavItem[]>(() => [
  {
    path: '/',
    label: 'Home',
    icon: HomeIcon,
  },
  {
    path: '/projects',
    label: 'My Projects',
    icon: ProjectsIcon,
  },
  {
    path: '/experiences',
    label: 'My Experience',
    icon: ExperiencesIcon,
  },
  {
    path: '/studies',
    label: 'My Studies',
    icon: StudiesIcon,
  },
  {
    path: '/contact',
    label: 'Contact',
    icon: ContactIcon,
  },
]);

const isActive = (path: string): boolean => {
  if (path === '/') {
    return route.path === '/';
  }
  return route.path.startsWith(path);
};
</script>

<style scoped>
.main-layout {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  position: fixed;
  left: 0;
  top: 0;
  height: 100vh;
  width: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  padding: 1rem;
}

.nav-container {
  @apply flex flex-col;
  gap: 1rem;
  margin-left: 1rem;
  padding: 1.5rem 0;
  background: var(--color-glass-bg);
  backdrop-filter: blur(20px);
  border: 1px solid var(--color-border);
  border-radius: 2rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.nav-item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  padding: 0.5rem;
  transition: all 0.3s ease;
}

.nav-icon-wrapper {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-glass-bg);
  backdrop-filter: blur(10px);
  border: 1px solid var(--color-border);
  border-radius: 1rem;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.nav-icon-wrapper::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, var(--color-primary), var(--color-primary-dark));
  opacity: 0;
  transition: opacity 0.3s ease;
}

.nav-icon {
  width: 24px;
  height: 24px;
  color: var(--color-text-secondary);
  transition: all 0.3s ease;
  position: relative;
  z-index: 1;
}

.nav-item:hover .nav-icon-wrapper {
  background: var(--color-glass-bg-hover);
  border-color: var(--color-border-hover);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}

.nav-item:hover .nav-icon-wrapper::before {
  opacity: 0.1;
}

.nav-item:hover .nav-icon {
  color: var(--color-primary);
  transform: scale(1.1);
}

.nav-item.active .nav-icon-wrapper {
  background: linear-gradient(135deg, var(--color-primary), var(--color-primary-dark));
  border-color: var(--color-primary);
  box-shadow: 0 4px 20px rgba(74, 108, 247, 0.3);
}

.nav-item.active .nav-icon-wrapper::before {
  opacity: 0;
}

.nav-item.active .nav-icon {
  color: white;
}

.content-wrapper {
  flex: 1;
  margin-left: 80px;
}

.main-content {
  padding: 2rem;
  padding-top: calc(70px + 2rem);
  min-height: 100vh;
}

@media (max-width: 768px) {
  .sidebar {
    bottom: 0;
    top: auto;
    left: 0;
    right: 0;
    width: 100%;
    height: auto;
    padding: 0.5rem;
  }

  .nav-container {
    flex-direction: row;
    padding: 0.75rem 1rem;
    border-radius: 1.5rem;
    width: 100%;
    justify-content: space-around;
  }

  .nav-icon-wrapper {
    width: 44px;
    height: 44px;
  }

  .nav-icon {
    width: 22px;
    height: 22px;
  }

  .content-wrapper {
    margin-left: 0;
  }

  .main-content {
    margin-bottom: 80px;
    padding: 1.5rem;
    padding-top: calc(70px + 1.5rem);
  }
}
</style>
