<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { getProjects } from '@/lib/api/projects'
import AppButton from '@/components/ui/AppButton.vue'
import type { Project } from '@/lib/types'

const { t } = useI18n()
const router = useRouter()
const { data: projects, loading } = useAsyncData(() => getProjects(1, 20))

const activeFilter = ref<'all' | Project['category']>('all')

const filteredProjects = computed(() => {
  if (!projects.value) return []
  if (activeFilter.value === 'all') return projects.value
  return projects.value.filter(p => p.category === activeFilter.value)
})

const totalProjects = computed(() => projects.value?.length ?? 0)

const filters = [
  { key: 'all' as const, label: 'projects.filters.all', icon: 'mdi:view-grid' },
  { key: 'dev' as const, label: 'projects.filters.dev', icon: 'mdi:code-tags' },
  { key: 'infra' as const, label: 'projects.filters.infra', icon: 'mdi:server' },
  { key: 'sysadmin' as const, label: 'projects.filters.sysadmin', icon: 'mdi:terminal' },
]

function viewProject(id: string) {
  router.push(`/projects/${id}`)
}

function statusColor(status: Project['status']) {
  switch (status) {
    case 'completed': return 'text-green-500'
    case 'in-progress': return 'text-amber-500'
    case 'planned': return 'text-zinc-500'
  }
}

function statusDot(status: Project['status']) {
  switch (status) {
    case 'completed': return 'projects_page__status-dot--completed'
    case 'in-progress': return 'projects_page__status-dot--progress'
    case 'planned': return 'projects_page__status-dot--planned'
  }
}

function filterCount(key: string) {
  if (!projects.value) return 0
  if (key === 'all') return projects.value.length
  return projects.value.filter(p => p.category === key).length
}
</script>

<template>
  <section class="projects_page">
    <div class="projects_page__container">
      <div class="projects_page__header">
        <div class="projects_page__counter">
          <Icon icon="mdi:folder-network" class="w-4 h-4" />
          <span class="font-mono text-xs">{{ filteredProjects.length }}/{{ totalProjects }}</span>
        </div>
        <h1 class="projects_page__title">{{ t('projects.title') }}</h1>
        <p class="projects_page__subtitle">{{ t('projects.subtitle') }}</p>
      </div>

      <div class="projects_page__filters">
        <button
          v-for="f in filters"
          :key="f.key"
          class="projects_page__filter"
          :class="{ 'projects_page__filter--active': activeFilter === f.key }"
          @click="activeFilter = f.key"
        >
          <Icon :icon="f.icon" class="w-4 h-4" />
          <span>{{ t(f.label) }}</span>
          <span class="projects_page__filter-count">{{ filterCount(f.key) }}</span>
        </button>
      </div>

      <div v-if="loading" class="projects_page__loading">
        <div v-for="n in 4" :key="n" class="projects_page__skeleton" />
      </div>

      <div v-else-if="filteredProjects.length === 0" class="projects_page__empty">
        <Icon icon="mdi:folder-open-outline" class="w-16 h-16 mb-4 opacity-30" />
        <p>{{ t('projects.empty') }}</p>
      </div>

      <div v-else class="projects_page__grid" :key="'grid-' + activeFilter">
        <div
          v-for="(project, i) in filteredProjects"
          :key="project.id"
          class="projects_page__card"
          :style="{ '--i': i }"
          @click="viewProject(project.id)"
        >
          <div class="projects_page__card-header">
            <div class="projects_page__card-status" :class="statusColor(project.status)">
              <div class="projects_page__status-dot" :class="statusDot(project.status)" />
              <span class="text-xs font-mono">{{ project.status }}</span>
            </div>
            <span class="projects_page__card-category">{{ project.category }}</span>
          </div>

          <h3 class="projects_page__card-title">{{ project.title }}</h3>
          <p class="projects_page__card-desc">{{ project.description }}</p>

          <div class="projects_page__card-techs">
            <span
              v-for="tech in project.technologies.slice(0, 4)"
              :key="tech"
              class="projects_page__card-tech"
            >
              {{ tech }}
            </span>
            <span v-if="project.technologies.length > 4" class="projects_page__card-tech">
              +{{ project.technologies.length - 4 }}
            </span>
          </div>

          <div class="projects_page__card-action">
            <AppButton variant="ghost" size="sm" iconRight="mdi:arrow-right">
              {{ t('projects.view_details') }}
            </AppButton>
          </div>

          <div class="projects_page__glow" />
        </div>
      </div>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.projects_page {
  @apply py-20 px-4;

  &__container {
    @apply max-w-6xl mx-auto;
  }

  &__header {
    @apply text-center mb-12;
  }

  &__counter {
    @apply inline-flex items-center gap-1.5 mb-4 px-3 py-1 rounded-full border;
    color: var(--color-text-secondary);
    border-color: var(--color-border);
    background-color: var(--color-surface);
  }

  &__title {
    @apply text-4xl md:text-5xl font-heading font-bold mb-4;
    color: var(--color-text);
  }

  &__subtitle {
    @apply text-lg;
    color: var(--color-text-secondary);
  }

  // ── Filters ──────────────────────────

  &__filters {
    @apply flex items-center justify-center gap-2 mb-10 flex-wrap;
  }

  &__filter {
    @apply inline-flex items-center gap-1.5 px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200;
    color: var(--color-text-secondary);
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);

    &:hover {
      color: var(--color-text);
      border-color: var(--color-accent);
    }

    &--active {
      @apply bg-accent text-white border-accent;
      box-shadow: 0 0 20px rgba(37, 99, 235, 0.15);
    }
  }

  &__filter-count {
    @apply ml-1 text-xs px-1.5 py-0.5 rounded;
    background-color: var(--color-bg);
    opacity: 0.6;

    .projects_page__filter--active & {
      background-color: rgba(255, 255, 255, 0.15);
    }
  }

  // ── Loading / Empty ───────────────────

  &__loading {
    @apply grid grid-cols-1 md:grid-cols-2 gap-6;
  }

  &__skeleton {
    @apply h-64 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  &__empty {
    @apply text-center py-20;
    color: var(--color-text-secondary);
  }

  // ── Grid ──────────────────────────────

  &__grid {
    @apply grid grid-cols-1 md:grid-cols-2 gap-6;
  }

  // ── Card ──────────────────────────────

  &__card {
    @apply relative p-6 rounded-xl border overflow-hidden cursor-pointer;
    background-color: var(--color-surface);
    border-color: var(--color-border);
    animation: card-enter 0.45s ease both;
    animation-delay: calc(var(--i) * 0.08s);

    &:hover {
      border-color: var(--color-accent);
      transform: translateY(-4px);
      box-shadow: 0 8px 30px rgba(37, 99, 235, 0.1);
    }
  }

  &__card-header {
    @apply flex items-center justify-between mb-4;
  }

  &__card-status {
    @apply flex items-center gap-1.5;
  }

  &__card-category {
    @apply text-xs font-mono px-2 py-0.5 rounded;
    background-color: var(--color-bg);
    color: var(--color-text-secondary);
  }

  &__card-title {
    @apply text-xl font-heading font-bold mb-2 relative z-[1];
    color: var(--color-text);
  }

  &__card-desc {
    @apply text-sm mb-4 line-clamp-2 relative z-[1];
    color: var(--color-text-secondary);
  }

  &__card-techs {
    @apply flex flex-wrap gap-1.5 mb-4 relative z-[1];
  }

  &__card-tech {
    @apply px-2 py-0.5 rounded text-xs font-mono;
    background-color: var(--color-accent);
    color: white;
    opacity: 0.8;
  }

  &__card-action {
    @apply flex justify-end relative z-[1];
  }

  // ── Status dot ────────────────────────

  &__status-dot {
    @apply w-2 h-2 rounded-full;

    &--completed {
      @apply bg-green-500;
    }

    &--progress {
      @apply bg-amber-500;
      animation: pulse-dot 2s ease-in-out infinite;
    }

    &--planned {
      @apply bg-zinc-500;
    }
  }

  // ── Hover glow ────────────────────────

  &__glow {
    @apply absolute inset-0 pointer-events-none rounded-xl;
    transition: opacity 0.35s ease;
    opacity: 0;
    background: radial-gradient(600px circle at 50% 50%, rgba(37, 99, 235, 0.07), transparent 50%);
  }

  &__card:hover &__glow {
    opacity: 1;
  }
}

// ── Animations ──────────────────────────

@keyframes card-enter {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse-dot {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.85); }
}
</style>
