<template>
  <button class="glass-button" :class="[variant, size, { disabled }]" :disabled="disabled" @click="handleClick">
    <slot></slot>
  </button>
</template>

<script setup lang="ts">
import "../style.css"
interface Props {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'medium',
  disabled: false,
});

const emit = defineEmits<{
  click: [];
}>();

const handleClick = () => {
  emit('click');
};
</script>

<style scoped>
@reference "../style.css";

.glass-button {
  @apply bg-glass-bg backdrop-blur-md border border-glass-border rounded-xl px-6 py-3 text-text-primary font-medium
  cursor-pointer transition-all duration-300 ease-in-out outline-0;

  &:hover:not(.disabled) {
    @apply bg-glass-bg-hover border-glass-border-hover translate-y-0.5 shadow-lg shadow-shadow;
  }
  &:active:not(.disabled) {
    @apply bg-glass-bg border-glass-border translate-y-0;
  }

  &.primary {
    @apply bg-primary border-primary-dark text-white;

    &:hover:not(.disabled) {
      @apply bg-primary-dark border-primary-dark;
    }
  }
  &.secondary {
    @apply bg-glass-bg border-glass-border;
  }
  &.danger {
    @apply bg-danger border-danger text-white;

    &:hover:not(.disabled) {
      @apply opacity-90;
    }
  }
  &.small {
    @apply px-4 py-2 text-sm;
  }
  &.large {
    @apply px-8 py-4 text-lg;
  }
  &.disabled {
    @apply opacity-50 cursor-not-allowed;
  }
  
}
</style>
