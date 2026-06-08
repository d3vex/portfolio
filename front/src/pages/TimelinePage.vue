<script setup lang="ts">
import { ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { getTimeline } from '@/lib/api/timeline'

const { t } = useI18n()
const { data: events, loading } = useAsyncData(() => getTimeline())

const expanded = ref<Set<string>>(new Set())

const years = computed(() => {
  if (!events.value) return []
  const set = new Set<string>()
  for (const e of events.value) {
    set.add(e.startDate.slice(0, 4))
    if (e.endDate) set.add(e.endDate.slice(0, 4))
  }
  return [...set].sort()
})

const selectedYear = ref('')

const filteredEvents = computed(() => {
  if (!events.value) return []
  let list = [...events.value]
  if (selectedYear.value) {
    list = list.filter(e => {
      const start = e.startDate.slice(0, 4)
      const end = e.endDate ? e.endDate.slice(0, 4) : '9999'
      return start <= selectedYear.value && end >= selectedYear.value
    })
  }
  return list.sort((a, b) => {
    const aEnd = a.endDate || '9999-99'
    const bEnd = b.endDate || '9999-99'
    const cmp = bEnd.localeCompare(aEnd)
    if (cmp !== 0) return cmp
    return b.startDate.localeCompare(a.startDate)
  })
})

function toggleSubProjects(id: string) {
  const next = new Set(expanded.value)
  if (next.has(id)) next.delete(id)
  else next.add(id)
  expanded.value = next
}

function formatDate(date: string): string {
  const [y, m] = date.split('-')
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  return m ? `${months[parseInt(m) - 1]} ${y}` : y
}
</script>

<template>
  <section class="timeline_page">
    <div class="timeline_page__container">
      <div class="timeline_page__header">
        <h1 class="timeline_page__title">{{ t('timeline.title') }}</h1>
        <p class="timeline_page__subtitle">{{ t('timeline.subtitle') }}</p>
      </div>

      <!-- Year filter -->
      <div v-if="years.length > 1" class="timeline_page__filter">
        <button
          class="timeline_page__filter-btn"
          :class="{ 'timeline_page__filter-btn--active': !selectedYear }"
          @click="selectedYear = ''"
        >
          {{ t('timeline.all') }}
        </button>
        <button
          v-for="y in years"
          :key="y"
          class="timeline_page__filter-btn"
          :class="{ 'timeline_page__filter-btn--active': selectedYear === y }"
          @click="selectedYear = y"
        >
          {{ y }}
        </button>
      </div>

      <div v-if="loading" class="timeline_page__loading">
        <div v-for="n in 4" :key="n" class="timeline_page__skeleton" />
      </div>

      <div v-else-if="!filteredEvents.length" class="timeline_page__empty">
        {{ t('timeline.empty') }}
      </div>

      <div v-else class="timeline_page__list">
        <div
          v-for="event in filteredEvents"
          :key="event.id"
          class="timeline_page__item"
          :class="`timeline_page__item--${event.type}`"
        >
          <div class="timeline_page__item-icon">
            <Icon :icon="event.icon" class="w-6 h-6" />
          </div>

          <div class="timeline_page__item-content">
            <div class="timeline_page__item-header">
              <span class="timeline_page__item-type">{{ t(`timeline.${event.type}`) }}</span>
              <span class="timeline_page__item-date font-mono">
                {{ formatDate(event.startDate) }}
                <template v-if="event.endDate"> – {{ formatDate(event.endDate) }}</template>
                <template v-else> – {{ t('timeline.present') }}</template>
              </span>
            </div>
            <h3 class="timeline_page__item-title">{{ event.title }}</h3>
            <p class="timeline_page__item-subtitle">{{ event.subtitle }}</p>
            <p class="timeline_page__item-desc">{{ event.description }}</p>
            <div class="timeline_page__item-tags">
              <span v-for="tag in event.tags" :key="tag" class="timeline_page__item-tag">
                {{ tag }}
              </span>
            </div>

            <!-- Sub-projects (school projects for education entries) -->
            <div v-if="event.subProjects?.length" class="timeline_page__subprojects">
              <button
                class="timeline_page__sub-toggle"
                @click="toggleSubProjects(event.id)"
              >
                <Icon
                  :icon="expanded.has(event.id) ? 'mdi:chevron-up' : 'mdi:chevron-down'"
                  class="w-4 h-4"
                />
                <span>{{ event.subProjects.length }} school project{{ event.subProjects.length > 1 ? 's' : '' }}</span>
              </button>

              <div v-if="expanded.has(event.id)" class="timeline_page__sub-list">
                <div
                  v-for="(proj, i) in event.subProjects"
                  :key="i"
                  class="timeline_page__sub-card"
                >
                  <img
                    v-if="proj.imageUrl"
                    :src="proj.imageUrl"
                    :alt="proj.title"
                    class="timeline_page__sub-img"
                    loading="lazy"
                  />
                  <h4 class="timeline_page__sub-title">{{ proj.title }}</h4>
                  <p class="timeline_page__sub-desc">{{ proj.description }}</p>
                  <div class="timeline_page__sub-tags">
                    <span v-for="tag in proj.tags" :key="tag" class="timeline_page__sub-tag">
                      {{ tag }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.timeline_page {
  @apply py-20 px-4;

  &__container {
    @apply max-w-3xl mx-auto;
  }

  &__header {
    @apply text-center mb-16;
  }

  &__title {
    @apply text-4xl md:text-5xl font-heading font-bold mb-4;
    color: var(--color-text);
  }

  &__subtitle {
    @apply text-lg;
    color: var(--color-text-secondary);
  }

  &__loading {
    @apply space-y-6;
  }

  &__skeleton {
    @apply h-32 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  // ── List ─────────────────────────────

  &__list {
    @apply relative flex flex-col;
  }

  // ── Item (row) ────────────────────────

  &__item {
    @apply relative flex items-start gap-6 pb-14 last:pb-0;

    // Vertical connector line — from icon center to next icon center
    &::before {
      content: '';
      @apply absolute w-0.5 pointer-events-none;
      left: 23px;
      top: 24px;
      bottom: -24px;
      background: var(--color-border);
      opacity: 0.3;
    }

    &:last-child::before {
      display: none;
    }
  }

  // ── Icon ──────────────────────────────

  &__item-icon {
    @apply w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 relative z-10;
    backdrop-filter: blur(8px);
  }

  &__item--education &__item-icon {
    @apply bg-blue-500/20 text-blue-500;
    box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.15);
  }

  &__item--experience &__item-icon {
    @apply bg-green-500/20 text-green-500;
    box-shadow: 0 0 0 2px rgba(34, 197, 94, 0.15);
  }

  // ── Content card ──────────────────────

  &__item-content {
    @apply flex-1 min-w-0 p-5 rounded-xl border transition-all duration-200;
    background-color: var(--color-surface);
    border-color: var(--color-border);
  }

  &__item:hover &__item-content {
    border-color: var(--color-accent);
    box-shadow: 0 4px 20px rgba(37, 99, 235, 0.08);
  }

  &__item-header {
    @apply flex items-center justify-between mb-2;
  }

  &__item-type {
    @apply text-xs font-mono font-semibold uppercase tracking-wider;
  }

  &__item--education &__item-type {
    @apply text-blue-500;
  }

  &__item--experience &__item-type {
    @apply text-green-500;
  }

  &__item-date {
    @apply text-xs;
    color: var(--color-text-secondary);
  }

  &__item-title {
    @apply text-lg font-heading font-bold mb-1;
    color: var(--color-text);
  }

  &__item-subtitle {
    @apply text-sm mb-2;
    color: var(--color-accent);
  }

  &__item-desc {
    @apply text-sm leading-relaxed mb-3;
    color: var(--color-text-secondary);
  }

  &__item-tags {
    @apply flex flex-wrap gap-1.5;
  }

  &__item-tag {
    @apply px-2 py-0.5 rounded text-xs font-mono;
    background-color: var(--color-bg);
    color: var(--color-text-secondary);
  }

  // ── Sub-projects ──────────────────────

  &__subprojects {
    @apply mt-4 pt-4 border-t;
    border-color: var(--color-border);
  }

  &__sub-toggle {
    @apply flex items-center gap-2 text-sm font-mono cursor-pointer transition-colors;
    color: var(--color-text-secondary);

    &:hover {
      color: var(--color-accent);
    }
  }

  &__sub-list {
    @apply mt-4 space-y-4;
  }

  &__sub-card {
    @apply p-4 rounded-lg border;
    background-color: var(--color-bg);
    border-color: var(--color-border);
  }

  &__sub-img {
    @apply w-full rounded-md object-cover mb-3;
    max-height: 160px;
    border: 1px solid var(--color-border);
  }

  &__sub-title {
    @apply text-sm font-heading font-semibold mb-1;
    color: var(--color-text);
  }

  &__sub-desc {
    @apply text-xs leading-relaxed mb-2;
    color: var(--color-text-secondary);
  }

  &__sub-tags {
    @apply flex flex-wrap gap-1;
  }

  &__sub-tag {
    @apply px-1.5 py-0.5 rounded text-[11px] font-mono;
    background-color: var(--color-accent);
    opacity: 0.85;
    color: white;
  }

  // ── Filter ──────────────────────

  &__filter {
    @apply flex flex-wrap gap-2 mb-8 justify-center;
  }

  &__filter-btn {
    @apply px-4 py-1.5 rounded-lg text-sm font-mono transition-all duration-200 border;
    border-color: var(--color-border);
    color: var(--color-text-secondary);
    background: var(--color-surface);

    &:hover {
      border-color: var(--color-accent);
      color: var(--color-accent);
    }

    &--active {
      border-color: var(--color-accent);
      background: var(--color-accent);
      color: white;
    }
  }

  &__empty {
    @apply text-center py-16 text-sm font-mono;
    color: var(--color-text-secondary);
  }
}
</style>
