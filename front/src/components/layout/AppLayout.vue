<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from './AppHeader.vue'
import AppFooter from './AppFooter.vue'
import TerminalModal from '@/components/terminal/TerminalModal.vue'
import ParticleNetwork from '@/components/3d/ParticleNetwork.vue'

const route = useRoute()
const isAdmin = computed(() => route.path.startsWith('/admin'))
</script>

<template>
  <div class="app_layout">
    <template v-if="!isAdmin">
      <ParticleNetwork />
      <AppHeader />
    </template>
    <main class="app_layout__main" :class="{ 'pt-0': isAdmin }">
      <slot />
    </main>
    <AppFooter />
    <TerminalModal />
  </div>
</template>

<style lang="scss" scoped>
.app_layout {
  @apply min-h-screen flex flex-col relative;
  background-color: var(--color-bg);

  &__main {
    @apply flex-1 pt-20 relative z-10;
  }
}
</style>
