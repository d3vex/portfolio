<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useCvStore } from '@/stores/cv'
import * as api from '@/lib/api/cv'
import ImageGallery from '@/components/admin/ImageGallery.vue'

const router = useRouter()
const route = useRoute()
const store = useCvStore()

const isEdit = !!route.params.id
const saving = ref(false)

const form = ref({
  name: '',
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
})

const skills = ref<any[]>([])
const languages = ref<any[]>([])
const passions = ref<any[]>([])
const experiences = ref<any[]>([])
const projects = ref<any[]>([])
const education = ref<any[]>([])
const contacts = ref<any[]>([])
const allImages = ref<any[]>([])
const showImageGallery = ref(false)

const step = ref(1)

onMounted(async () => {
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
      specialization: cv.specialization || '',
      titleOverride: cv.titleOverride || '',
      aboutText: cv.aboutText || '',
      availability: cv.availability || '',
      pictureId: cv.pictureId || '',
      skillIds: cv.skillIds || [],
      languageIds: cv.languageIds || [],
      passionIds: cv.passionIds || [],
      experienceIds: cv.experienceIds || [],
      projectIds: cv.projectIds || [],
      educationIds: cv.educationIds || [],
    }
  }
})

function toggle(arr: string[], id: string) {
  const idx = arr.indexOf(id)
  if (idx > -1) arr.splice(idx, 1)
  else arr.push(id)
}

async function save() {
  saving.value = true
  try {
    if (isEdit) {
      await api.updateCv(route.params.id as string, form.value)
    } else {
      await api.createCv(form.value)
    }
    router.push('/admin/cvs')
  } catch (e: any) {
    alert('Error: ' + e.message)
  } finally {
    saving.value = false
  }
}

const linkedPreview = computed(() => ({
  skills: skills.value.filter(s => form.value.skillIds?.includes(s.id)),
  languages: languages.value.filter(l => form.value.languageIds?.includes(l.id)),
  passions: passions.value.filter(p => form.value.passionIds?.includes(p.id)),
  experiences: experiences.value.filter(e => form.value.experienceIds?.includes(e.id)),
  projects: projects.value.filter(p => form.value.projectIds?.includes(p.id)),
  education: education.value.filter(e => form.value.educationIds?.includes(e.id)),
  contacts: contacts.value,
  pictureId: form.value.pictureId,
  availability: form.value.availability,
}))

function formatAbout(text: string): string {
  if (!text) return ''
  let html = text.replace(/\n/g, '<br>')
  html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
  return html
}

const steps = ['Info', 'Skills', 'Languages & Passions', 'Experience & Projects', 'Education', 'Preview']
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-heading font-bold">{{ isEdit ? 'Edit CV' : 'Create CV' }}</h1>
        <p class="text-surface-500 mt-1">Build your CV from existing data</p>
      </div>
      <button @click="router.push('/admin/cvs')"
        class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
        Back
      </button>
    </div>

    <div class="flex gap-2 mb-8">
      <div v-for="(s, i) in steps" :key="i"
        class="flex-1 h-2 rounded-full transition-colors"
        :class="i + 1 <= step ? 'bg-accent' : 'bg-gray-200 dark:bg-surface-700'">
      </div>
    </div>

    <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6 max-h-[calc(100vh-220px)] overflow-y-auto">
      <!-- Step 1: Basic Info -->
      <div v-if="step === 1" class="space-y-4">
        <div>
          <label class="block text-sm font-medium mb-1">CV Name *</label>
          <input v-model="form.name" placeholder="e.g. Web Developer CV"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
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
      </div>

      <!-- Step 2: Skills -->
      <div v-if="step === 2">
        <p class="text-sm text-surface-500 mb-4">Select skills to include</p>

        <p class="text-sm font-medium mb-3">Hard Skills</p>
        <div class="flex flex-wrap gap-2 mb-6">
          <button v-for="skill in skills.filter(s => s.cvCategory === 'hard')" :key="skill.id"
            @click="toggle(form.skillIds, skill.id)"
            class="px-3 py-1.5 rounded-xl text-sm border transition-all cursor-pointer"
            :class="form.skillIds.includes(skill.id)
              ? 'bg-accent text-white border-accent'
              : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
            {{ skill.name }}
          </button>
        </div>

        <p class="text-sm font-medium mb-3">Soft Skills</p>
        <div class="flex flex-wrap gap-2">
          <button v-for="skill in skills.filter(s => s.cvCategory === 'soft')" :key="skill.id"
            @click="toggle(form.skillIds, skill.id)"
            class="px-3 py-1.5 rounded-xl text-sm border transition-all cursor-pointer"
            :class="form.skillIds.includes(skill.id)
              ? 'bg-accent text-white border-accent'
              : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
            {{ skill.name }}
          </button>
        </div>
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
          <div class="flex flex-wrap gap-2">
            <button v-for="item in passions" :key="item.id"
              @click="toggle(form.passionIds, item.id)"
              class="px-3 py-1.5 rounded-xl text-sm border transition-all cursor-pointer"
              :class="form.passionIds.includes(item.id)
                ? 'bg-accent text-white border-accent'
                : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
              {{ item.name }}
            </button>
          </div>
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
          <div class="space-y-2">
            <button v-for="item in projects" :key="item.id"
              @click="toggle(form.projectIds, item.id)"
              class="w-full text-left px-4 py-3 rounded-xl border text-sm transition-all cursor-pointer"
              :class="form.projectIds.includes(item.id)
                ? 'bg-accent/10 border-accent text-accent'
                : 'border-gray-200 dark:border-surface-700 hover:border-accent/50'">
              <span class="font-medium">{{ item.title }}</span>
              <span v-if="item.subtitle" class="text-surface-500"> - {{ item.subtitle }}</span>
            </button>
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

      <!-- Step 6: Preview -->
      <div v-if="step === 6">
        <p class="text-sm text-surface-500 mb-4">Review your CV before saving</p>
        <div class="border border-gray-200 dark:border-surface-700 rounded-xl overflow-hidden" style="display:grid;grid-template-columns:280px 1fr">
          <div class="p-5" style="background:#18181B;color:#E4E4E7">
            <div class="text-center mb-5">
              <div class="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-2 overflow-hidden" style="background:rgba(255,255,255,0.06);border:2px solid #2563EB">
                <img v-if="linkedPreview.pictureId" :src="`http://localhost:3001/api/images/${linkedPreview.pictureId}`" class="w-full h-full object-cover" />
                <span v-else class="text-lg font-bold" style="color:#3B82F6">LM</span>
              </div>
              <h3 class="font-heading font-bold text-white text-base">{{ form.titleOverride || form.specialization || 'Professional' }}</h3>
              <div v-if="linkedPreview.availability" class="mt-2 text-xs px-3 py-1.5 rounded" style="background:rgba(37,99,235,0.15);color:#3B82F6;border:1px solid rgba(37,99,235,0.2)">{{ linkedPreview.availability }}</div>
            </div>
            <div v-if="linkedPreview.contacts.length" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:0.4rem">Contact</p>
              <div v-for="c in linkedPreview.contacts" :key="c.id" class="flex items-center gap-2 text-xs mb-2">
                <Icon v-if="c.icon" :icon="c.icon" class="w-4 h-4 flex-shrink-0" />
                <a v-if="c.type === 'link'" :href="c.value.startsWith('http') ? c.value : 'https://' + c.value" target="_blank" style="color:#E4E4E7;text-decoration:none" @click.stop>{{ c.value.replace(/^https?:\/\//, '').replace(/\/$/, '') }}</a>
                <span v-else>{{ c.value }}</span>
              </div>
            </div>
            <div v-if="linkedPreview.skills.filter(s => s.cvCategory === 'hard').length" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:0.4rem">Hard Skills</p>
              <div class="flex flex-wrap gap-1">
                <span v-for="s in linkedPreview.skills.filter(s => s.cvCategory === 'hard')" :key="s.id"
                  class="px-2 py-0.5 text-xs rounded flex items-center gap-1" style="background:rgba(255,255,255,0.06);border:1px solid rgba(255,255,255,0.08)">
                  <Icon v-if="s.icon" :icon="s.icon" class="w-3 h-3" />
                  {{ s.name }}
                </span>
              </div>
            </div>
            <div v-if="linkedPreview.skills.filter(s => s.cvCategory === 'soft').length" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:0.4rem">Soft Skills</p>
              <div v-for="s in linkedPreview.skills.filter(s => s.cvCategory === 'soft')" :key="s.id" class="flex items-start gap-2 py-1" style="border-bottom:1px solid rgba(255,255,255,0.05)">
                <span class="w-1.5 h-1.5 rounded-full mt-1 flex-shrink-0" style="background:#2563EB" />
                <div>
                  <span class="text-xs text-white block">{{ s.name }}</span>
                  <span v-if="s.description" class="text-[10px]" style="color:rgba(255,255,255,0.6)">{{ s.description }}</span>
                </div>
              </div>
            </div>
            <div v-if="linkedPreview.languages.length" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:0.4rem">Langues</p>
              <div v-for="l in linkedPreview.languages" :key="l.id" class="flex justify-between text-xs py-0.5">
                <span>{{ l.name }}</span>
                <span class="text-xs px-1.5 py-0.5 rounded-full" style="color:rgba(255,255,255,0.5);background:rgba(255,255,255,0.06)">{{ l.level }}</span>
              </div>
            </div>
            <div v-if="linkedPreview.passions.length">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#3B82F6;border-bottom:2px solid rgba(255,255,255,0.08);padding-bottom:0.4rem">Passions</p>
              <div v-for="p in linkedPreview.passions" :key="p.id" class="flex items-start gap-2 py-1" style="border-bottom:1px solid rgba(255,255,255,0.05)">
                <Icon v-if="p.icon" :icon="p.icon" class="w-3.5 h-3.5 mt-0.5" style="color:#3B82F6" />
                <div>
                  <span class="text-xs text-white block">{{ p.name }}</span>
                  <span v-if="p.description" class="text-[10px]" style="color:rgba(255,255,255,0.6)">{{ p.description }}</span>
                </div>
              </div>
            </div>
          </div>
          <div class="flex-1 p-5" style="background:#FAFAFA">
            <div v-if="form.aboutText" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#18181B;display:flex;align-items:center;gap:0.5rem">
                À Propos
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <p class="text-xs leading-relaxed" style="color:#3F3F46" v-html="formatAbout(form.aboutText)"></p>
            </div>
            <div v-if="linkedPreview.experiences.length" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-3" style="color:#18181B;display:flex;align-items:center;gap:0.5rem">
                Expériences
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <div v-for="exp in linkedPreview.experiences" :key="exp.id" class="mb-3" style="padding-left:1.2rem;border-left:2px solid #E4E4E7;position:relative">
                <span style="position:absolute;left:-5px;top:5px;width:7px;height:7px;border-radius:50%;background:#2563EB" />
                <div class="flex items-start justify-between flex-wrap gap-1">
                  <div>
                    <span class="font-bold text-xs" style="color:#18181B">{{ exp.title }}</span>
                    <span class="text-xs font-semibold ml-1 px-1.5 py-0.5 rounded-full text-white" style="background:#2563EB">{{ exp.company }}</span>
                  </div>
                  <span class="text-[10px] font-bold px-1.5 py-0.5 rounded-full" style="color:#2563EB;background:#E4E4E7">{{ exp.startDate }} - {{ exp.endDate }}</span>
                </div>
                <ul v-if="exp.descriptions?.length" class="mt-1 space-y-0.5">
                  <li v-for="d in exp.descriptions" :key="d.text || d" class="text-[10px] font-medium" style="color:#3F3F46;padding-left:1rem;position:relative">
                    <span style="position:absolute;left:0;color:#2563EB;font-weight:600">&rarr;</span>
                    <span>{{ d.text || d }}</span>
                    <span v-if="d.skillIds?.length" class="text-[9px]" style="color:#2563EB">— {{ d.skillIds.map((sid: string) => skills.find(s => s.id === sid)?.name).filter(Boolean).join(', ') }}</span>
                  </li>
                </ul>
              </div>
            </div>
            <div v-if="linkedPreview.projects.length" class="mb-4">
              <p class="text-xs font-bold uppercase tracking-wider mb-3" style="color:#18181B;display:flex;align-items:center;gap:0.5rem">
                Projets
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <div v-for="proj in linkedPreview.projects" :key="proj.id" class="mb-2" style="padding-left:1.2rem;border-left:2px solid #E4E4E7;position:relative">
                <span style="position:absolute;left:-5px;top:5px;width:7px;height:7px;border-radius:50%;background:#2563EB" />
                <p class="font-bold text-xs" style="color:#18181B">{{ proj.title }}</p>
                <p class="text-[10px]" style="color:#71717A">{{ proj.startDate }} - {{ proj.endDate }}</p>
                <ul v-if="proj.descriptions?.length" class="mt-1 space-y-0.5">
                  <li v-for="d in proj.descriptions" :key="d.text || d" class="text-[10px] font-medium" style="color:#3F3F46;padding-left:1rem;position:relative">
                    <span style="position:absolute;left:0;color:#2563EB;font-weight:600">&rarr;</span>
                    <span>{{ d.text || d }}</span>
                    <span v-if="d.skillIds?.length" class="text-[9px]" style="color:#2563EB">— {{ d.skillIds.map((sid: string) => skills.find(s => s.id === sid)?.name).filter(Boolean).join(', ') }}</span>
                  </li>
                </ul>
                <div v-if="proj.technologies?.length" class="flex flex-wrap gap-1 mt-1">
                  <span v-for="t in proj.technologies" :key="t.name || t" class="text-[9px] px-1 py-0.5 rounded flex items-center gap-0.5" style="background:rgba(37,99,235,0.08);border:1px solid rgba(37,99,235,0.15);color:#1D4ED8">
                    <Icon v-if="t.icon" :icon="t.icon" class="w-2.5 h-2.5" />
                    {{ t.name || t }}
                  </span>
                </div>
              </div>
            </div>
            <div v-if="linkedPreview.education.length">
              <p class="text-xs font-bold uppercase tracking-wider mb-2" style="color:#18181B;display:flex;align-items:center;gap:0.5rem">
                Formation
                <span style="flex:1;height:2px;background:linear-gradient(90deg,#2563EB 0%,transparent 100%)" />
              </p>
              <div v-for="edu in linkedPreview.education" :key="edu.id" class="flex items-start justify-between py-2" style="border-bottom:1px solid #E4E4E7">
                <div>
                  <p class="font-bold text-xs" style="color:#18181B">{{ edu.title }}</p>
                  <p v-if="edu.school" class="text-[10px]" style="color:#71717A">{{ edu.school }}</p>
                </div>
                <span class="text-[10px]" style="color:#71717A">{{ edu.startDate || edu.date }} - {{ edu.endDate }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="flex justify-between mt-6">
      <button @click="step = Math.max(1, step - 1)"
        v-if="step > 1"
        class="px-6 py-2.5 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
        Previous
      </button>
      <div v-else></div>

      <button v-if="step < 6" @click="step = step + 1"
        class="px-6 py-2.5 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer">
        Next
      </button>
      <button v-else @click="save" :disabled="saving || !form.name"
        class="px-6 py-2.5 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors disabled:opacity-50 cursor-pointer">
        {{ saving ? 'Saving...' : (isEdit ? 'Update CV' : 'Create CV') }}
      </button>
    </div>
  </div>
</template>
