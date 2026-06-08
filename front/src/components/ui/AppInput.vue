<script setup lang="ts">
withDefaults(defineProps<{
  modelValue: string
  label?: string
  placeholder?: string
  type?: string
  iconLeft?: string
  iconRight?: string
  error?: string
  disabled?: boolean
  readonly?: boolean
  rows?: number
  textarea?: boolean
}>(), {
  type: 'text',
  disabled: false,
  readonly: false,
  textarea: false,
  rows: 4,
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

function onInput(e: Event) {
  const target = e.target as HTMLInputElement | HTMLTextAreaElement
  emit('update:modelValue', target.value)
}
</script>

<template>
  <div class="app_input">
    <label v-if="label" class="app_input__label">{{ label }}</label>
    <div class="app_input__wrapper" :class="{ 'app_input__wrapper--error': error }">
      <Icon v-if="iconLeft" :icon="iconLeft" class="app_input__icon app_input__icon--left" />
      <textarea
        v-if="textarea"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :rows="rows"
        class="app_input__field app_input__field--textarea"
        @input="onInput"
      />
      <input
        v-else
        :value="modelValue"
        :type="type"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        class="app_input__field"
        @input="onInput"
      />
      <Icon v-if="iconRight" :icon="iconRight" class="app_input__icon app_input__icon--right" />
    </div>
    <p v-if="error" class="app_input__error">{{ error }}</p>
  </div>
</template>

<style lang="scss" scoped>
.app_input {
  @apply w-full;

  &__label {
    @apply block text-sm font-medium mb-1.5;
    color: var(--color-text-secondary);
  }

  &__wrapper {
    @apply relative flex items-center;
    background-color: var(--color-surface);

    &--error {
      .app_input__field {
        border-color: rgba(239, 68, 68, 0.5);

        &:focus {
          border-color: rgb(239, 68, 68);
        }
      }
    }
  }

  &__icon {
    @apply absolute w-5 h-5 pointer-events-none;
    color: var(--color-text-secondary);

    &--left {
      @apply left-3;
    }

    &--right {
      @apply right-3;
    }
  }

  &__field {
    @apply w-full border rounded-lg px-4 py-2.5 transition-colors duration-200;
    @apply focus:outline-none focus:ring-1 focus:ring-accent/50;
    @apply disabled:opacity-50 disabled:cursor-not-allowed;
    background-color: var(--color-bg);
    border-color: var(--color-border);
    color: var(--color-text);
    caret-color: var(--color-accent);
    box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);

    &::placeholder {
      color: var(--color-text-secondary);
      opacity: 0.5;
    }

    &:focus {
      border-color: var(--color-accent);
    }

    &--textarea {
      @apply resize-y min-h-[100px];
    }
  }

  .app_input__wrapper:has(.app_input__icon--left) .app_input__field,
  .app_input__wrapper:has(.app_input__icon--left) .app_input__field--textarea {
    @apply pl-10;
  }

  .app_input__wrapper:has(.app_input__icon--right) .app_input__field,
  .app_input__wrapper:has(.app_input__icon--right) .app_input__field--textarea {
    @apply pr-10;
  }

  &__error {
    @apply mt-1 text-sm text-error;
  }
}
</style>
