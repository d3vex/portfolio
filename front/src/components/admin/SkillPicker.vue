<script setup lang="ts">
import { ref, computed } from 'vue'

const props = defineProps<{
  modelValue: string[]
  skills: { id: string; name: string; cvCategory?: string }[]
  label?: string
}>()

const emit = defineEmits<{ 'update:modelValue': [value: string[]] }>()

const search = ref('')
const show = ref(false)
const root = ref<HTMLElement | null>(null)

const filtered = computed(() => {
  if (!search.value) return props.skills
  const q = search.value.toLowerCase()
  return props.skills.filter(s => s.name.toLowerCase().includes(q))
})

function toggle(id: string) {
  const idx = props.modelValue.indexOf(id)
  if (idx > -1) {
    emit('update:modelValue', props.modelValue.filter(v => v !== id))
  } else {
    emit('update:modelValue', [...props.modelValue, id])
  }
}

function onBlur(e: FocusEvent) {
  if (!root.value?.contains(e.relatedTarget as Node)) {
    show.value = false
  }
}
</script>

<template>
  <div ref="root" class="relative text-sm" @focusin="show = true" @focusout="onBlur">
    <input v-model="search" :placeholder="`Search ${label || 'skills'}...`"
      class="w-full px-2.5 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-xs outline-none focus:ring-2 focus:ring-accent/50"
      @focus="show = true" />

    <div v-if="show && filtered.length" class="absolute z-50 mt-1 w-full max-h-48 overflow-y-auto rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 shadow-lg">
      <button v-for="sk in filtered" :key="sk.id" type="button" @mousedown.prevent @click="toggle(sk.id)"
        class="w-full text-left px-2.5 py-1.5 text-xs flex items-center gap-2 hover:bg-accent/5 transition-colors cursor-pointer"
        :class="modelValue.includes(sk.id) ? 'bg-accent/10 text-accent' : ''">
        <span class="w-3.5 h-3.5 rounded border flex items-center justify-center text-[8px] transition-colors"
          :class="modelValue.includes(sk.id) ? 'bg-accent text-white border-accent' : 'border-gray-300 dark:border-surface-600'">
          <span v-if="modelValue.includes(sk.id)">&check;</span>
        </span>
        {{ sk.name }}
      </button>
    </div>
    <div v-else-if="show && !filtered.length && search"
      class="absolute z-50 mt-1 w-full rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 shadow-lg px-2.5 py-2 text-xs text-surface-400">
      No match
    </div>

    <div v-if="modelValue.length" class="flex flex-wrap gap-1 mt-1.5">
      <span v-for="sid in modelValue" :key="sid"
        class="inline-flex items-center gap-1 px-1.5 py-0.5 text-[10px] rounded bg-accent/10 text-accent font-mono">
        {{ skills.find(s => s.id === sid)?.name || '?' }}
        <button type="button" @click="toggle(sid)" class="hover:text-red-500 cursor-pointer">&times;</button>
      </span>
    </div>
  </div>
</template>
