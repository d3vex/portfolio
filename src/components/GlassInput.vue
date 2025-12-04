<template>
  <div class="glass-input">
    <label v-if="label" :for="id" class="label">{{ label }}</label>
    <input
      v-if="type !== 'textarea'"
      :id="id"
      :type="type"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      @input="handleInput"
      class="input"
    />
    <textarea
      v-else
      :id="id"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :rows="rows"
      @input="handleInput"
      class="input textarea"
    ></textarea>
    <span v-if="error" class="error">{{ error }}</span>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  modelValue: string | number;
  type?: 'text' | 'email' | 'password' | 'number' | 'textarea';
  label?: string;
  placeholder?: string;
  error?: string;
  disabled?: boolean;
  rows?: number;
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  disabled: false,
  rows: 4,
});

const emit = defineEmits<{
  'update:modelValue': [value: string | number];
}>();

const id = computed(() => `input-${Math.random().toString(36).substr(2, 9)}`);

const handleInput = (event: Event) => {
  const target = event.target as HTMLInputElement | HTMLTextAreaElement;
  emit('update:modelValue', props.type === 'number' ? Number(target.value) : target.value);
};
</script>

<style scoped>
.glass-input {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  width: 100%;
}

.label {
  color: var(--color-text-secondary);
  font-size: 0.875rem;
  font-weight: 500;
}

.input {
  background: var(--color-glass-bg);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid var(--color-glass-border);
  border-radius: 12px;
  padding: 0.75rem 1rem;
  color: var(--color-text-primary);
  font-size: 1rem;
  outline: none;
  transition: all 0.3s ease;
  font-family: inherit;
}

.input::placeholder {
  color: var(--color-text-tertiary);
}

.input:focus {
  background: var(--color-glass-bg-hover);
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(74, 108, 247, 0.1);
}

.input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.textarea {
  resize: vertical;
  min-height: 100px;
}

.error {
  color: var(--color-danger);
  font-size: 0.875rem;
}
</style>
