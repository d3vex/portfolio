<template>
  <button
    @click="toggleTheme"
    :aria-label="`Switch to ${currentTheme === 'light' ? 'dark' : 'light'} theme`"
    class="
      fixed
      top-8 right-8 md:top-4 md:right-4
      z-[1000]

      /* sizing */
      w-12 h-12 md:w-11 md:h-11
      rounded-full

      /* glassmorphism */
      bg-glass-bg
      backdrop-blur-md
      border border-glass-border
      shadow-glass

      /* layout */
      flex items-center justify-center

      /* transitions */
      transition-all duration-300 ease-[cubic-bezier(0.4,0,0.2,1)]
      text-text-primary

      /* hover */
      hover:bg-glass-bg-hover
      hover:border-glass-border-hover
      hover:scale-105
      hover:shadow-[0_8px_32px_0_var(--shadow-color)]

      /* active */
      active:scale-95
    "
  >
    <!-- DARK MODE ICON (Moon) -->
    <svg
      v-if="currentTheme === 'light'"
      class="w-6 h-6 md:w-5 md:h-5 transition-transform duration-300 ease-out group-hover:rotate-[20deg]"
      viewBox="0 0 24 24" fill="none"
      stroke="currentColor" stroke-width="2"
    >
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
    </svg>

    <!-- LIGHT MODE ICON (Sun) -->
    <svg
      v-else
      class="w-6 h-6 md:w-5 md:h-5 transition-transform duration-300 ease-out group-hover:rotate-[20deg]"
      viewBox="0 0 24 24" fill="none"
      stroke="currentColor" stroke-width="2"
    >
      <circle cx="12" cy="12" r="5"></circle>
      <line x1="12" y1="1" x2="12" y2="3"></line>
      <line x1="12" y1="21" x2="12" y2="23"></line>
      <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
      <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
      <line x1="1" y1="12" x2="3" y2="12"></line>
      <line x1="21" y1="12" x2="23" y2="12"></line>
      <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
      <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
    </svg>
  </button>
</template>

<script setup lang="ts">
import { useTheme } from '@/composables/useTheme';
const { currentTheme, toggleTheme } = useTheme();
</script>
