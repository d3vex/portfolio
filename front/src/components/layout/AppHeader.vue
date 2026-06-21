<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import { useRouter, useRoute } from 'vue-router'
import { useAppStore } from '@/stores/app'

const { t } = useI18n()
const router = useRouter()
const route = useRoute()
const appStore = useAppStore()

const navItems = [
  { label: 'nav.home', path: '/' },
  { label: 'nav.about', path: '/about' },
  { label: 'nav.projects', path: '/projects' },
  { label: 'nav.timeline', path: '/timeline' },
/*   { label: 'nav.blog', path: '/blog' },
 */  { label: 'nav.contact', path: '/contact' },
] as const

function navigate(path: string) {
  router.push(path)
}
</script>

<template>
  <header class="app_header">
    <nav class="app_header__nav">
      <button class="app_header__logo" @click="navigate('/')">
        <span class="text-cyber-green">&gt;</span>
        <span class="font-heading font-bold text-lg">D3VEX</span>
        <span class="text-zinc-500 animate-pulse-glow">_</span>
      </button>

      <div class="app_header__links">
        <button
          v-for="item in navItems"
          :key="item.path"
          class="app_header__link"
          :class="{ 'app_header__link--active': route.path === item.path }"
          @click="navigate(item.path)"
        >
          {{ t(item.label) }}
        </button>
      </div>

      <div class="app_header__actions">
        <button
          class="app_header__action"
          :title="t('theme.toggle')"
          @click="appStore.toggleTheme()"
        >
          <Icon v-if="appStore.isDark" icon="mdi:weather-sunny" class="w-5 h-5" />
          <Icon v-else icon="mdi:weather-night" class="w-5 h-5" />
        </button>
      </div>
    </nav>
  </header>
</template>

<style lang="scss" scoped>
.app_header {
  @apply fixed top-4 left-4 right-4 z-50;

  &__nav {
    @apply max-w-6xl mx-auto flex items-center justify-between px-4 py-3 rounded-xl border;
    background-color: var(--color-nav-bg);
    border-color: var(--color-border);
    @apply backdrop-blur-lg transition-colors duration-300;
  }

  &__logo {
    @apply flex items-center gap-1.5 cursor-pointer hover:opacity-80 transition-opacity;
  }

  &__links {
    @apply hidden md:flex items-center gap-1;
  }

  &__link {
    @apply px-3 py-1.5 text-sm rounded-lg transition-colors duration-200;
    color: var(--color-text-secondary);

    &:hover {
      color: var(--color-text);
      @apply bg-zinc-800/30 dark:bg-zinc-200/30;
    }

    &--active {
      color: var(--color-text);
      @apply bg-zinc-800/20 dark:bg-zinc-200/20 font-medium;
    }
  }

  &__actions {
    @apply flex items-center gap-1;
  }

  &__action {
    @apply p-2 rounded-lg transition-colors duration-200;
    color: var(--color-text-secondary);

    &:hover {
      color: var(--color-text);
      @apply bg-zinc-800/30 dark:bg-zinc-200/30;
    }

  }
}
</style>
