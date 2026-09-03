<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { getProject } from '@/lib/api/projects'
import AppButton from '@/components/ui/AppButton.vue'

const route = useRoute()
const router = useRouter()
const { t } = useI18n()
const { data: project, loading } = useAsyncData(() => getProject(route.params.id as string))

const progressPercent = computed(() => {
  if (!project.value) return 0
  const total = project.value.timeline.length
  const weight = project.value.timeline.reduce((sum, e) => {
    if (e.status === 'done') return sum + 1
    if (e.status === 'testing') return sum + 0.85
    if (e.status === 'in-progress') return sum + 0.5
    return sum
  }, 0)
  return Math.round((weight / total) * 100)
})

function statusIcon(status: string) {
  switch (status) {
    case 'done': return 'mdi:check-circle'
    case 'testing': return 'mdi:bug-check'
    case 'in-progress': return 'mdi:progress-check'
    case 'todo': return 'mdi:circle-outline'
    default: return 'mdi:circle-outline'
  }
}

function statusColor(status: string) {
  switch (status) {
    case 'done': return 'text-green-500'
    case 'testing': return 'text-blue-500'
    case 'in-progress': return 'text-amber-500'
    case 'todo': return 'text-zinc-500'
    default: return ''
  }
}

function statusLineColor(status: string) {
  switch (status) {
    case 'done': return 'var(--color-dot-done)'
    case 'testing': return 'var(--color-dot-testing)'
    case 'in-progress': return 'var(--color-dot-progress)'
    case 'todo': return 'var(--color-dot-todo)'
    default: return 'var(--color-border)'
  }
}

function openUrl(url: string) {
  window.open(url, '_blank')
}

const mainLink = computed(() => {
  const link = (project.value?.links || []).find((l) => ['demo', 'website', 'live'].includes(l.type!)) || project.value?.links[0]
  return link || null
})

const sourceLink = computed(() => {
  const link = (project.value?.links || []).find((l) => l.type === 'source')
  return link || null
})
</script>

<template>
  <section class="project_detail">
    <div class="project_detail__container">
      <button class="project_detail__back" @click="router.push('/projects')">
        <Icon icon="mdi:arrow-left" class="w-5 h-5" />
        Back to projects
      </button>

      <div v-if="loading" class="project_detail__loading">
        <div class="project_detail__skeleton" />
        <div class="project_detail__skeleton" />
        <div class="project_detail__skeleton" />
      </div>

      <template v-else-if="project">
        <div class="project_detail__header">
          <div class="project_detail__meta">
            <span class="project_detail__category">{{ project.categories.join(', ') || project.category }}</span>
            <span class="project_detail__status" :class="project.status === 'completed' ? 'text-green-500' : project.status === 'testing' ? 'text-blue-500' : project.status === 'in-progress' ? 'text-amber-500' : 'text-zinc-500'">
              {{ project.status }}
            </span>
          </div>
          <h1 class="project_detail__title">{{ project.title }}</h1>
          <p class="project_detail__description">{{ project.longDescription }}</p>
        </div>

        <div class="project_detail__actions">
          <AppButton v-if="mainLink" variant="primary" iconRight="mdi:open-in-new" @click="openUrl(mainLink.url!)">
            {{ t('projects.live_demo') }}
          </AppButton>
          <AppButton v-if="sourceLink" variant="outline" iconLeft="mdi:github" @click="openUrl(sourceLink.url!)">
            {{ t('projects.source_code') }}
          </AppButton>
        </div>

        <div class="project_detail__techs">
          <h3 class="project_detail__section-title">{{ t('projects.technologies') }}</h3>
          <div class="project_detail__tech-list">
            <span v-for="tech in project.technologies" :key="tech.name" class="project_detail__tech">
              {{ tech.name || tech }}
            </span>
          </div>
        </div>

        <div class="project_detail__timeline">
          <h3 class="project_detail__section-title">{{ t('projects.timeline_title') }}</h3>

          <div class="project_detail__progress">
            <div class="project_detail__progress-bar">
              <div class="project_detail__progress-fill" :style="{ width: `${progressPercent}%` }" />
            </div>
            <span class="project_detail__progress-text">{{ progressPercent }}%</span>
          </div>

          <div class="project_detail__timeline-list">
            <div
              v-for="(entry, i) in project.timeline"
              :key="i"
              class="project_detail__timeline-item"
              :style="{ '--line-color': statusLineColor(entry.status) }"
            >
              <div class="project_detail__timeline-line">
                <div class="project_detail__timeline-dot" :class="statusColor(entry.status)">
                  <Icon :icon="statusIcon(entry.status)" class="w-5 h-5" />
                </div>
              </div>

              <div class="project_detail__timeline-card">
                <div class="project_detail__timeline-header">
                  <span class="project_detail__timeline-date font-mono text-sm">{{ entry.date }}</span>
                  <span class="project_detail__timeline-status" :class="statusColor(entry.status)">{{ entry.status }}</span>
                </div>
                <h4 class="project_detail__timeline-title">{{ entry.title }}</h4>
                <p class="project_detail__timeline-desc">{{ entry.description }}</p>
                <img
                  v-if="entry.imageUrl"
                  :src="entry.imageUrl"
                  :alt="entry.title"
                  class="project_detail__timeline-img"
                  loading="lazy"
                />
              </div>
            </div>
          </div>
        </div>
      </template>

      <div v-else class="project_detail__not-found">
        <Icon icon="mdi:alert-circle-outline" class="w-16 h-16 mb-4 opacity-30" />
        <p>Project not found</p>
        <AppButton variant="primary" class="mt-4" @click="router.push('/projects')">
          Back to projects
        </AppButton>
      </div>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.project_detail {
  --color-dot-done: #22c55e;
  --color-dot-testing: #3b82f6;
  --color-dot-progress: #f59e0b;
  --color-dot-todo: #52525b;

  @apply py-20 px-4;

  &__container {
    @apply max-w-4xl mx-auto;
  }

  &__back {
    @apply flex items-center gap-2 text-sm mb-8 transition-colors cursor-pointer;
    color: var(--color-text-secondary);

    &:hover {
      color: var(--color-accent);
    }
  }

  &__loading {
    @apply space-y-4;
  }

  &__skeleton {
    @apply h-16 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  &__header {
    @apply mb-8;
  }

  &__meta {
    @apply flex items-center gap-3 mb-4;
  }

  &__category {
    @apply text-xs font-mono px-2 py-0.5 rounded uppercase tracking-wider;
    background-color: var(--color-accent);
    color: white;
  }

  &__status {
    @apply text-xs font-mono capitalize;
  }

  &__title {
    @apply text-3xl md:text-4xl font-heading font-bold mb-4;
    color: var(--color-text);
  }

  &__description {
    @apply text-base leading-relaxed;
    color: var(--color-text-secondary);
  }

  &__actions {
    @apply flex items-center gap-3 mb-10;
  }

  &__section-title {
    @apply text-lg font-heading font-semibold mb-4;
    color: var(--color-text);
  }

  &__techs {
    @apply mb-10;
  }

  &__tech-list {
    @apply flex flex-wrap gap-2;
  }

  &__tech {
    @apply px-3 py-1 rounded-lg text-sm font-mono;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
    color: var(--color-text);
  }

  &__timeline {
    @apply mb-10;
  }

  &__progress {
    @apply flex items-center gap-3 mb-10;
  }

  &__progress-bar {
    @apply flex-1 h-2 rounded-full overflow-hidden;
    background-color: var(--color-bg);
  }

  &__progress-fill {
    @apply h-full rounded-full;
    background: linear-gradient(90deg, var(--color-accent), #3b82f6, #22c55e);
    transition: width 1s ease-out;
  }

  &__progress-text {
    @apply text-sm font-mono font-bold;
    color: var(--color-accent);
  }

  &__timeline-list {
    @apply relative flex flex-col;
  }

  &__timeline-item {
    @apply relative flex items-start gap-6 pb-10 last:pb-0;

    // Vertical line — from this dot down to the next dot
    &::before {
      content: '';
      @apply absolute left-[19px] w-0.5;
      top: 16px;
      bottom: -24px;
      background: var(--line-color, var(--color-border));
      opacity: 0.35;
      pointer-events: none;
    }

    &:last-child::before {
      display: none;
    }
  }

  &__timeline-line {
    @apply relative flex flex-col items-center;
    flex: 0 0 auto;
    width: 40px;

    // Horizontal connector — from dot to card
    &::after {
      content: '';
      @apply absolute left-1/2 top-4 h-0.5;
      width: 44px;
      background: var(--line-color, var(--color-border));
      opacity: 0.3;
      pointer-events: none;
    }
  }

  // Last item — clip the vertical line
  &__timeline-item:last-child &__timeline-line::before {
    height: 0;
  }

  &__timeline-dot {
    @apply relative z-10 flex items-center justify-center rounded-full;
    width: 32px;
    height: 32px;
    background-color: var(--color-bg);
    border: 2px solid var(--color-border);
    transition: border-color 0.2s, box-shadow 0.2s;

    svg {
      @apply drop-shadow-sm;
    }

    &.text-green-500 { border-color: var(--color-dot-done); }
    &.text-blue-500 { border-color: var(--color-dot-testing); }
    &.text-amber-500 { border-color: var(--color-dot-progress); }
    &.text-zinc-500 { border-color: var(--color-dot-todo); }
  }

  &__timeline-card {
    @apply flex-1 min-w-0 p-4 rounded-xl border transition-all duration-200;
    background-color: var(--color-surface);
    border-color: var(--color-border);
  }

  &__timeline-item:hover &__timeline-card {
    border-color: var(--color-accent);
    box-shadow: 0 4px 20px rgba(37, 99, 235, 0.08);
  }

  &__timeline-header {
    @apply flex items-center justify-between mb-2;
  }

  &__timeline-date {
    color: var(--color-text-secondary);
  }

  &__timeline-status {
    @apply px-2 py-0.5 rounded font-mono text-xs;
    background-color: var(--color-bg);
    text-transform: capitalize;
  }

  &__timeline-title {
    @apply font-heading font-semibold mb-1;
    color: var(--color-text);
  }

  &__timeline-desc {
    @apply text-sm;
    color: var(--color-text-secondary);
  }

  &__timeline-img {
    @apply mt-3 w-full rounded-lg object-cover;
    max-height: 200px;
    border: 1px solid var(--color-border);
  }

  &__not-found {
    @apply text-center py-20;
    color: var(--color-text-secondary);
  }
}
</style>
