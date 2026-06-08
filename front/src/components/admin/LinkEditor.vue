<script setup lang="ts">
import { ref } from 'vue'

interface Link {
  label: string
  url: string
  icon?: string
  type?: string
}

const props = defineProps<{ modelValue: Link[] }>()
const emit = defineEmits<{ 'update:modelValue': [value: Link[]] }>()

const linkTypes = [
  { label: 'Website', type: 'website', icon: 'mdi:web' },
  { label: 'GitHub', type: 'github', icon: 'mdi:github' },
  { label: 'LinkedIn', type: 'linkedin', icon: 'mdi:linkedin' },
  { label: 'Demo', type: 'demo', icon: 'mdi:play-circle' },
  { label: 'Documentation', type: 'docs', icon: 'mdi:file-document' },
  { label: 'Custom', type: 'custom', icon: 'mdi:link' },
]

const editing = ref<{ label: string; url: string; icon?: string; type?: string }>({ label: '', url: '', type: 'website' })
const showForm = ref(false)

function addLink() {
  if (!editing.value.label || !editing.value.url) return
  const typeDef = linkTypes.find(t => t.type === editing.value.type)
  const link = {
    ...editing.value,
    icon: editing.value.icon || typeDef?.icon || 'mdi:link',
  }
  emit('update:modelValue', [...props.modelValue, link])
  editing.value = { label: '', url: '', type: 'website' }
  showForm.value = false
}

function removeLink(index: number) {
  const next = [...props.modelValue]
  next.splice(index, 1)
  emit('update:modelValue', next)
}

function applyType(type: string) {
  editing.value.type = type
  const typeDef = linkTypes.find(t => t.type === type)
  if (typeDef) {
    editing.value.icon = typeDef.icon
    editing.value.label = typeDef.type === 'custom' ? '' : typeDef.label
  }
}
</script>

<template>
  <div class="space-y-2">
    <div v-for="(link, i) in modelValue" :key="i"
      class="flex items-center justify-between px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800">
      <div class="flex items-center gap-2 text-sm">
        <Icon v-if="link.icon" :icon="link.icon" class="w-4 h-4 text-accent" />
        <span class="font-medium">{{ link.label }}</span>
        <span class="text-surface-400 text-xs">{{ link.url }}</span>
      </div>
      <button @click="removeLink(i)" type="button" class="text-red-500 hover:text-red-700 text-xs cursor-pointer">Remove</button>
    </div>

    <button v-if="!showForm" @click="showForm = true" type="button"
      class="w-full py-2 rounded-lg border-2 border-dashed border-gray-300 dark:border-surface-600 text-sm text-surface-400 hover:border-accent/50 hover:text-accent transition-colors cursor-pointer">
      + Add Link
    </button>

    <div v-if="showForm" class="p-3 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800/50 space-y-2">
      <div class="flex gap-2 flex-wrap">
        <button v-for="t in linkTypes" :key="t.type" @click="applyType(t.type)" type="button"
          class="px-2 py-1 text-xs rounded-lg border transition-colors cursor-pointer"
          :class="editing.type === t.type ? 'bg-accent text-white border-accent' : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
          {{ t.label }}
        </button>
      </div>
      <div class="flex gap-2">
        <input v-model="editing.label" placeholder="Label"
          class="flex-1 px-3 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm outline-none" />
        <input v-model="editing.url" placeholder="URL"
          class="flex-1 px-3 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm outline-none" />
        <button @click="addLink" type="button"
          class="px-3 py-1.5 bg-accent text-white rounded-lg text-sm hover:bg-accent-hover transition-colors cursor-pointer">Add</button>
        <button @click="showForm = false; editing = { label: '', url: '', type: 'website' }" type="button"
          class="w-7 h-7 flex items-center justify-center rounded-lg border border-gray-200 dark:border-surface-700 text-surface-400 hover:text-red-500 hover:border-red-300 transition-colors cursor-pointer text-sm leading-none">&times;</button>
      </div>
    </div>
  </div>
</template>
