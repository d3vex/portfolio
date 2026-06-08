<script setup lang="ts">
import { ref, computed } from 'vue'
import { useImageUpload } from '@/composables/entities/useImageUpload'

const props = defineProps<{
  modelValue: string
  imageId?: string
}>()
const emit = defineEmits<{
  'update:modelValue': [value: string]
  'update:imageId': [value: string]
}>()

const { uploading, error, upload } = useImageUpload()
const preview = ref<string | null>(null)

async function onFileSelected(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  preview.value = URL.createObjectURL(file)
  const result = await upload(file)
  if (result) {
    emit('update:modelValue', result.url)
    emit('update:imageId', result.id)
  }
  input.value = ''
}

function remove() {
  emit('update:modelValue', '')
  emit('update:imageId', '')
  preview.value = null
}

const imgSrc = computed(() => {
  if (preview.value) return preview.value
  if (!props.modelValue) return null
  if (props.modelValue.startsWith('http')) return props.modelValue
  return `http://localhost:3001${props.modelValue}`
})

</script>

<template>
  <div class="space-y-2">
    <div v-if="imgSrc" class="relative w-full h-40 rounded-xl overflow-hidden border border-gray-200 dark:border-surface-700 bg-surface-100 dark:bg-surface-800">
      <img :src="imgSrc" class="w-full h-full object-cover" />
      <button @click="remove" type="button"
        class="absolute top-2 right-2 w-7 h-7 rounded-full bg-red-500 text-white flex items-center justify-center text-xs hover:bg-red-600 transition-colors cursor-pointer">
        &times;
      </button>
    </div>
    <div v-else
      class="w-full h-40 rounded-xl border-2 border-dashed border-gray-300 dark:border-surface-600 flex flex-col items-center justify-center text-surface-400 hover:border-accent/50 transition-colors cursor-pointer"
      @click="($refs.fileInput as HTMLInputElement)?.click()">
      <svg class="w-8 h-8 mb-2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
        <path d="M12 4v12m0 0l-3-3m3 3l3-3M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2" />
      </svg>
      <span class="text-sm">{{ uploading ? 'Uploading...' : 'Click to upload image' }}</span>
      <span class="text-xs mt-1">Max 15MB</span>
    </div>
    <input ref="fileInput" type="file" accept="image/*" @change="onFileSelected" class="hidden" />
    <p v-if="error" class="text-xs text-red-500">{{ error }}</p>
  </div>
</template>
