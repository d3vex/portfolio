<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import draggable from 'vuedraggable'
import { Icon } from '@iconify/vue'

export interface PickerItem {
  id: string
  label: string
  subtitle?: string
  icon?: string
  group?: string
}

const props = withDefaults(
  defineProps<{
    items: PickerItem[]
    modelValue: string[]
    title?: string
    hint?: string
    maxHeight?: string
  }>(),
  {
    title: '',
    hint: '',
    maxHeight: '320px',
  }
)

const emit = defineEmits<{ 'update:modelValue': [value: string[]] }>()

const itemMap = computed(() => {
  const map = new Map<string, PickerItem>()
  for (const item of props.items) map.set(item.id, item)
  return map
})

const dragList = ref<PickerItem[]>([])

function syncFromProps() {
  const seen = new Set<string>()
  dragList.value = props.modelValue
    .map((id) => itemMap.value.get(id))
    .filter((item): item is PickerItem => item !== undefined && !seen.has(item.id))
}

watch(() => [props.modelValue, props.items] as const, syncFromProps, { immediate: true, deep: true })

function commit() {
  emit('update:modelValue', dragList.value.map((item) => item.id))
}

function select(item: PickerItem) {
  if (dragList.value.some((existing) => existing.id === item.id)) return
  dragList.value.push(item)
  commit()
}

function removeAt(index: number) {
  dragList.value.splice(index, 1)
  commit()
}

function move(index: number, delta: -1 | 1) {
  const target = index + delta
  if (target < 0 || target >= dragList.value.length) return
  const [item] = dragList.value.splice(index, 1)
  dragList.value.splice(target, 0, item)
  commit()
}

function onDragEnd() {
  commit()
}

const availableItems = computed(() =>
  props.items.filter((item) => !dragList.value.some((selected) => selected.id === item.id))
)

const groupedAvailable = computed(() => {
  const groups = new Map<string | null, PickerItem[]>()
  for (const item of availableItems.value) {
    const key = item.group ?? null
    const bucket = groups.get(key)
    if (bucket) bucket.push(item)
    else groups.set(key, [item])
  }
  return Array.from(groups.entries()).map(([group, list]) => ({ group, list }))
})
</script>

<template>
  <div>
    <div v-if="title || hint" class="mb-2">
      <p v-if="title" class="text-sm font-medium mb-1">{{ title }}</p>
      <p v-if="hint" class="text-xs text-surface-400">{{ hint }}</p>
    </div>

    <div class="grid md:grid-cols-2 gap-4">
      <div class="rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 overflow-hidden">
        <div class="px-3 py-2 text-xs font-medium uppercase tracking-wide text-surface-400 border-b border-gray-200 dark:border-surface-700">
          Available
        </div>
        <div class="overflow-y-auto p-2 space-y-2" :style="{ maxHeight }">
          <p v-if="groupedAvailable.length === 0" class="text-xs text-surface-400 text-center py-6">
            All items selected
          </p>
          <template v-for="bucket in groupedAvailable" :key="bucket.group ?? '__ungrouped__'">
            <p v-if="bucket.group" class="px-2 pt-2 pb-1 text-[10px] font-mono uppercase tracking-wider text-surface-500">
              {{ bucket.group }}
            </p>
            <button
              v-for="item in bucket.list"
              :key="item.id"
              type="button"
              @click="select(item)"
              class="w-full flex items-center gap-2 px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 hover:border-accent/50 hover:bg-accent/5 transition-colors text-left cursor-pointer"
            >
              <Icon v-if="item.icon" :icon="item.icon" class="w-4 h-4 flex-shrink-0 text-surface-400" />
              <span class="flex-1 min-w-0">
                <span class="block text-sm font-medium truncate">{{ item.label }}</span>
                <span v-if="item.subtitle" class="block text-xs text-surface-400 truncate">{{ item.subtitle }}</span>
              </span>
              <Icon icon="mdi:plus" class="w-4 h-4 flex-shrink-0 text-surface-500" />
            </button>
          </template>
        </div>
      </div>

      <div class="rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 overflow-hidden">
        <div class="px-3 py-2 text-xs font-medium uppercase tracking-wide text-surface-400 border-b border-gray-200 dark:border-surface-700">
          Selected · order matters
        </div>
        <div class="overflow-y-auto p-2" :style="{ maxHeight }">
          <draggable
            v-if="dragList.length"
            :list="dragList"
            :item-key="'id'"
            handle=".drag-handle"
            ghost-class="opacity-40"
            class="space-y-2"
            @end="onDragEnd"
          >
            <template #item="{ element, index }">
              <div class="flex items-center gap-2 px-2 py-2 rounded-lg border border-accent/30 bg-accent/5">
                <span class="drag-handle cursor-grab active:cursor-grabbing text-surface-500 hover:text-accent">
                  <Icon icon="mdi:drag" class="w-4 h-4" />
                </span>
                <button
                  type="button"
                  @click="move(index, -1)"
                  :disabled="index === 0"
                  title="Move up"
                  class="text-surface-500 hover:text-accent disabled:opacity-30 cursor-pointer"
                >
                  <Icon icon="mdi:chevron-up" class="w-4 h-4" />
                </button>
                <button
                  type="button"
                  @click="move(index, 1)"
                  :disabled="index === dragList.length - 1"
                  title="Move down"
                  class="text-surface-500 hover:text-accent disabled:opacity-30 cursor-pointer"
                >
                  <Icon icon="mdi:chevron-down" class="w-4 h-4" />
                </button>
                <Icon v-if="element.icon" :icon="element.icon" class="w-4 h-4 flex-shrink-0 text-accent" />
                <span class="flex-1 min-w-0">
                  <span class="block text-sm font-medium truncate">{{ element.label }}</span>
                  <span v-if="element.subtitle" class="block text-xs text-surface-400 truncate">{{ element.subtitle }}</span>
                </span>
                <button
                  type="button"
                  @click="removeAt(index)"
                  title="Remove"
                  class="text-surface-500 hover:text-error cursor-pointer"
                >
                  <Icon icon="mdi:close" class="w-4 h-4" />
                </button>
              </div>
            </template>
          </draggable>
          <p v-else class="text-xs text-surface-400 text-center py-6">
            Nothing selected — click items on the left to add
          </p>
        </div>
      </div>
    </div>
  </div>
</template>
