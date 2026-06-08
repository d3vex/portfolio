<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useImageUpload } from '@/composables/entities/useImageUpload'

const API_BASE = 'http://localhost:3001/api'

const emit = defineEmits<{ select: [id: string] }>()

const images = ref<any[]>([])
const loading = ref(false)
const { uploading, upload } = useImageUpload()

async function load() {
  loading.value = true
  try {
    const res = await fetch(`${API_BASE}/images`)
    if (res.ok) images.value = await res.json()
  } finally {
    loading.value = false
  }
}

async function onFileSelected(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const result = await upload(file)
  if (result) {
    await load()
    emit('select', result.id)
  }
  input.value = ''
}

onMounted(load)
</script>

<template>
  <div class="space-y-3">
    <div class="flex items-center justify-between">
      <p class="text-xs font-medium text-surface-500">Select a picture</p>
      <label class="px-3 py-1.5 bg-accent text-white rounded-lg text-xs hover:bg-accent-hover transition-colors cursor-pointer">
        {{ uploading ? 'Uploading...' : 'Upload' }}
        <input type="file" accept="image/*" @change="onFileSelected" class="hidden" />
      </label>
    </div>

    <div v-if="loading" class="text-xs text-surface-400 text-center py-4">Loading...</div>

    <div v-else-if="!images.length" class="text-xs text-surface-400 text-center py-4 border-2 border-dashed border-gray-200 dark:border-surface-700 rounded-lg">
      No images yet
    </div>

    <div v-else class="grid grid-cols-4 gap-2 max-h-48 overflow-y-auto">
      <button v-for="img in images" :key="img.id" type="button" @click="emit('select', img.id)"
        class="aspect-square rounded-lg overflow-hidden border-2 border-transparent hover:border-accent transition-colors cursor-pointer">
        <img :src="`${API_BASE}/images/${img.id}`" class="w-full h-full object-cover" loading="lazy" />
      </button>
    </div>
  </div>
</template>
