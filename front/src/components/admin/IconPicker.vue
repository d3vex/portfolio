<script setup lang="ts">
import { ref, computed } from 'vue'

const props = defineProps<{ modelValue: string }>()
const emit = defineEmits<{ 'update:modelValue': [value: string] }>()

const search = ref('')
const showPicker = ref(false)
const prefix = ref('mdi')

const prefixes = [
  { value: 'mdi', label: 'Material Design' },
  { value: 'uil', label: 'Unicons' },
  { value: 'fa', label: 'Font Awesome' },
  { value: 'simple-icons', label: 'Simple Icons' },
  { value: 'logos', label: 'Tech Logos' },
  { value: 'icon-park-outline', label: 'Icon Park' },
  { value: 'carbon', label: 'Carbon' },
]

const iconsByPrefix: Record<string, string[]> = {
  mdi: [
    'vuejs', 'react', 'language-typescript', 'language-python',
    'nodejs', 'language-go', 'language-rust', 'docker',
    'kubernetes', 'linux', 'git', 'database',
    'school', 'account-school', 'briefcase', 'briefcase-account',
    'wan', 'server', 'cloud', 'security',
    'github', 'web', 'link', 'email',
    'phone', 'map-marker', 'calendar', 'clock',
    'star', 'heart', 'lightbulb', 'code-tags',
    'cog', 'palette', 'chart-line', 'account-group',
    'file-document', 'play-circle', 'download', 'upload',
    'delete', 'pencil', 'content-copy', 'dots-vertical',
  ],
  uil: [
    'apps', 'app-store', 'angle-up', 'angle-down',
    'arrow-up', 'arrow-down', 'arrow-left', 'arrow-right',
    'bag', 'bell', 'book-open', 'bookmark',
    'briefcase', 'buildings', 'calendar-alt', 'chart',
    'check-circle', 'clock', 'cloud', 'code-branch',
    'cog', 'comment', 'compass', 'copyright',
    'credit-card', 'desktop', 'document-info', 'envelope',
    'external-link-alt', 'eye', 'file-alt', 'file-download-alt',
    'folder', 'github', 'globe', 'graduation-cap',
    'graph', 'heart', 'home', 'image',
    'info-circle', 'key-skeleton', 'laptop', 'layer-group',
    'link', 'link-h', 'list-ul', 'lock',
    'map-marker', 'medal', 'megaphone', 'mobile-android-alt',
    'monitor', 'moon', 'music', 'note',
    'padlock', 'palette', 'paperclip', 'pen',
    'phone', 'phone-alt', 'picture', 'play',
    'plus', 'plus-circle', 'presentation-play', 'print',
    'puzzle-piece', 'question-circle', 'receipt', 'refresh',
    'repeat', 'rocket', 'rss', 'save',
    'search', 'server', 'server-network', 'settings',
    'share', 'shield', 'shopping-cart', 'sign-in-alt',
    'sign-out-alt', 'sliders-v', 'smile', 'sort',
    'star', 'stop-circle', 'store', 'subject',
    'sun', 'swatchbook', 'tablets', 'tag',
    'th-large', 'times-circle', 'trophy', 'umbrella',
    'unlock', 'user', 'user-circle', 'users-alt',
    'video', 'volume', 'wallet', 'weight',
  ],
}

const allIcons = computed(() => {
  const list = iconsByPrefix[prefix.value] || []
  return list.map(name => `${prefix.value}:${name}`)
})

const filtered = computed(() => {
  let icons = allIcons.value
  if (search.value) {
    const q = search.value.toLowerCase()
    icons = icons.filter(i => i.includes(q))
  }
  if (icons.length === 0 && search.value) {
    return [search.value]
  }
  return icons
})

function select(icon: string) {
  emit('update:modelValue', icon)
  showPicker.value = false
  search.value = ''
}
</script>

<template>
  <div class="relative">
    <div class="flex items-center gap-2">
      <div v-if="modelValue" class="w-8 h-8 rounded-lg bg-accent/10 flex items-center justify-center text-accent text-sm">
        <Icon :icon="modelValue" class="w-4 h-4" />
      </div>
      <input :value="modelValue" @input="emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        placeholder="prefix:icon-name (e.g. mdi:vuejs, uil:github)"
        class="flex-1 px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm font-mono" />
      <button @click="showPicker = !showPicker" type="button"
        class="px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors text-sm cursor-pointer">
        Browse
      </button>
    </div>
    <div v-if="showPicker"
      class="absolute top-full left-0 mt-2 w-96 bg-white dark:bg-surface-900 border border-gray-200 dark:border-surface-700 rounded-xl shadow-xl z-50 p-3">
      <div class="flex gap-1 mb-2 flex-wrap">
        <button v-for="p in prefixes" :key="p.value" @click="prefix = p.value" type="button"
          class="px-2 py-1 text-xs rounded-lg border transition-colors cursor-pointer"
          :class="prefix === p.value ? 'bg-accent text-white border-accent' : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
          {{ p.label }}
        </button>
      </div>
      <input v-model="search" placeholder="Search icons (or type any prefix:name)..."
        class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none mb-2 text-sm" />
      <div class="grid grid-cols-6 gap-1 max-h-48 overflow-y-auto">
        <button v-for="icon in filtered" :key="icon" @click="select(icon)" type="button"
          class="w-10 h-10 rounded-lg flex items-center justify-center hover:bg-accent/10 hover:text-accent transition-colors text-lg cursor-pointer"
          :class="{ 'bg-accent/20 text-accent': modelValue === icon }" :title="icon">
          <Icon :icon="icon" class="w-5 h-5" />
        </button>
      </div>
      <p class="text-[10px] text-surface-400 mt-1 text-center">Any valid Iconify icon works (fa:user, simple-icons:github, logos:vue, etc.)</p>
    </div>
  </div>
</template>
