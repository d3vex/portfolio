<template>
  <div class="flex flex-col gap-2 w-full">
    <label v-if="label" :for="id" class="text-text-secondary text-sm font-medium">{{ label }}</label>
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
      class="input resize-y min-h-25"
    ></textarea>
    <span v-if="error" class="text-danger text-sm">{{ error }}</span>
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
@reference "../style.css";


.input {
  @apply bg-glass-bg backdrop-blur-md border border-glass-border rounded-xl px-4 py-3
   text-text-primary outline-none transition-all duration-300 ease-initial;

   &::placeholder {
    @apply text-text-tertiary;
   }
   &:focus {
    @apply bg-glass-bg-hover border-primary shadow-glass-bg;
   }
   &:disabled {
    @apply opacity-50 cursor-not-allowed;
   }
}

</style>
