<script setup lang="ts">
import { ref } from 'vue'
import { useParticles } from '@/composables/useParticles'

const canvasRef = ref<HTMLCanvasElement | null>(null)
useParticles(canvasRef)
</script>

<template>
  <canvas
    ref="canvasRef"
    class="particle_network"
    aria-hidden="true"
  />
</template>

<style lang="scss" scoped>
.particle_network {
  @apply fixed inset-0 pointer-events-none z-0;
}
</style>
