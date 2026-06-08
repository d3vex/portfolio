<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSkills } from '@/composables/entities/useSkills'
import { useProjects } from '@/composables/entities/useProjects'
import { useEducation } from '@/composables/entities/useEducation'
import { useExperiences } from '@/composables/entities/useExperiences'
import { useLanguages } from '@/composables/entities/useLanguages'
import { usePassions } from '@/composables/entities/usePassions'
import { useContacts } from '@/composables/entities/useContacts'
import { useCategories } from '@/composables/entities/useCategories'
import * as api from '@/lib/api/cv'
import IconPicker from '@/components/admin/IconPicker.vue'
import ImageUpload from '@/components/admin/ImageUpload.vue'
import LinkEditor from '@/components/admin/LinkEditor.vue'
import ListEditor from '@/components/admin/ListEditor.vue'
import SkillPicker from '@/components/admin/SkillPicker.vue'

const route = useRoute()
const router = useRouter()

const entityKey = computed(() => route.params.entity as string)

const skillStore = useSkills()
const projectStore = useProjects()
const educationStore = useEducation()
const experienceStore = useExperiences()
const languageStore = useLanguages()
const passionStore = usePassions()
const contactStore = useContacts()
const categoryStore = useCategories()

const storeMap: Record<string, ReturnType<typeof useSkills>> = {
  skills: skillStore,
  projects: projectStore,
  education: educationStore,
  experiences: experienceStore,
  languages: languageStore,
  passions: passionStore,
  contacts: contactStore,
  categories: categoryStore,
}

const store = computed(() => storeMap[entityKey.value])
const categories = ref<any[]>([])
const allSkills = ref<any[]>([])

type FieldType = 'text' | 'textarea' | 'number' | 'month' | 'select' | 'icon' | 'image' | 'links' | 'tags' | 'timeline' | 'education-select' | 'category-single' | 'category-multi' | 'bullet-list' | 'tech-list' | 'skill-tags'

interface FieldConfig {
  key: string
  label: string
  type: FieldType
  options?: { value: string; label: string }[]
  placeholder?: string
  min?: number
  max?: number
}

interface EntityConfig {
  label: string
  plural: string
  fields: FieldConfig[]
}

const entityConfig: Record<string, EntityConfig> = {
  skills: {
    label: 'Skill', plural: 'Skills', fields: [
      { key: 'name', label: 'Name', type: 'text' },
      { key: 'icon', label: 'Icon', type: 'icon' },
      { key: 'categoryId', label: 'Category', type: 'category-single' },
      { key: 'cvCategory', label: 'CV Category', type: 'select', options: [
        { value: 'hard', label: 'Hard Skill' },
        { value: 'soft', label: 'Soft Skill' },
      ]},
      { key: 'keywords', label: 'Tags', type: 'tags' },
      { key: 'description', label: 'Description', type: 'text' },
      { key: 'level', label: 'Level (0-100)', type: 'number', min: 0, max: 100 },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  experiences: {
    label: 'Experience', plural: 'Experiences', fields: [
      { key: 'title', label: 'Title', type: 'text' },
      { key: 'company', label: 'Company', type: 'text' },
      { key: 'location', label: 'Location', type: 'text' },
      { key: 'startDate', label: 'Start Date', type: 'month' },
      { key: 'endDate', label: 'End Date', type: 'month' },
      { key: 'descriptions', label: 'Task Bullets', type: 'bullet-list' },
      { key: 'links', label: 'Links', type: 'links' },
      { key: 'imageId', label: 'Image', type: 'image' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  projects: {
    label: 'Project', plural: 'Projects', fields: [
      { key: 'title', label: 'Title', type: 'text' },
      { key: 'subtitle', label: 'Subtitle', type: 'text' },
      { key: 'description', label: 'Short Description', type: 'text' },
      { key: 'descriptions', label: 'Bullet Points', type: 'bullet-list' },
      { key: 'longDescription', label: 'Long Description', type: 'textarea' },
      { key: 'status', label: 'Status', type: 'select', options: [
        { value: 'completed', label: 'Completed' },
        { value: 'testing', label: 'Testing' },
        { value: 'in-progress', label: 'In Progress' },
        { value: 'planned', label: 'Planned' },
      ]},
      { key: 'featured', label: 'Featured', type: 'select', options: [
        { value: 'true', label: 'Yes' },
        { value: 'false', label: 'No' },
      ]},
      { key: 'technologies', label: 'Technologies', type: 'tech-list' },
      { key: 'categoryIds', label: 'Categories', type: 'category-multi' },
      { key: 'startDate', label: 'Start Date', type: 'month' },
      { key: 'endDate', label: 'End Date', type: 'month' },
      { key: 'links', label: 'Links', type: 'links' },
      { key: 'timeline', label: 'Progress Timeline', type: 'timeline' },
      { key: 'imageId', label: 'Image', type: 'image' },
      { key: 'liveUrl', label: 'Live URL', type: 'text' },
      { key: 'sourceUrl', label: 'Source URL', type: 'text' },
      { key: 'educationId', label: 'Linked Education', type: 'education-select' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  education: {
    label: 'Education', plural: 'Education', fields: [
      { key: 'title', label: 'Title', type: 'text' },
      { key: 'school', label: 'School', type: 'text' },
      { key: 'startDate', label: 'Start Date', type: 'month' },
      { key: 'endDate', label: 'End Date', type: 'month' },
      { key: 'description', label: 'Description', type: 'textarea' },
      { key: 'tags', label: 'Tags', type: 'tags' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  languages: {
    label: 'Language', plural: 'Languages', fields: [
      { key: 'name', label: 'Name', type: 'text' },
      { key: 'level', label: 'Level', type: 'text' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  passions: {
    label: 'Passion', plural: 'Passions', fields: [
      { key: 'name', label: 'Name', type: 'text' },
      { key: 'description', label: 'Description', type: 'text' },
      { key: 'icon', label: 'Icon', type: 'icon' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  contacts: {
    label: 'Contact', plural: 'Contacts', fields: [
      { key: 'label', label: 'Label', type: 'text' },
      { key: 'value', label: 'Value', type: 'text' },
      { key: 'type', label: 'Type', type: 'select', options: [
        { value: 'info', label: 'Information' },
        { value: 'link', label: 'Link' },
      ]},
      { key: 'icon', label: 'Icon', type: 'icon' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
  categories: {
    label: 'Category', plural: 'Categories', fields: [
      { key: 'name', label: 'Short Name', type: 'text' },
      { key: 'label', label: 'Display Label', type: 'text' },
      { key: 'icon', label: 'Icon', type: 'icon' },
      { key: 'description', label: 'Description', type: 'text' },
      { key: 'order', label: 'Order', type: 'number' },
    ],
  },
}

const config = computed(() => entityConfig[entityKey.value] || entityConfig.skills)

const visibleFields = computed(() =>
  config.value.fields.filter(f =>
    f.type !== 'image' && f.type !== 'links' && f.type !== 'timeline'
    && f.type !== 'bullet-list' && f.type !== 'tech-list'
    && f.key !== 'longDescription' && f.key !== 'description' && f.key !== 'descriptions'
  )
)

const rawItems = computed(() => store.value ? (store.value as any).items?.value || [] : [])


const editing = ref<any | null>(null)
const showForm = ref(false)
const form = ref<any>({})
const saving = ref(false)
const educationList = ref<any[]>([])

const newBulletText = ref('')
const newBulletSkills = ref<string[]>([])
const editingBullet = ref<{ index: number; text: string; skillIds: string[] } | null>(null)
const showBulletForm = ref(false)

const newTechName = ref('')
const newTechIcon = ref('')
const showTechForm = ref(false)
const selectedCategoryId = ref('')

function addSelectedCategory() {
  if (!selectedCategoryId.value) return
  if (!form.value.categoryIds) form.value.categoryIds = []
  if (!form.value.categoryIds.includes(selectedCategoryId.value)) {
    form.value.categoryIds.push(selectedCategoryId.value)
  }
  selectedCategoryId.value = ''
}

function addBullet() {
  if (!newBulletText.value.trim()) return
  if (!form.value.descriptions) form.value.descriptions = []
  form.value.descriptions.push({ text: newBulletText.value.trim(), skillIds: [...newBulletSkills.value] })
  newBulletText.value = ''
  newBulletSkills.value = []
  showBulletForm.value = false
}

function removeBullet(idx: number) {
  form.value.descriptions?.splice(idx, 1)
}

function startEditBullet(idx: number) {
  const b = form.value.descriptions?.[idx]
  if (!b) return
  editingBullet.value = { index: idx, text: b.text, skillIds: [...(b.skillIds || [])] }
}

function saveEditBullet() {
  if (!editingBullet.value || !editingBullet.value.text.trim()) return
  if (form.value.descriptions) {
    form.value.descriptions[editingBullet.value.index] = {
      text: editingBullet.value.text.trim(),
      skillIds: editingBullet.value.skillIds,
    }
  }
  editingBullet.value = null
}

function cancelEditBullet() {
  editingBullet.value = null
}

function addTech() {
  if (!newTechName.value.trim()) return
  if (!form.value.technologies) form.value.technologies = []
  form.value.technologies.push({ name: newTechName.value.trim(), icon: newTechIcon.value || undefined })
  newTechName.value = ''
  newTechIcon.value = ''
  showTechForm.value = false
}

function removeTech(idx: number) {
  form.value.technologies?.splice(idx, 1)
}

const editingTech = ref<{ index: number; name: string; icon: string } | null>(null)

function startEditTech(idx: number) {
  const t = form.value.technologies?.[idx]
  if (!t) return
  editingTech.value = { index: idx, name: t.name, icon: t.icon || '' }
}

function saveEditTech() {
  if (!editingTech.value || !editingTech.value.name.trim()) return
  if (form.value.technologies) {
    form.value.technologies[editingTech.value.index] = {
      name: editingTech.value.name.trim(),
      icon: editingTech.value.icon || undefined,
    }
  }
  editingTech.value = null
}

function cancelEditTech() {
  editingTech.value = null
}

function getMaxOrder(): number {
  if (!store.value) return 0
  const items = (store.value as any).items.value
  if (!items?.length) return 0
  return Math.max(...items.map((i: any) => i.order || 0))
}

function formatDateForInput(dateStr: string): string {
  if (!dateStr) return ''
  if (dateStr.includes('T')) return dateStr.slice(0, 7)
  if (dateStr.length >= 10) return dateStr.slice(0, 7)
  return dateStr
}

onMounted(async () => {
  try {
    categories.value = await api.getEntity('categories')
    allSkills.value = await api.getEntity('skills')
  } catch (_) {}
  if (entityKey.value === 'projects') {
    await educationStore.fetchAll()
    educationList.value = educationStore.items.value
  }
  if (store.value) {
    await (store.value as any).fetchAll()
  }
})

watch(entityKey, async () => {
  try {
    categories.value = await api.getEntity('categories')
    allSkills.value = await api.getEntity('skills')
  } catch (_) {}
  if (entityKey.value === 'projects') {
    await educationStore.fetchAll()
    educationList.value = educationStore.items.value
  }
  if (store.value) {
    await (store.value as any).fetchAll()
  }
})

function openNew() {
  form.value = { order: getMaxOrder() + 1 }
  editing.value = null
  showForm.value = true
}

function openEdit(item: any) {
  const f: any = {}
  for (const field of config.value.fields) {
    if (field.type === 'month' && item[field.key]) {
      f[field.key] = formatDateForInput(item[field.key])
    } else if (field.type === 'tags' && Array.isArray(item[field.key])) {
      f[field.key] = [...item[field.key]]
    } else if (field.type === 'bullet-list' && Array.isArray(item[field.key])) {
      f[field.key] = item[field.key].map((b: any) => ({ text: b.text || b, skillIds: b.skillIds || [] }))
    } else if (field.type === 'tech-list' && Array.isArray(item[field.key])) {
      f[field.key] = item[field.key].map((t: any) => ({ name: t.name || t, icon: t.icon || '' }))
    } else if (field.type === 'category-multi' && Array.isArray(item[field.key])) {
      f[field.key] = [...item[field.key]]
    } else if (field.key === 'featured') {
      f[field.key] = item[field.key] ? 'true' : 'false'
    } else {
      f[field.key] = item[field.key]
    }
  }
  form.value = f
  editing.value = item
  showForm.value = true
}

async function saveItem() {
  saving.value = true
  try {
    const data: any = {}
    for (const field of config.value.fields) {
      if (field.type === 'month' && form.value[field.key]) {
        data[field.key] = form.value[field.key]
      } else if (field.type === 'tags') {
        data[field.key] = Array.isArray(form.value[field.key]) ? form.value[field.key] : []
      } else if (field.type === 'bullet-list') {
        data[field.key] = Array.isArray(form.value[field.key]) ? form.value[field.key] : []
      } else if (field.type === 'tech-list') {
        data[field.key] = Array.isArray(form.value[field.key]) ? form.value[field.key] : []
      } else if (field.type === 'category-multi') {
        data[field.key] = Array.isArray(form.value[field.key]) ? form.value[field.key] : []
      } else if (field.key === 'featured') {
        data[field.key] = form.value[field.key] === 'true'
      } else {
        data[field.key] = form.value[field.key]
      }
    }
    if (editing.value) {
      await store.value.update(editing.value.id, data)
    } else {
      await store.value.create(data)
    }
    showForm.value = false
  } catch (e: any) {
    alert('Error: ' + e.message)
  } finally {
    saving.value = false
  }
}

async function deleteItem(id: string) {
  if (!confirm('Delete this item?')) return
  try {
    await store.value.remove(id)
  } catch (e: any) {
    alert('Error: ' + e.message)
  }
}

function addTimelineEntry() {
  if (!form.value.timeline) form.value.timeline = []
  form.value.timeline.push({ date: '', title: '', description: '', status: 'todo' })
}

function removeTimelineEntry(idx: number) {
  form.value.timeline.splice(idx, 1)
}

function toggleCategory(catId: string) {
  if (!form.value.categoryIds) form.value.categoryIds = []
  const idx = form.value.categoryIds.indexOf(catId)
  if (idx > -1) form.value.categoryIds.splice(idx, 1)
  else form.value.categoryIds.push(catId)
}
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-8">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-heading font-bold">{{ config.plural }}</h1>
        <p class="text-surface-500 mt-1">Manage your {{ config.plural.toLowerCase() }}</p>
      </div>
      <div class="flex gap-3">
        <button @click="router.push('/admin/dashboard')"
          class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
          Dashboard
        </button>
        <button @click="openNew"
          class="px-4 py-2 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer">
          New {{ config.label }}
        </button>
      </div>
    </div>

    <!-- Form Modal -->
    <div v-if="showForm" class="fixed inset-0 bg-black/50 z-[60] flex items-center justify-center p-4" @click.self="showForm = false">
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6 w-full max-w-xl max-h-[85vh] overflow-y-auto shadow-2xl">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-heading font-semibold">
            {{ editing ? 'Edit' : 'New' }} {{ config.label }}
          </h2>
          <div v-if="entityKey === 'skills' && form.icon" class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-accent/10 text-accent text-sm">
            <Icon :icon="form.icon" class="w-4 h-4" />
            <span class="font-medium">{{ form.name || 'Skill Preview' }}</span>
            <span v-if="form.level" class="text-xs opacity-75">{{ form.level }}%</span>
          </div>
        </div>
        <div class="grid grid-cols-2 gap-x-4 gap-y-3">
          <div v-for="field in config.fields" :key="field.key" class="space-y-1"
            :class="field.type === 'bullet-list' || field.type === 'tech-list' || field.type === 'textarea' || field.type === 'timeline' || field.type === 'tags' || field.type === 'image' || field.type === 'links' || field.type === 'icon' || field.type === 'education-select' || field.type === 'category-multi' || field.type === 'category-single' ? 'col-span-2' : 'col-span-1'">
            <label class="block text-sm font-medium text-surface-700 dark:text-surface-300">{{ field.label }}</label>

            <input v-if="field.type === 'text'" v-model="form[field.key]" :placeholder="field.placeholder"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm" />

            <textarea v-else-if="field.type === 'textarea'" v-model="form[field.key]" rows="3" :placeholder="field.placeholder"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm resize-none"></textarea>

            <input v-else-if="field.type === 'number'" v-model.number="form[field.key]" type="number"
              :min="field.min" :max="field.max"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm" />

            <input v-else-if="field.type === 'month'" v-model="form[field.key]" type="month"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm" />

            <select v-else-if="field.type === 'select'" v-model="form[field.key]"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm"
              :class="{ 'text-surface-400': !form[field.key] }">
              <option value="" disabled>Select...</option>
              <option v-for="opt in field.options" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
            </select>

            <IconPicker v-else-if="field.type === 'icon'" :modelValue="form[field.key] || ''"
              @update:modelValue="form[field.key] = $event" />

            <ImageUpload v-else-if="field.type === 'image'" :modelValue="form.imageUrl || ''" :imageId="form.imageId"
              @update:modelValue="form.imageUrl = $event" @update:imageId="form.imageId = $event" />

            <LinkEditor v-else-if="field.type === 'links'" :modelValue="form[field.key] || []"
              @update:modelValue="form[field.key] = $event" />

            <ListEditor v-else-if="field.type === 'tags'" :modelValue="form[field.key] || []"
              @update:modelValue="form[field.key] = $event" :placeholder="'Add ' + field.label.toLowerCase() + '...'" />

            <!-- Category Single Select -->
            <select v-else-if="field.type === 'category-single'" v-model="form.categoryId"
              class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm">
              <option value="">No category</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.label }}</option>
            </select>

            <!-- Category Multi Select -->
            <div v-else-if="field.type === 'category-multi'" class="space-y-1">
              <div class="flex flex-wrap gap-1.5">
                <span v-for="cid in (form.categoryIds || [])" :key="cid"
                  class="inline-flex items-center gap-1 px-2 py-0.5 text-xs rounded bg-accent/10 text-accent font-mono">
                  <Icon v-if="categories.find(c => c.id === cid)?.icon" :icon="categories.find(c => c.id === cid).icon" class="w-3 h-3" />
                  {{ categories.find(c => c.id === cid)?.label || cid }}
                  <button type="button" @click="toggleCategory(cid)" class="hover:text-red-500 cursor-pointer">&times;</button>
                </span>
              </div>
              <select v-model="selectedCategoryId" @change="addSelectedCategory"
                class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm">
                <option value="">Add category...</option>
                <option v-for="cat in categories" :key="cat.id" :value="cat.id" :disabled="(form.categoryIds || []).includes(cat.id)">{{ cat.label }}</option>
              </select>
            </div>

            <!-- Bullet List (LinkEditor pattern) -->
            <div v-else-if="field.type === 'bullet-list'" class="space-y-2">
              <div v-for="(b, i) in form.descriptions" :key="i"
                class="flex items-center justify-between px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800">
                <template v-if="editingBullet?.index === i">
                  <div class="flex-1 space-y-2">
                    <textarea v-model="editingBullet.text" rows="2" placeholder="Bullet text..."
                      class="w-full px-3 py-1.5 rounded border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm outline-none resize-none" />
                    <div>
                      <p class="text-xs text-surface-400 mb-1.5 font-medium">Linked Soft Skills</p>
                      <SkillPicker :modelValue="editingBullet.skillIds" :skills="allSkills.filter(s => s.cvCategory === 'soft')" label="soft skills"
                        @update:modelValue="editingBullet.skillIds = $event" />
                    </div>
                    <div class="flex gap-2">
                      <button @click="saveEditBullet" class="px-3 py-1 text-xs bg-accent text-white rounded-lg hover:bg-accent-hover transition-colors cursor-pointer">Save</button>
                      <button @click="cancelEditBullet" class="px-3 py-1 text-xs border border-gray-200 dark:border-surface-700 rounded-lg text-surface-400 hover:text-accent transition-colors cursor-pointer">Cancel</button>
                    </div>
                  </div>
                </template>
                <template v-else>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm leading-relaxed text-surface-700 dark:text-surface-300">{{ b.text }}</p>
                    <div v-if="b.skillIds?.length" class="flex flex-wrap gap-1 mt-1">
                      <span v-for="sid in b.skillIds" :key="sid"
                        class="px-1.5 py-0.5 text-[10px] rounded bg-accent/10 text-accent font-mono">
                        {{ allSkills.find(s => s.id === sid)?.name || '?' }}
                      </span>
                    </div>
                  </div>
                  <div class="flex items-center gap-1 ml-2 flex-shrink-0">
                    <button @click="startEditBullet(i)" class="text-xs text-surface-400 hover:text-accent transition-colors cursor-pointer">Edit</button>
                    <button @click="removeBullet(i)" type="button" class="text-xs text-red-500 hover:text-red-700 transition-colors cursor-pointer">Remove</button>
                  </div>
                </template>
              </div>
              <button v-if="!showBulletForm" @click="showBulletForm = true" type="button"
                class="w-full py-2 rounded-lg border-2 border-dashed border-gray-300 dark:border-surface-600 text-sm text-surface-400 hover:border-accent/50 hover:text-accent transition-colors cursor-pointer">
                + Add Bullet Point
              </button>
              <div v-else class="p-3 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800/50 space-y-2">
                <textarea v-model="newBulletText" rows="2" placeholder="New bullet point..."
                  class="w-full px-3 py-1.5 rounded border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm outline-none resize-none" />
                <div>
                  <p class="text-xs text-surface-400 mb-1.5 font-medium">Linked Soft Skills</p>
                  <SkillPicker :modelValue="newBulletSkills" :skills="allSkills.filter(s => s.cvCategory === 'soft')" label="soft skills"
                    @update:modelValue="newBulletSkills = $event" />
                </div>
                <div class="flex gap-2 pt-1">
                  <button @click="addBullet" type="button"
                    class="px-3 py-1 text-xs bg-accent text-white rounded-lg hover:bg-accent-hover transition-colors cursor-pointer">Add</button>
                  <button @click="showBulletForm = false; newBulletText = ''; newBulletSkills = []" type="button"
                    class="px-3 py-1 text-xs border border-gray-200 dark:border-surface-700 rounded-lg text-surface-400 hover:text-accent transition-colors cursor-pointer">Cancel</button>
                </div>
              </div>
            </div>

            <!-- Tech List with Icons (LinkEditor pattern) -->
            <div v-else-if="field.type === 'tech-list'" class="space-y-2">
              <div v-for="(t, i) in form.technologies" :key="i"
                class="flex items-center justify-between px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800">
                <div class="flex items-center gap-2 text-sm">
                  <Icon v-if="t.icon" :icon="t.icon" class="w-4 h-4 text-accent" />
                  <span class="font-medium">{{ t.name }}</span>
                </div>
                <button @click="removeTech(i)" type="button" class="text-red-500 hover:text-red-700 text-xs cursor-pointer">Remove</button>
              </div>
              <button v-if="!showTechForm" @click="showTechForm = true" type="button"
                class="w-full py-2 rounded-lg border-2 border-dashed border-gray-300 dark:border-surface-600 text-sm text-surface-400 hover:border-accent/50 hover:text-accent transition-colors cursor-pointer">
                + Add Technology
              </button>
              <div v-else class="p-3 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800/50 space-y-2">
                <input v-model="newTechName" placeholder="Technology name"
                  class="w-full px-3 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm outline-none" />
                <div>
                  <p class="text-[10px] text-surface-400 mb-1">Optional icon:</p>
                  <IconPicker :modelValue="newTechIcon" @update:modelValue="newTechIcon = $event" />
                </div>
                <div class="flex gap-2">
                  <button @click="addTech" type="button"
                    class="px-3 py-1.5 bg-accent text-white rounded-lg text-sm hover:bg-accent-hover transition-colors cursor-pointer">Add</button>
                  <button @click="showTechForm = false; newTechName = ''; newTechIcon = ''" type="button"
                    class="px-3 py-1.5 border border-gray-200 dark:border-surface-700 rounded-lg text-sm text-surface-400 hover:text-accent transition-colors cursor-pointer">Cancel</button>
                </div>
              </div>
            </div>

            <div v-else-if="field.type === 'education-select'">
              <select v-model="form.educationId"
                class="w-full px-3 py-2 rounded-lg border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 outline-none focus:ring-2 focus:ring-accent/50 text-sm">
                <option value="">None</option>
                <option v-for="edu in educationList" :key="edu.id" :value="edu.id">
                  {{ edu.title }} {{ edu.school ? '- ' + edu.school : '' }}
                </option>
              </select>
            </div>

            <div v-else-if="field.type === 'timeline'" class="space-y-2">
              <div v-for="(entry, i) in form.timeline" :key="i" class="p-3 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800/50 space-y-2">
                <div class="flex gap-2">
                  <input v-model="entry.date" type="month" placeholder="Date" class="flex-1 px-2 py-1 rounded border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-xs outline-none" />
                  <input v-model="entry.title" placeholder="Title" class="flex-1 px-2 py-1 rounded border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-xs outline-none" />
                  <select v-model="entry.status" class="px-2 py-1 rounded border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-xs outline-none">
                    <option value="todo">Todo</option>
                    <option value="in-progress">In Progress</option>
                    <option value="testing">Testing</option>
                    <option value="done">Done</option>
                  </select>
                  <button @click="removeTimelineEntry(i)" type="button" class="text-red-500 text-xs px-2 cursor-pointer">&times;</button>
                </div>
                <input v-model="entry.description" placeholder="Description" class="w-full px-2 py-1 rounded border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-xs outline-none" />
              </div>
              <button @click="addTimelineEntry" type="button"
                class="w-full py-1.5 rounded-lg border-2 border-dashed border-gray-300 dark:border-surface-600 text-xs text-surface-400 hover:border-accent/50 hover:text-accent transition-colors cursor-pointer">
                + Add Timeline Entry
              </button>
            </div>
          </div>
        </div>

        <!-- Preview -->
        <div v-if="editing || form.name || form.title" class="mt-6 pt-4 border-t border-gray-200 dark:border-surface-700">
          <p class="text-xs font-mono uppercase tracking-wider text-surface-400 mb-2">Preview</p>
          <div class="p-4 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800">
            <div v-if="entityKey === 'skills'" class="flex items-center gap-3">
              <div v-if="form.icon" class="w-10 h-10 rounded-xl bg-accent/10 flex items-center justify-center text-accent">
                <Icon :icon="form.icon" class="w-5 h-5" />
              </div>
              <div>
                <p class="font-medium text-sm">{{ form.name || 'Skill Name' }}</p>
                <div v-if="form.level" class="mt-1 w-32 h-1.5 rounded-full bg-gray-200 dark:bg-surface-700">
                  <div class="h-full rounded-full bg-accent" :style="{ width: Math.min(form.level, 100) + '%' }" />
                </div>
                <div v-if="form.keywords?.length" class="flex gap-1 mt-1 flex-wrap">
                  <span v-for="kw in form.keywords" :key="kw" class="px-1 py-0.5 text-[9px] rounded bg-surface-100 dark:bg-surface-700 text-surface-500 font-mono">{{ kw }}</span>
                </div>
              </div>
            </div>
            <div v-else-if="entityKey === 'projects' || entityKey === 'experiences'" class="space-y-1">
              <p class="font-medium text-sm">{{ form.title || 'Title' }}</p>
              <p v-if="form.subtitle" class="text-xs text-surface-500">{{ form.subtitle }}</p>
              <p v-if="form.description" class="text-xs text-surface-400 mt-1">{{ form.description }}</p>
              <ul v-if="form.descriptions?.length" class="mt-1 space-y-0.5">
                <li v-for="b in form.descriptions" :key="b.text" class="text-[11px] text-surface-500 flex items-start gap-1">
                  <span class="text-accent mt-0.5">&bull;</span>
                  <span>{{ b.text }}</span>
                </li>
              </ul>
              <div v-if="form.technologies?.length" class="flex gap-1 mt-1 flex-wrap">
                <span v-for="t in form.technologies" :key="t.name"
                  class="px-1.5 py-0.5 text-[10px] rounded font-mono bg-surface-100 dark:bg-surface-700 text-surface-500 flex items-center gap-1">
                  <Icon v-if="t.icon" :icon="t.icon" class="w-3 h-3" />
                  {{ t.name }}
                </span>
              </div>
              <div v-if="form.categoryIds?.length" class="flex gap-1 mt-1 flex-wrap">
                <span v-for="cid in form.categoryIds" :key="cid"
                  class="px-1.5 py-0.5 text-[10px] rounded bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 font-mono flex items-center gap-1">
                  <Icon v-if="(categories.find(c => c.id === cid)?.icon)" :icon="categories.find(c => c.id === cid).icon" class="w-3 h-3" />
                  {{ categories.find(c => c.id === cid)?.label || cid }}
                </span>
              </div>
              <div v-if="form.status" class="mt-1">
                <span class="text-[10px] px-1.5 py-0.5 rounded font-mono"
                  :class="{
                    'bg-green-100 text-green-700': form.status === 'completed',
                    'bg-yellow-100 text-yellow-700': form.status === 'in-progress',
                    'bg-blue-100 text-blue-700': form.status === 'testing',
                    'bg-gray-100 text-gray-600': form.status === 'planned' || !form.status,
                  }">{{ form.status }}</span>
              </div>
            </div>
            <div v-else-if="entityKey === 'education'" class="space-y-1">
              <p class="font-medium text-sm">{{ form.title || 'Title' }}</p>
              <p v-if="form.school" class="text-xs text-surface-500">{{ form.school }}</p>
              <p v-if="form.description" class="text-xs text-surface-400 mt-1">{{ form.description }}</p>
            </div>
            <div v-else-if="(entityKey === 'languages' || entityKey === 'passions') && form.name" class="flex items-center gap-2">
              <div v-if="form.icon" class="w-8 h-8 rounded-lg bg-accent/10 flex items-center justify-center text-accent">
                <Icon :icon="form.icon" class="w-4 h-4" />
              </div>
              <div>
                <p class="font-medium text-sm">{{ form.name }}</p>
                <p v-if="form.level" class="text-xs text-surface-400">{{ form.level }}</p>
              </div>
            </div>
            <div v-else-if="entityKey === 'contacts' && form.label" class="flex items-center gap-2">
              <div v-if="form.icon" class="w-8 h-8 rounded-lg bg-accent/10 flex items-center justify-center text-accent">
                <Icon :icon="form.icon" class="w-4 h-4" />
              </div>
              <div>
                <p class="font-medium text-sm">{{ form.label }}</p>
                <p class="text-xs text-surface-400">{{ form.value }}</p>
              </div>
            </div>
            <div v-else-if="entityKey === 'categories' && form.label" class="flex items-center gap-2">
              <div v-if="form.icon" class="w-8 h-8 rounded-lg bg-accent/10 flex items-center justify-center text-accent">
                <Icon :icon="form.icon" class="w-4 h-4" />
              </div>
              <div>
                <p class="font-medium text-sm">{{ form.label }}</p>
                <p class="text-xs text-surface-400">{{ form.name }}</p>
              </div>
            </div>
            <p v-else class="text-xs text-surface-400 italic">Fill in fields to see preview</p>
          </div>
        </div>

        <div class="flex justify-end gap-3 mt-6">
          <button @click="showForm = false"
            class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-lg hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer text-sm">
            Cancel
          </button>
          <button @click="saveItem" :disabled="saving"
            class="px-4 py-2 bg-accent text-white rounded-lg hover:bg-accent-hover transition-colors cursor-pointer text-sm disabled:opacity-50">
            {{ saving ? 'Saving...' : 'Save' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Entity List: Cards for projects, table for others -->
    <template v-if="entityKey === 'projects'">
      <div v-if="(store ? (store as any).items?.value?.length : false)" class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div v-for="(item, i) in (store ? (store as any).items?.value : [])" :key="item.id"
          class="relative p-6 rounded-xl border overflow-hidden cursor-pointer"
          :style="{ animationDelay: `${i * 0.08}s` }"
          :class="[item.id === editing?.id ? 'ring-2 ring-accent' : '']"
          style="background-color: var(--color-surface); border-color: var(--color-border); animation: card-enter 0.45s ease both;"
          @click="openEdit(item)">
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-1.5">
              <div class="w-2 h-2 rounded-full"
                :class="{
                  'bg-green-500': item.status === 'completed',
                  'bg-blue-500': item.status === 'testing',
                  'bg-amber-500': item.status === 'in-progress',
                  'bg-zinc-500': !item.status || item.status === 'planned',
                }" />
              <span class="text-xs font-mono">{{ item.status || 'planned' }}</span>
            </div>
            <span class="text-xs font-mono px-2 py-0.5 rounded" style="background-color: var(--color-bg); color: var(--color-text-secondary);">
              {{ categories.find(c => item.categoryIds?.includes(c.id))?.label || item.categoryIds?.[0] || 'General' }}
            </span>
          </div>
          <h3 class="text-xl font-heading font-bold mb-2 relative z-[1]" style="color: var(--color-text);">{{ item.title }}</h3>
          <p v-if="item.description" class="text-sm mb-4 line-clamp-2 relative z-[1]" style="color: var(--color-text-secondary);">{{ item.description }}</p>
          <div v-if="item.technologies?.length" class="flex flex-wrap gap-1.5 mb-4 relative z-[1]">
            <span v-for="t in item.technologies.slice(0, 4)" :key="t.name || t"
              class="px-2 py-0.5 rounded text-xs font-mono" style="background-color: var(--color-accent); color: white; opacity: 0.8;">
              {{ t.name || t }}
            </span>
            <span v-if="item.technologies.length > 4" class="px-2 py-0.5 rounded text-xs font-mono" style="background-color: var(--color-accent); color: white; opacity: 0.8;">
              +{{ item.technologies.length - 4 }}
            </span>
          </div>
          <div class="flex justify-end gap-3 relative z-[1]">
            <button @click.stop="openEdit(item)"
              class="text-sm font-medium" style="color: var(--color-accent);">Edit</button>
            <button @click.stop="deleteItem(item.id)"
              class="text-sm font-medium text-red-500">Delete</button>
          </div>
          <div class="absolute inset-0 pointer-events-none rounded-xl transition-opacity duration-300 opacity-0 hover:opacity-100"
            style="background: radial-gradient(600px circle at 50% 50%, rgba(37, 99, 235, 0.07), transparent 50%);" />
        </div>
      </div>
      <div v-else class="text-center py-8 text-surface-500">
        No {{ config.plural.toLowerCase() }} yet. Create your first one.
      </div>
    </template>
    <template v-else>
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 overflow-hidden">
        <table class="w-full">
          <thead>
            <tr class="border-b border-gray-200 dark:border-surface-700">
              <th v-for="field in config.fields.filter(f => f.type !== 'image' && f.type !== 'links' && f.type !== 'timeline' && f.type !== 'bullet-list' && f.type !== 'tech-list' && f.key !== 'longDescription' && f.key !== 'description' && f.key !== 'descriptions')" :key="field.key"
                class="text-left px-4 py-3 text-sm font-medium text-surface-500">
                {{ field.label }}
              </th>
              <th class="px-4 py-3 text-right text-sm font-medium text-surface-500">Actions</th>
            </tr>
          </thead>
          <tbody v-if="entityKey !== 'skills'">
            <tr v-for="item in rawItems" :key="item.id"
              class="border-b border-gray-100 dark:border-surface-800 hover:bg-gray-50 dark:hover:bg-surface-800/50 transition-colors">
              <td v-for="field in visibleFields" :key="field.key" class="px-4 py-3 text-sm">
                <div v-if="field.type === 'icon' && item[field.key]" class="flex items-center gap-2">
                  <Icon :icon="item[field.key]" class="w-4 h-4 text-accent" />
                  <span class="text-xs font-mono text-surface-400">{{ item[field.key] }}</span>
                </div>
                <div v-else-if="field.type === 'tags' && Array.isArray(item[field.key])" class="flex gap-1 flex-wrap">
                  <span v-for="t in item[field.key].slice(0, 3)" :key="t" class="px-1.5 py-0.5 text-[10px] rounded bg-accent/10 text-accent font-mono">{{ t }}</span>
                  <span v-if="item[field.key].length > 3" class="text-[10px] text-surface-400">+{{ item[field.key].length - 3 }}</span>
                </div>
                <div v-else-if="field.type === 'category-single'" class="flex items-center gap-1">
                  <span v-if="item.categoryId">
                    <Icon v-if="categories.find(c => c.id === item.categoryId)?.icon" :icon="categories.find(c => c.id === item.categoryId).icon" class="w-3.5 h-3.5 inline text-accent mr-1" />
                    {{ categories.find(c => c.id === item.categoryId)?.label || item.categoryId }}
                  </span>
                  <span v-else class="text-surface-400">-</span>
                </div>
                <div v-else-if="field.type === 'category-multi' && Array.isArray(item[field.key])" class="flex gap-1 flex-wrap">
                  <span v-for="cid in item[field.key].slice(0, 3)" :key="cid" class="px-1.5 py-0.5 text-[10px] rounded bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 font-mono">
                    {{ categories.find(c => c.id === cid)?.label || cid }}
                  </span>
                  <span v-if="item[field.key].length > 3" class="text-[10px] text-surface-400">+{{ item[field.key].length - 3 }}</span>
                </div>
                <span v-else>{{ item[field.key] }}</span>
              </td>
              <td class="px-4 py-3 text-right whitespace-nowrap">
                <button @click="openEdit(item)"
                  class="text-accent hover:underline text-sm mr-3 cursor-pointer">Edit</button>
                <button @click="deleteItem(item.id)"
                  class="text-red-500 hover:underline text-sm cursor-pointer">Delete</button>
              </td>
            </tr>
          </tbody>
          <template v-for="group in ['hard', 'soft']" :key="group">
            <tbody v-if="entityKey === 'skills'" v-show="rawItems.filter((s: any) => s.cvCategory === group).length">
              <tr class="bg-surface-50 dark:bg-surface-800/30">
                <td :colspan="visibleFields.length + 1" class="px-4 py-2 text-xs font-semibold uppercase tracking-wider text-surface-500">
                  {{ group === 'hard' ? 'Hard Skills' : 'Soft Skills' }}
                </td>
              </tr>
              <tr v-for="item in rawItems.filter((s: any) => s.cvCategory === group)" :key="item.id"
                class="border-b border-gray-100 dark:border-surface-800 hover:bg-gray-50 dark:hover:bg-surface-800/50 transition-colors">
                <td v-for="field in visibleFields" :key="field.key" class="px-4 py-3 text-sm">
                  <div v-if="field.type === 'icon' && item[field.key]" class="flex items-center gap-2">
                    <Icon :icon="item[field.key]" class="w-4 h-4 text-accent" />
                    <span class="text-xs font-mono text-surface-400">{{ item[field.key] }}</span>
                  </div>
                  <div v-else-if="field.type === 'tags' && Array.isArray(item[field.key])" class="flex gap-1 flex-wrap">
                    <span v-for="t in item[field.key].slice(0, 3)" :key="t" class="px-1.5 py-0.5 text-[10px] rounded bg-accent/10 text-accent font-mono">{{ t }}</span>
                    <span v-if="item[field.key].length > 3" class="text-[10px] text-surface-400">+{{ item[field.key].length - 3 }}</span>
                  </div>
                  <div v-else-if="field.type === 'category-single'" class="flex items-center gap-1">
                    <span v-if="item.categoryId">
                      <Icon v-if="categories.find(c => c.id === item.categoryId)?.icon" :icon="categories.find(c => c.id === item.categoryId).icon" class="w-3.5 h-3.5 inline text-accent mr-1" />
                      {{ categories.find(c => c.id === item.categoryId)?.label || item.categoryId }}
                    </span>
                    <span v-else class="text-surface-400">-</span>
                  </div>
                  <div v-else-if="field.type === 'category-multi' && Array.isArray(item[field.key])" class="flex gap-1 flex-wrap">
                    <span v-for="cid in item[field.key].slice(0, 3)" :key="cid" class="px-1.5 py-0.5 text-[10px] rounded bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 font-mono">
                      {{ categories.find(c => c.id === cid)?.label || cid }}
                    </span>
                    <span v-if="item[field.key].length > 3" class="text-[10px] text-surface-400">+{{ item[field.key].length - 3 }}</span>
                  </div>
                  <span v-else>{{ item[field.key] }}</span>
                </td>
                <td class="px-4 py-3 text-right whitespace-nowrap">
                  <button @click="openEdit(item)"
                    class="text-accent hover:underline text-sm mr-3 cursor-pointer">Edit</button>
                  <button @click="deleteItem(item.id)"
                    class="text-red-500 hover:underline text-sm cursor-pointer">Delete</button>
                </td>
              </tr>
            </tbody>
          </template>
          <div v-if="!rawItems.length" class="text-center py-8 text-surface-500">
            No {{ config.plural.toLowerCase() }} yet. Create your first one.
          </div>
        </table>
      </div>
    </template>
  </div>
</template>

<style scoped>
@keyframes card-enter {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
