<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Icon } from '@iconify/vue'
import { getCvStyles } from '@/lib/api/cv'
import type { CvStyle } from '@/lib/types'

const props = defineProps<{
  modelValue: string
  styles?: CvStyle[]
}>()

const emit = defineEmits<{ 'update:modelValue': [value: string] }>()

const styles = ref<CvStyle[]>(props.styles ?? [])
const loading = ref(false)
const loadError = ref('')

onMounted(async () => {
  if (props.styles && props.styles.length > 0) return
  loading.value = true
  try {
    styles.value = await getCvStyles()
  } catch (err) {
    loadError.value = err instanceof Error ? err.message : 'Failed to load styles'
  } finally {
    loading.value = false
  }
})

function select(id: string) {
  emit('update:modelValue', id)
}
</script>

<template>
  <div>
    <p v-if="loading" class="text-sm text-surface-400 py-4">Loading styles...</p>
    <p v-else-if="loadError" class="text-sm text-error py-4">{{ loadError }}</p>
    <div v-else-if="styles.length" class="grid sm:grid-cols-2 lg:grid-cols-3 gap-3">
      <button
        v-for="style in styles"
        :key="style.id"
        type="button"
        @click="select(style.id)"
        class="text-left rounded-xl border p-4 transition-all cursor-pointer"
        :class="modelValue === style.id
          ? 'border-accent ring-2 ring-accent/40 bg-accent/5'
          : 'border-gray-200 dark:border-surface-700 hover:border-accent/50 bg-white dark:bg-surface-800'"
      >
        <div class="flex items-start justify-between gap-2 mb-2">
          <span class="text-sm font-semibold">{{ style.name }}</span>
          <span v-if="modelValue === style.id" class="text-accent">
            <Icon icon="mdi:check-circle" class="w-5 h-5" />
          </span>
        </div>
        <p class="text-xs text-surface-500 leading-relaxed mb-3">{{ style.description }}</p>
        <div class="flex h-2.5 rounded-full overflow-hidden border border-gray-200 dark:border-surface-700">
          <div class="flex-1" :style="{ backgroundColor: style.accent }" />
          <div class="flex-1" :style="{ backgroundColor: style.sidebar }" />
        </div>
      </button>
    </div>
  </div>
</template>
