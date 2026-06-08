<script setup lang="ts">
import { ref } from 'vue'

const props = defineProps<{
  modelValue: string[]
  placeholder?: string
  label?: string
}>()

const emit = defineEmits<{ 'update:modelValue': [value: string[]] }>()

const newItem = ref('')
const editing = ref<{ index: number; value: string } | null>(null)

function add() {
  const val = newItem.value.trim()
  if (!val) return
  emit('update:modelValue', [...props.modelValue, val])
  newItem.value = ''
}

function remove(index: number) {
  const next = [...props.modelValue]
  next.splice(index, 1)
  emit('update:modelValue', next)
}

function startEdit(index: number) {
  editing.value = { index, value: props.modelValue[index] }
}

function saveEdit() {
  if (!editing.value) return
  const val = editing.value.value.trim()
  if (!val) return
  const next = [...props.modelValue]
  next[editing.value.index] = val
  emit('update:modelValue', next)
  editing.value = null
}

function cancelEdit() {
  editing.value = null
}

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Enter') { add(); e.preventDefault() }
}
</script>

<template>
  <div class="space-y-1.5">
    <div v-if="modelValue.length" class="space-y-1">
      <div v-for="(item, i) in modelValue" :key="i"
        class="flex items-center gap-2 px-3 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 group">
        <span class="w-1.5 h-1.5 rounded-full bg-accent flex-shrink-0" />
        <template v-if="editing?.index === i">
          <input v-model="editing.value" @keyup.enter="saveEdit" @keyup.escape="cancelEdit"
            class="flex-1 px-2 py-0.5 rounded border border-accent bg-white dark:bg-surface-800 text-sm outline-none" autofocus />
          <button @click="saveEdit" class="text-xs text-accent hover:underline cursor-pointer">Save</button>
          <button @click="cancelEdit" class="text-xs text-surface-400 hover:underline cursor-pointer">Cancel</button>
        </template>
        <template v-else>
          <span class="flex-1 text-sm">{{ item }}</span>
          <button @click="startEdit(i)" class="text-xs text-surface-400 hover:text-accent opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">Edit</button>
          <button @click="remove(i)" class="text-xs text-red-500 hover:text-red-700 opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">Remove</button>
        </template>
      </div>
    </div>
    <div class="flex gap-2">
      <input v-model="newItem" @keydown="onKeydown" :placeholder="placeholder || 'Add item...'"
        class="flex-1 px-3 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm outline-none focus:ring-2 focus:ring-accent/50" />
      <button @click="add" type="button"
        class="px-3 py-1.5 bg-accent text-white rounded-lg text-sm hover:bg-accent-hover transition-colors cursor-pointer">
        Add
      </button>
    </div>
  </div>
</template>
