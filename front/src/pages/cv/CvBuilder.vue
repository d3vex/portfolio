<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import * as api from '@/lib/api/cv'
import ImageGallery from '@/components/admin/ImageGallery.vue'
import OrderedPicker from '@/components/cv/OrderedPicker.vue'
import StylePicker from '@/components/cv/StylePicker.vue'

const router = useRouter()
const route = useRoute()
const isEdit = !!route.params.id
const saving = ref(false)
const saveError = ref('')

const form = ref({
  name: '',
  candidateName: '',
  specialization: '',
  titleOverride: '',
  aboutText: '',
  availability: '',
  pictureId: '',
  skillIds: [] as string[],
  languageIds: [] as string[],
  passionIds: [] as string[],
  experienceIds: [] as string[],
  projectIds: [] as string[],
  educationIds: [] as string[],
  contactIds: [] as string[],
  projectBullets: {} as Record<string, number[]>,
  style: 'classic',
})

const skills = ref<any[]>([])
const languages = ref<any[]>([])
const passions = ref<any[]>([])
const experiences = ref<any[]>([])
const projects = ref<any[]>([])
const education = ref<any[]>([])
const contacts = ref<any[]>([])
const showImageGallery = ref(false)

const step = ref(1)
const stepCardRef = ref<HTMLElement | null>(null)

function canGoBack(i: number): boolean {
  return i + 1 < step.value
}

function goToStep(i: number) {
  if (canGoBack(i)) step.value = i + 1
}

watch(step, () => { stepCardRef.value?.scrollTo({ top: 0 }) })

onBeforeUnmount(() => {
  document.body.style.overflow = ''
})

onMounted(async () => {
  document.body.style.overflow = 'hidden'
  try {
    const [s, l, p, e, pr, ed, co] = await Promise.all([
      api.getSkills(), api.getLanguages(), api.getPassions(),
      api.getExperiences(), api.getProjects(), api.getEducation(),
      api.getContacts(),
    ])
    skills.value = s
    languages.value = l
    passions.value = p
    experiences.value = e
    projects.value = pr
    education.value = ed
    contacts.value = co
  } catch (err) {
    console.error('Failed to load data', err)
  }

  if (isEdit) {
    const cv = await api.getCv(route.params.id as string)
    form.value = {
      name: cv.name,
      candidateName: cv.candidateName || '',
      specialization: cv.specialization || '',
      titleOverride: cv.titleOverride || '',
      aboutText: cv.aboutText || '',
      availability: cv.availability || '',
      pictureId: cv.pictureId || '',
      skillIds: cv.skills?.map((s: any) => s.id) || [],
      languageIds: cv.languages?.map((l: any) => l.id) || [],
      passionIds: cv.passions?.map((p: any) => p.id) || [],
      experienceIds: cv.experiences?.map((e: any) => e.id) || [],
      projectIds: cv.projects?.map((p: any) => p.id) || [],
      educationIds: cv.education?.map((e: any) => e.id) || [],
      contactIds: cv.contacts?.map((c: any) => c.id) || [],
      projectBullets: cv.projectBullets || {},
      style: cv.style || 'classic',
    }
  }
})

function toggle(arr: string[], id: string) {
  const idx = arr.indexOf(id)
  if (idx > -1) {
    arr.splice(idx, 1)
  } else {
    arr.push(id)
  }
}

// When projects are added via OrderedPicker (which mutates form.projectIds),
// auto-select all their bullets by default, and clean up removed projects.
watch(
  () => form.value.projectIds,
  (next, prev) => {
    const prevSet = new Set(prev ?? [])
    const nextSet = new Set(next ?? [])
    for (const id of next ?? []) {
      if (prevSet.has(id)) continue
      if (form.value.projectBullets[id] !== undefined) continue
      const proj = projects.value.find((p: any) => p.id === id)
      if (proj?.projectPoints?.length) {
        form.value.projectBullets[id] = proj.projectPoints.map((_: any, i: number) => i)
      }
    }
    for (const key of Object.keys(form.value.projectBullets)) {
      if (!nextSet.has(key)) delete form.value.projectBullets[key]
    }
  }
)

function toggleBullet(projectId: string, idx: number) {
  const bullets = form.value.projectBullets[projectId]
  if (!bullets) return
  const pos = bullets.indexOf(idx)
  if (pos > -1) bullets.splice(pos, 1)
  else bullets.push(idx)
}

function previewProjBullets(proj: any): any[] {
  const map = form.value.projectBullets
  if (!map) return proj.projectPoints || []
  const sel = map[proj.id]
  if (sel === undefined) return proj.projectPoints || []
  return (proj.projectPoints || []).filter((_: any, i: number) => sel.includes(i))
}

function pointSkillNames(point: any): string[] {
  const skillLinks = point?.skillLinks || point?.skills || []
  return skillLinks
    .map((l: any) => l.skill?.name ?? l.name)
    .filter((n: string) => !!n)
}

function bulletsToPointIds(): string[] {
  const ids: string[] = []
  for (const [projectId, indices] of Object.entries(form.value.projectBullets || {})) {
    const proj = projects.value.find((p: any) => p.id === projectId)
    const points = ((proj?.projectPoints || []) as any[]).sort((a: any, b: any) => a.order - b.order)
    for (const i of indices || []) {
      const point = points[Number(i)]
      if (point?.id) ids.push(point.id)
    }
  }
  return ids
}

async function save() {
  saving.value = true
  saveError.value = ''
  try {
    const { projectBullets, ...rest } = form.value
    const payload = {
      ...rest,
      cvProjectPointIds: bulletsToPointIds(),
    }
    if (isEdit) {
      await api.updateCv(route.params.id as string, payload)
    } else {
      await api.createCv(payload)
    }
    router.push('/admin/cvs')
  } catch (e: any) {
    saveError.value = 'Error: ' + e.message
  } finally {
    saving.value = false
  }
}

const linkedPreview = computed(() => {
  const ordered = (ids: string[] | undefined, map: Map<string, any>) =>
    (ids ?? []).map(id => map.get(id)).filter((x): x is any => x !== undefined)
  return {
    skills: ordered(form.value.skillIds, skillMap.value),
    languages: ordered(form.value.languageIds, languageMap.value),
    passions: ordered(form.value.passionIds, passionMap.value),
    experiences: ordered(form.value.experienceIds, experienceMap.value),
    projects: ordered(form.value.projectIds, projectMap.value),
    education: ordered(form.value.educationIds, educationMap.value),
    contacts: ordered(form.value.contactIds, contactMap.value),
    pictureId: form.value.pictureId,
    availability: form.value.availability,
  }
})

function byId(arr: any[]): Map<string, any> {
  return new Map(arr.map((x: any) => [x.id, x]))
}
const skillMap = computed(() => byId(skills.value))
const languageMap = computed(() => byId(languages.value))
const passionMap = computed(() => byId(passions.value))
const experienceMap = computed(() => byId(experiences.value))
const projectMap = computed(() => byId(projects.value))
const educationMap = computed(() => byId(education.value))
const contactMap = computed(() => byId(contacts.value))

const skillPickerItems = computed(() =>
  skills.value.map((s: any) => ({
    id: s.id,
    label: s.name,
    subtitle: s.level != null ? `${s.level}%` : s.cvCategory,
    icon: s.icon,
    group: s.cvCategory,
  }))
)
const passionPickerItems = computed(() =>
  passions.value.map((p: any) => ({ id: p.id, label: p.name, icon: p.icon }))
)
const projectPickerItems = computed(() =>
  projects.value.map((pr: any) => ({
    id: pr.id,
    label: pr.title,
    subtitle: pr.subtitle,
    icon: pr.icon,
  }))
)

const displayName = computed(() => form.value.candidateName || form.value.name)

function nameInitials(): string {
  return displayName.value ? displayName.value.split(/\s+/).map((s: string) => s[0]).join('').slice(0, 2).toUpperCase() : 'LM'
}

function formatAbout(text: string): string {
  if (!text) return ''
  let html = text.replace(/\n/g, '<br>')
  html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
  return html
}

function formatDate(d: string | null | undefined): string {
  if (!d) return ''
  try {
    return new Intl.DateTimeFormat('fr-FR', { month: 'short', year: 'numeric' }).format(new Date(d))
  } catch {
    return d
  }
}

const steps = ['Info', 'Skills', 'Languages & Passions', 'Experience & Projects', 'Education', 'Contacts', 'Preview']
</script>

<template>
  <!-- h-[calc(100vh-80px)] compensates AppLayout main's pt-20 top padding (the admin pt-0 class loses to scoped CSS specificity) -->
  <div class="max-w-4xl mx-auto px-4 pt-6 h-[calc(100vh-80px)] flex flex-col gap-6 overflow-hidden">
    <div class="flex-none flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-heading font-bold">{{ isEdit ? 'Edit CV' : 'Create CV' }}</h1>
        <p class="text-surface-500 mt-1">Build your CV from existing data</p>
      </div>
      <button @click="router.push('/admin/cvs')"
        class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
        Back
      </button>
    </div>

    <div class="flex-none">
      <p class="text-xs text-surface-500 mb-2">Step {{ step }} / {{ steps.length }} — {{ steps[step - 1] }}</p>
      <div class="flex gap-2">
        <div v-for="(s, i) in steps" :key="i"
          class="flex-1 h-2 rounded-full transition-colors"
          :class="i + 1 === step
            ? 'bg-accent ring-2 ring-accent/25 cursor-default'
            : (canGoBack(i) ? 'bg-accent/60 cursor-pointer' : 'bg-gray-200 dark:bg-surface-700 cursor-default')"
          :title="s"
          :role="canGoBack(i) ? 'button' : undefined"
          :tabindex="canGoBack(i) ? 0 : -1"
          :aria-label="canGoBack(i) ? 'Go back to step ' + (i + 1) + ': ' + s : s"
          @click="goToStep(i)"
          @keydown.enter="goToStep(i)"
          @keydown.space.prevent="goToStep(i)">
        </div>
      </div>
    </div>

    <div ref="stepCardRef" class="flex-1 min-h-0 overflow-y-auto bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6">
      <Transition name="step" mode="out-in">
        <div :key="step">
      <!-- Step 1: Basic Info -->
      <div v-if="step === 1" class="space-y-4">
        <div>
          <label class="block text-sm font-medium mb-1">CV Name *</label>
          <input v-model="form.name" placeholder="e.g. Web Developer CV"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
          <p class="text-xs text-surface-400 mt-1">Used to identify this CV in the list</p>
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Candidate Name</label>
          <input v-model="form.candidateName" placeholder="e.g. John Doe"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
          <p class="text-xs text-surface-400 mt-1">Leave empty to use the CV name as the displayed name</p>
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Specialization</label>
          <select v-model="form.specialization"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none">
            <option value="">General</option>
            <option value="webdev">Web Developer</option>
            <option value="appdev">Application Developer</option>
            <option value="devops">DevOps</option>
            <option value="itsupport">IT Support</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Title Override</label>
          <input v-model="form.titleOverride" placeholder="e.g. Développeur Web Full-Stack"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Availability</label>
          <input v-model="form.availability" placeholder="e.g. Recherche alternance · 1 sem. école / 2 sem. entreprise"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">Profile Picture</label>
          <div class="flex items-start gap-4">
            <div v-if="form.pictureId" class="relative w-20 h-20 rounded-full overflow-hidden border-2 border-accent flex-shrink-0">
              <img :src="`http://localhost:3001/api/images/${form.pictureId}`" class="w-full h-full object-cover" />
              <button @click="form.pictureId = ''" type="button"
                class="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-red-500 text-white flex items-center justify-center text-[10px] cursor-pointer">&times;</button>
            </div>
            <button @click="showImageGallery = true" type="button"
              class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl text-sm text-surface-400 hover:text-accent hover:border-accent/50 transition-colors cursor-pointer">
              {{ form.pictureId ? 'Change' : 'Select Image' }}
            </button>
          </div>
          <div v-if="showImageGallery" class="mt-2 p-3 rounded-xl border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800/50">
            <ImageGallery @select="(id: string) => { form.pictureId = id; showImageGallery = false }" />
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium mb-1">About Text</label>
          <textarea v-model="form.aboutText" rows="4" placeholder="Describe yourself..."
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none resize-none"></textarea>
        </div>
        <div>
          <label class="block text-sm font-medium mb-2">Style du CV</label>
          <StylePicker v-model="form.style" />
        </div>
      </div>

      <!-- Step 2: Skills -->
      <div v-if="step === 2">
        <p class="text-sm text-surface-500 mb-4">Select skills to include, then drag or use the arrows to set the display order</p>
        <OrderedPicker :items="skillPickerItems" v-model="form.skillIds" />
      </div>

      <!-- Step 3: Languages & Passions -->
      <div v-if="step === 3" class="space-y-6">
        <div>
          <p class="text-sm font-medium mb-3">Languages</p>
          <div class="flex flex-wrap gap-2">
            <button v-for="item in languages" :key="item.id"
              @click="toggle(form.languageIds, item.id)"
              class="px-3 py-1.5 rounded-xl text-sm border transition-all cursor-pointer"
              :class="form.languageIds.includes(item.id)
                ? 'bg-accent text-white border-accent'
                : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
              {{ item.name }} ({{ item.level }})
            </button>
          </div>
        </div>
        <div>
          <p class="text-sm font-medium mb-3">Passions</p>
          <OrderedPicker :items="passionPickerItems" v-model="form.passionIds" />
        </div>
      </div>

      <!-- Step 4: Experiences & Projects -->
      <div v-if="step === 4" class="space-y-6">
        <div>
          <p class="text-sm font-medium mb-3">Experiences</p>
          <div class="space-y-2">
            <button v-for="item in experiences" :key="item.id"
              @click="toggle(form.experienceIds, item.id)"
              class="w-full text-left px-4 py-3 rounded-xl border text-sm transition-all cursor-pointer"
              :class="form.experienceIds.includes(item.id)
                ? 'bg-accent/10 border-accent text-accent'
                : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
              <span class="font-medium">{{ item.title }}</span>
              <span class="text-surface-500"> @ {{ item.company }}</span>
              <span class="text-surface-400 ml-2">{{ item.startDate }} - {{ item.endDate }}</span>
            </button>
          </div>
        </div>
        <div>
          <p class="text-sm font-medium mb-3">Projects</p>
          <OrderedPicker :items="projectPickerItems" v-model="form.projectIds" />
          <div v-if="linkedPreview.projects.length" class="mt-4">
            <p class="text-sm font-medium mb-2">Project bullets (optional)</p>
            <div class="space-y-2">
              <div v-for="item in linkedPreview.projects" :key="item.id"
                class="rounded-xl border border-gray-200 dark:border-surface-700 p-3">
                <p class="text-sm font-medium mb-1">{{ item.title }}</p>
                <div v-if="item.projectPoints?.length" class="ml-1 space-y-1">
                  <label v-for="(d, i) in item.projectPoints" :key="i"
                    class="flex items-start gap-2 text-xs cursor-pointer py-0.5">
                    <input type="checkbox" :checked="form.projectBullets[String(item.id)]?.includes(Number(i)) ?? true"
                      @change="toggleBullet(String(item.id), Number(i))"
                      class="mt-0.5 accent-accent cursor-pointer" />
                    <span class="text-surface-600 dark:text-surface-400">{{ d.text || d }}</span>
                  </label>
                </div>
                <p v-else class="text-xs text-surface-400">No selectable points</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Step 5: Education -->
      <div v-if="step === 5">
        <p class="text-sm text-surface-500 mb-4">Select education entries</p>
        <div class="space-y-2">
          <button v-for="item in education" :key="item.id"
            @click="toggle(form.educationIds, item.id)"
            class="w-full text-left px-4 py-3 rounded-xl border text-sm transition-all cursor-pointer"
            :class="form.educationIds.includes(item.id)
              ? 'bg-accent/10 border-accent text-accent'
              : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
            <span class="font-medium">{{ item.title }}</span>
            <span v-if="item.school" class="text-surface-500"> - {{ item.school }}</span>
            <span v-if="item.startDate || item.date" class="text-surface-400 ml-2">{{ item.startDate || item.date }}</span>
          </button>
        </div>
      </div>

      <!-- Step 6: Contacts -->
      <div v-if="step === 6">
        <p class="text-sm text-surface-500 mb-4">Select contact methods to display</p>
        <div class="space-y-2">
          <button v-for="item in contacts" :key="item.id"
            @click="toggle(form.contactIds, item.id)"
            class="w-full text-left px-4 py-3 rounded-xl border text-sm transition-all cursor-pointer"
            :class="form.contactIds.includes(item.id)
              ? 'bg-accent/10 border-accent text-accent'
              : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
            <span class="font-medium">{{ item.label }}</span>
            <span class="text-surface-500 ml-2">{{ item.value }}</span>
          </button>
        </div>
      </div>

      <!-- Step 7: Preview -->
      <div v-if="step === 7">
        <p class="text-sm text-surface-500 mb-4">Review your CV before saving</p>
        <div class="rounded-xl overflow-hidden" style="display:grid;grid-template-columns:320px 1fr;max-width:1240px;margin:0 auto;box-shadow:0 25px 50px -12px rgba(0,0,0,0.25);min-height:1100px">
          <div style="background:#18181B;color:#E4E4E7;padding:40px 28px;display:flex;flex-direction:column;gap:20px">
            <div class="text-center">
              <div style="width:100px;height:100px;border-radius:50%;background:rgba(255,255,255,0.06);border:3px solid #2563EB;display:flex;align-items:center;justify-content:center;margin:0 auto 10px;overflow:hidden">
                <img v-if="linkedPreview.pictureId" :src="`http://localhost:3001/api/images/${linkedPreview.pictureId}`" class="w-full h-full object-cover" />
                <span v-else style="font-family:'Archivo',sans-serif;font-size:30px;font-weight:800;color:#3B82F6">{{ nameInitials() }}</span>
              </div>
              <h2 style="font-family:'Archivo',sans-serif;font-size:28px;font-weight:800;color:#fff;margin:8px 0 4px;text-align:center;letter-spacing:-0.02em;line-height:1.1">{{ displayName }}</h2>
              <span style="display:block;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:0.15em;background:#2563EB;color:#fff;padding:4px 12px;border-radius:100px;margin-bottom:8px;text-align:center">{{ form.titleOverride || form.specialization || 'Professional' }}</span>
              <div v-if="linkedPreview.availability" style="margin-top:8px;font-size:13px;font-weight:500;padding:6px 14px;border-radius:8px;width:100%;background:rgba(37,99,235,0.15);color:#3B82F6;border:1px solid rgba(37,99,235,0.2);text-align:center">{{ linkedPreview.availability }}</div>
            </div>
            <div v-if="linkedPreview.contacts.length">
              <p style="font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:0.12em;color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:6px;margin-bottom:10px;font-family:'Archivo',sans-serif">Contact</p>
              <div v-for="c in linkedPreview.contacts" :key="c.id" style="display:flex;align-items:center;gap:10px;font-size:13px;margin-bottom:12px">
                <Icon v-if="c.icon" :icon="c.icon" style="width:16px;height:16px;flex-shrink:0;opacity:0.6" />
                <a v-if="c.type === 'link'" :href="c.value.startsWith('http') ? c.value : 'https://' + c.value" target="_blank" style="color:#E4E4E7;text-decoration:none" @click.stop>{{ c.value.replace(/^https?:\/\//, '').replace(/\/$/, '') }}</a>
                <span v-else>{{ c.value }}</span>
              </div>
            </div>
            <div v-if="linkedPreview.skills.filter(s => s.cvCategory === 'hard').length">
              <p style="font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:0.12em;color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:6px;margin-bottom:10px;font-family:'Archivo',sans-serif">Hard Skills</p>
              <div style="display:flex;flex-wrap:wrap;gap:4px">
                <span v-for="s in linkedPreview.skills.filter(s => s.cvCategory === 'hard')" :key="s.id"
                  style="display:inline-flex;align-items:center;gap:4px;padding:5px 12px;font-size:14px;border-radius:8px;background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.08);margin:3px">
                  <Icon v-if="s.icon" :icon="s.icon" style="width:16px;height:16px" />
                  {{ s.name }}
                </span>
              </div>
            </div>
            <div v-if="linkedPreview.skills.filter(s => s.cvCategory === 'soft').length">
              <p style="font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:0.12em;color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:6px;margin-bottom:10px;font-family:'Archivo',sans-serif">Soft Skills</p>
              <div v-for="s in linkedPreview.skills.filter(s => s.cvCategory === 'soft')" :key="s.id" style="display:flex;align-items:flex-start;gap:8px;padding:4px 0;border-bottom:1px solid rgba(255,255,255,0.05)">
                <span style="width:8px;height:8px;border-radius:50%;margin-top:5px;flex-shrink:0;background:#2563EB" />
                <div>
                  <span style="font-size:14px;color:#fff;display:block">{{ s.name }}</span>
                  <span v-if="s.description" style="font-size:13px;color:rgba(255,255,255,0.6)">{{ s.description }}</span>
                </div>
              </div>
            </div>
            <div v-if="linkedPreview.languages.length">
              <p style="font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:0.12em;color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:6px;margin-bottom:10px;font-family:'Archivo',sans-serif">Langues</p>
              <div v-for="l in linkedPreview.languages" :key="l.id" style="display:flex;justify-content:space-between;font-size:14px;padding:4px 0;font-weight:500">
                <span>{{ l.name }}</span>
                <span style="padding:2px 8px;border-radius:100px;color:rgba(255,255,255,0.5);background:rgba(255,255,255,0.06);font-size:14px">{{ l.level }}</span>
              </div>
            </div>
            <div v-if="linkedPreview.passions.length">
              <p style="font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:0.12em;color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:6px;margin-bottom:10px;font-family:'Archivo',sans-serif">Passions</p>
              <div v-for="p in linkedPreview.passions" :key="p.id" style="display:flex;align-items:flex-start;gap:8px;padding:6px 0;border-bottom:1px solid rgba(255,255,255,0.05)">
                <Icon v-if="p.icon" :icon="p.icon" style="width:16px;height:16px;margin-top:3px;flex-shrink:0;color:#3B82F6" />
                <div>
                  <span style="font-size:15px;color:#fff;display:block">{{ p.name }}</span>
                  <span v-if="p.description" style="font-size:13px;color:rgba(255,255,255,0.6)">{{ p.description }}</span>
                </div>
              </div>
            </div>
          </div>
          <div style="background:#FAFAFA;padding:40px 40px 40px 32px;display:flex;flex-direction:column;gap:30px">
            <div v-if="form.aboutText">
              <p style="font-size:18px;font-weight:700;font-family:'Archivo',sans-serif;color:#18181B;display:flex;align-items:center;gap:0.5rem;margin-bottom:14px">
                À Propos
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <p style="font-size:14px;line-height:1.8;color:#3F3F46" v-html="formatAbout(form.aboutText)"></p>
            </div>
            <div v-if="linkedPreview.experiences.length">
              <p style="font-size:18px;font-weight:700;font-family:'Archivo',sans-serif;color:#18181B;display:flex;align-items:center;gap:0.5rem;margin-bottom:14px">
                Expériences Professionnelles
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <div v-for="exp in linkedPreview.experiences" :key="exp.id" style="padding-left:20px;border-left:2px solid #E4E4E7;position:relative;margin-bottom:20px">
                <span style="position:absolute;left:-5px;top:6px;width:8px;height:8px;border-radius:50%;background:#2563EB" />
                <div class="flex items-start justify-between flex-wrap gap-1">
                  <div>
                    <span style="font-size:16px;font-weight:700;color:#18181B">{{ exp.title }}</span>
                    <span style="font-size:12px;font-weight:600;margin-left:4px;padding:2px 8px;border-radius:100px;display:inline-flex;align-items:center;background:#2563EB;color:#fff">{{ exp.company }}</span>
                  </div>
                  <span style="font-size:12px;font-weight:700;padding:2px 8px;border-radius:100px;color:#2563EB;background:#E4E4E7;white-space:nowrap">{{ formatDate(exp.startDate) }} - {{ formatDate(exp.endDate) }}</span>
                </div>
                <ul v-if="exp.experiencePoints?.length" style="margin-top:4px;list-style:none;padding:0">
                  <li v-for="d in exp.experiencePoints" :key="d.text || d" style="font-size:13px;font-weight:500;color:#3F3F46;padding-left:14px;position:relative;margin-bottom:2px">
                    <span style="position:absolute;left:0;color:#2563EB;font-weight:600">&rarr;</span>
                    <span>{{ d.text || d }}</span>
                    <span v-if="pointSkillNames(d).length" style="font-size:11px;color:#2563EB">— {{ pointSkillNames(d).join(', ') }}</span>
                  </li>
                </ul>
              </div>
            </div>
            <div v-if="linkedPreview.projects.length">
              <p style="font-size:18px;font-weight:700;font-family:'Archivo',sans-serif;color:#18181B;display:flex;align-items:center;gap:0.5rem;margin-bottom:14px">
                Projets
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <div v-for="proj in linkedPreview.projects" :key="proj.id" style="padding-left:20px;border-left:2px solid #E4E4E7;position:relative;margin-bottom:20px">
                <span style="position:absolute;left:-5px;top:6px;width:8px;height:8px;border-radius:50%;background:#2563EB" />
                <div class="flex items-start justify-between flex-wrap gap-1">
                  <div>
                    <span style="font-size:16px;font-weight:700;color:#18181B">{{ proj.title }}</span>
                    <div v-if="proj.subtitle" style="margin-top:2px;font-size:12px;font-weight:600;display:inline-flex;align-items:center;gap:4px;padding:2px 8px;border-radius:100px;background:#2563EB;color:#fff">{{ proj.subtitle }}</div>
                  </div>
                  <span style="font-size:12px;font-weight:700;padding:2px 8px;border-radius:100px;color:#2563EB;background:#E4E4E7;white-space:nowrap">{{ formatDate(proj.startDate) }} - {{ formatDate(proj.endDate) }}</span>
                </div>
                <ul v-if="previewProjBullets(proj).length" style="margin-top:4px;list-style:none;padding:0">
                  <li v-for="d in previewProjBullets(proj)" :key="d.text || d" style="font-size:13px;font-weight:500;color:#3F3F46;padding-left:14px;position:relative;margin-bottom:2px">
                    <span style="position:absolute;left:0;color:#2563EB;font-weight:600">&rarr;</span>
                    <span>{{ d.text || d }}</span>
                    <span v-if="pointSkillNames(d).length" style="font-size:11px;color:#2563EB">— {{ pointSkillNames(d).join(', ') }}</span>
                  </li>
                </ul>
                <div v-if="proj.technologies?.length" class="flex flex-wrap gap-1 mt-1">
                  <span v-for="t in proj.technologies" :key="t.name || t" style="font-size:10px;padding:2px 6px;border-radius:6px;display:inline-flex;align-items:center;gap:4px;background:rgba(37,99,235,0.08);border:1px solid rgba(37,99,235,0.15);color:#1D4ED8">
                    <Icon v-if="t.icon" :icon="t.icon" style="width:14px;height:14px" />
                    {{ t.name || t }}
                  </span>
                </div>
              </div>
            </div>
            <div v-if="linkedPreview.education.length">
              <p style="font-size:18px;font-weight:700;font-family:'Archivo',sans-serif;color:#18181B;display:flex;align-items:center;gap:0.5rem;margin-bottom:14px">
                Formation
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <div v-for="edu in linkedPreview.education" :key="edu.id" style="display:flex;align-items:flex-start;justify-content:space-between;padding:12px 0;border-bottom:1px solid #E4E4E7">
                <div>
                  <p style="font-size:16px;font-weight:800;color:#18181B;margin:0">{{ edu.title }}</p>
                  <p v-if="edu.school" style="font-size:14px;color:#71717A;margin:0">{{ edu.school }}</p>
                </div>
                <span style="font-size:12px;color:#71717A;white-space:nowrap">{{ formatDate(edu.startDate || edu.date) }} - {{ formatDate(edu.endDate) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
        </div>
      </Transition>
    </div>

    <div class="flex-none -mx-4 px-4 pb-2 pt-3 bg-white/90 dark:bg-surface-900/90 backdrop-blur-md border-t border-gray-200 dark:border-surface-700 shadow-[0_-8px_24px_-12px_rgba(0,0,0,0.15)]">
      <p v-if="saveError" class="text-error text-sm mb-3">{{ saveError }}</p>
      <div class="flex items-center justify-between gap-3">
        <button @click="step = Math.max(1, step - 1)"
          type="button"
          :disabled="step === 1"
          class="min-w-[110px] px-6 py-2.5 border border-gray-200 dark:border-surface-700 rounded-xl transition-colors"
          :class="step === 1 ? 'invisible' : 'hover:bg-surface-100 dark:hover:bg-surface-800 cursor-pointer'">
          Previous
        </button>

        <button v-if="step < 7" @click="step = step + 1" type="button"
          class="min-w-[140px] px-6 py-2.5 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer">
          Next
        </button>
        <button v-else @click="save" type="button" :disabled="saving || !form.name"
          class="min-w-[140px] px-6 py-2.5 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors disabled:opacity-50 cursor-pointer">
          {{ saving ? 'Saving...' : (isEdit ? 'Update CV' : 'Create CV') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.step-enter-active, .step-leave-active { transition: opacity 0.18s ease, transform 0.18s ease; }
.step-enter-from { opacity: 0; transform: translateY(8px); }
.step-leave-to { opacity: 0; transform: translateY(-4px); }
</style>
