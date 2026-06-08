<script setup lang="ts">
withDefaults(defineProps<{
  variant?: 'primary' | 'secondary' | 'ghost' | 'outline'
  size?: 'sm' | 'md' | 'lg'
  iconLeft?: string
  iconRight?: string
  disabled?: boolean
  loading?: boolean
  type?: 'button' | 'submit' | 'reset'
}>(), {
  variant: 'primary',
  size: 'md',
  disabled: false,
  loading: false,
  type: 'button',
})

const emit = defineEmits<{
  click: [e: MouseEvent]
}>()
</script>

<template>
  <button
    :type="type"
    :disabled="disabled || loading"
    class="app_button"
    :class="[
      `app_button--${variant}`,
      `app_button--${size}`,
      { 'app_button--disabled': disabled || loading },
    ]"
    @click="emit('click', $event)"
  >
    <Icon v-if="iconLeft && !loading" :icon="iconLeft" class="app_button__icon app_button__icon--left" />
    <svg v-if="loading" class="app_button__spinner" viewBox="0 0 24 24" fill="none">
      <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" stroke-dasharray="31.4 31.4" stroke-linecap="round" />
    </svg>
    <span class="app_button__text"><slot /></span>
    <Icon v-if="iconRight && !loading" :icon="iconRight" class="app_button__icon app_button__icon--right" />
  </button>
</template>

<style lang="scss" scoped>
.app_button {
  @apply inline-flex items-center justify-center gap-2 font-medium rounded-lg transition-all duration-200 cursor-pointer border;
  @apply focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2;

  &--primary {
    @apply bg-accent text-white border-accent hover:bg-accent-hover focus-visible:ring-accent;
  }

  &--secondary {
    @apply bg-zinc-800 text-zinc-100 border-zinc-700 hover:bg-zinc-700 dark:bg-zinc-200 dark:text-zinc-900 dark:border-zinc-300 dark:hover:bg-zinc-300 focus-visible:ring-zinc-500;
  }

  &--ghost {
    @apply bg-transparent text-zinc-300 border-transparent hover:bg-zinc-800/50 dark:text-zinc-700 dark:hover:bg-zinc-100 focus-visible:ring-zinc-500;
  }

  &--outline {
    @apply bg-transparent text-accent border-accent/50 hover:bg-accent/10 focus-visible:ring-accent;
  }

  &--disabled {
    @apply opacity-50 cursor-not-allowed pointer-events-none;
  }

  &--sm {
    @apply px-3 py-1.5 text-sm;
  }

  &--md {
    @apply px-5 py-2.5 text-sm;
  }

  &--lg {
    @apply px-7 py-3 text-base;
  }

  &__icon {
    @apply w-5 h-5 flex-shrink-0;
  }

  &__spinner {
    @apply w-4 h-4 animate-spin;
  }
}
</style>
