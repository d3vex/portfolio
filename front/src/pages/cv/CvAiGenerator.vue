<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import * as api from '@/lib/api/cv'
import { API_BASE } from '@/lib/api/cv'
import type {
  AiAboutLength,
  AiApplyPayload,
  AiCvGenerationResult,
  AiGenerationOptions,
  AiSpecialization,
  AiStatus,
  AiSuggestedBullet,
  AiStyleId,
  AiTone,
  CvStyleId,
} from '@/lib/types'

const router = useRouter()

type Phase = 'input' | 'generating' | 'result'
type Stage = 'status' | 'plan' | 'suggestions' | 'done'

const phase = ref<Phase>('input')
const stage = ref<Stage>('status')
const jobDescription = ref('')
const aiStatus = ref<AiStatus | null>(null)
const result = ref<AiCvGenerationResult | null>(null)
const generating = ref(false)
const saving = ref(false)
const saved = ref(false)
const validationError = ref('')
const aiUnavailable = ref(false)
const generationError = ref('')
const saveError = ref('')

const options = ref({
  specialization: 'auto' as AiSpecialization,
  style: 'auto' as AiStyleId,
  aboutLength: 'medium' as AiAboutLength,
  maxExperiences: 5,
  maxProjects: 5,
  includeSoftSkills: true,
  includeLanguages: true,
  tone: 'professional' as AiTone,
  allowSkillSuggestions: true,
  allowBulletSuggestions: true,
  customInstructions: '',
})

const skillAccepts = ref<Record<string, boolean>>({})
const bulletAccepts = ref<Record<string, boolean>>({})
const skillChips = ref<Record<string, string[]>>({})

const projects = ref<{ id: string; title: string }[]>([])
const experiences = ref<{ id: string; title: string }[]>([])

const stageMeta: { key: Stage; label: string; detail: string }[] = [
  { key: 'status', label: 'Vérification du service IA', detail: 'Connexion à Ollama…' },
  { key: 'plan', label: 'Élaboration du plan du CV', detail: 'Analyse de la description de poste…' },
  { key: 'suggestions', label: 'Génération des suggestions', detail: 'Compétences et points clés…' },
  { key: 'done', label: 'Terminé', detail: 'CV généré' },
]

const stageOrder: Stage[] = ['status', 'plan', 'suggestions', 'done']

function stageIndex(s: Stage): number {
  return stageOrder.indexOf(s)
}

function isStageDone(s: Stage): boolean {
  return stageIndex(s) < stageIndex(stage.value)
}

function isStageActive(s: Stage): boolean {
  return s === stage.value
}

const specializationLabels: Record<AiSpecialization, string> = {
  auto: 'Automatique',
  webdev: 'Développement web',
  appdev: 'Applications',
  devops: 'DevOps / Infrastructure',
  itsupport: 'Support IT',
}

const styleLabels: Record<CvStyleId, string> = {
  classic: 'Classique',
  ats: 'ATS',
  'two-column-blue': 'Deux colonnes bleu',
}

const toneLabels: Record<AiTone, string> = {
  professional: 'Professionnel',
  enthusiastic: 'Enthousiaste',
  technical: 'Technique',
}

const aboutLengthLabels: Record<AiAboutLength, string> = {
  short: 'Court',
  medium: 'Moyen',
  long: 'Long',
}

onMounted(async () => {
  try {
    const [pr, ex] = await Promise.all([api.getProjects(), api.getExperiences()])
    projects.value = pr.map((p: { id: string; title: string }) => ({ id: p.id, title: p.title }))
    experiences.value = ex.map((e: { id: string; title: string }) => ({ id: e.id, title: e.title }))
  } catch (e) {
    console.error('Failed to load projects/experiences for title resolution', e)
  }
})

function buildOptions(): AiGenerationOptions {
  const o = options.value
  const out: AiGenerationOptions = {
    specialization: o.specialization,
    style: o.style,
    aboutLength: o.aboutLength,
    maxExperiences: o.maxExperiences,
    maxProjects: o.maxProjects,
    includeSoftSkills: o.includeSoftSkills,
    includeLanguages: o.includeLanguages,
    tone: o.tone,
    allowSkillSuggestions: o.allowSkillSuggestions,
    allowBulletSuggestions: o.allowBulletSuggestions,
  }
  if (o.customInstructions.trim()) out.customInstructions = o.customInstructions.trim()
  return out
}

async function generate() {
  if (!jobDescription.value.trim()) {
    validationError.value = 'Veuillez saisir une description de poste.'
    return
  }
  validationError.value = ''
  generationError.value = ''
  aiUnavailable.value = false
  aiStatus.value = null
  phase.value = 'generating'
  generating.value = true
  stage.value = 'status'
  const t1 = window.setTimeout(() => { stage.value = 'plan' }, 700)
  const t2 = window.setTimeout(() => { stage.value = 'suggestions' }, 1700)
  try {
    const status = await api.getAiStatus()
    if (!status.available) {
      aiStatus.value = status
      aiUnavailable.value = true
      phase.value = 'input'
      return
    }
    aiStatus.value = status
    const res = await api.generateCv(jobDescription.value, buildOptions())
    result.value = res
    initAcceptance(res)
    stage.value = 'done'
    window.setTimeout(() => { phase.value = 'result' }, 350)
  } catch (e) {
    generationError.value = e instanceof Error ? e.message : 'Erreur inconnue'
    phase.value = 'input'
  } finally {
    window.clearTimeout(t1)
    window.clearTimeout(t2)
    generating.value = false
  }
}

function regenerate() {
  result.value = null
  generate()
}

function initAcceptance(res: AiCvGenerationResult) {
  skillAccepts.value = {}
  bulletAccepts.value = {}
  skillChips.value = {}
  for (const s of res.suggestions.skills) skillAccepts.value[s.id] = true
  for (const b of res.suggestions.bullets) {
    bulletAccepts.value[b.id] = true
    skillChips.value[b.id] = [...b.skillIds]
  }
}

function isSkillAccepted(id: string): boolean {
  return skillAccepts.value[id] ?? true
}

function isBulletAccepted(id: string): boolean {
  return bulletAccepts.value[id] ?? true
}

function toggleChip(bulletId: string, skillId: string) {
  const chips = skillChips.value[bulletId]
  if (!chips) return
  const idx = chips.indexOf(skillId)
  if (idx > -1) chips.splice(idx, 1)
  else chips.push(skillId)
}

function isChipOn(bulletId: string, skillId: string): boolean {
  return (skillChips.value[bulletId] ?? []).includes(skillId)
}

const acceptedSkillSuggestions = computed(() => {
  const res = result.value
  if (!res) return []
  return res.suggestions.skills.filter(s => isSkillAccepted(s.id))
})

const acceptedBulletSuggestions = computed(() => {
  const res = result.value
  if (!res) return []
  return res.suggestions.bullets.filter(b => isBulletAccepted(b.id))
})

function buildApplyPayload(): AiApplyPayload {
  const res = result.value
  if (!res) return {}
  const payload: AiApplyPayload = {}
  payload.skills = acceptedSkillSuggestions.value.map(s => ({
    name: s.name,
    description: s.description || undefined,
    cvCategory: s.cvCategory,
    categoryName: s.categoryName,
    level: s.level,
    suggestionId: s.id,
  }))
  const keptSoftIds = new Set(
    acceptedSkillSuggestions.value.filter(s => s.cvCategory === 'soft').map(s => s.id)
  )
  payload.bullets = acceptedBulletSuggestions.value.map(b => ({
    entityType: b.entityType,
    entityId: b.entityId,
    text: b.text,
    skillIds: (skillChips.value[b.id] ?? b.skillIds).filter(id => keptSoftIds.has(id)),
    suggestionId: b.id,
  }))
  return payload
}

async function save() {
  const res = result.value
  if (!res) return
  saving.value = true
  saveError.value = ''
  try {
    const applyResponse = await api.applySuggestions(buildApplyPayload())
    const newSkillIds = applyResponse.skills.map(s => s.id)
    const cvProjectPointIds = new Set<string>(res.cv.cvProjectPointIds || [])
    const projectIdSet = new Set(res.cv.projectIds)
    for (const b of applyResponse.bullets) {
      if (b.entityType !== 'project') continue
      if (!projectIdSet.has(b.entityId)) continue
      if (b.pointId) cvProjectPointIds.add(b.pointId)
    }
    const created = (await api.createCv({
      name: res.cv.name,
      candidateName: res.cv.candidateName ?? '',
      specialization: res.cv.specialization ?? '',
      titleOverride: res.cv.titleOverride ?? '',
      aboutText: res.cv.aboutText ?? '',
      availability: res.cv.availability ?? '',
      style: res.cv.style,
      pictureId: res.cv.pictureId || undefined,
      skillIds: [...res.cv.skillIds, ...newSkillIds],
      projectIds: res.cv.projectIds,
      experienceIds: res.cv.experienceIds,
      educationIds: res.cv.educationIds,
      languageIds: res.cv.languageIds,
      passionIds: res.cv.passionIds,
      cvProjectPointIds: [...cvProjectPointIds],
    })) as { id: string }
    saved.value = true
    window.setTimeout(() => router.push(`/admin/cvs/${created.id}`), 1400)
  } catch (e) {
    saveError.value = e instanceof Error ? e.message : "Échec de l'enregistrement du CV"
  } finally {
    saving.value = false
  }
}

function entityTitle(b: AiSuggestedBullet): string {
  if (b.entityType === 'project') {
    return projects.value.find(p => p.id === b.entityId)?.title ?? b.entityId
  }
  return experiences.value.find(e => e.id === b.entityId)?.title ?? b.entityId
}

function entityTypeLabel(b: AiSuggestedBullet): string {
  return b.entityType === 'project' ? 'Projet' : 'Expérience'
}

function skillName(id: string): string {
  return result.value?.suggestions.skills.find(s => s.id === id)?.name ?? id
}

function excerpt(text: string, max = 180): string {
  return text.length > max ? `${text.slice(0, max)}…` : text
}

const acceptedCounts = computed(() => {
  const res = result.value
  if (!res) return { skills: 0, bullets: 0 }
  return {
    skills: res.suggestions.skills.filter(s => isSkillAccepted(s.id)).length,
    bullets: res.suggestions.bullets.filter(b => isBulletAccepted(b.id)).length,
  }
})

const skillsMap = ref<Record<string, { name: string; level: number; cvCategory: string; categoryName?: string }>>({})
const educationMap = ref<Record<string, { title: string; school?: string; startDate?: string; endDate?: string; date?: string }>>({})
const languagesMap = ref<Record<string, { name: string; level: string }>>({})
const passionsMap = ref<Record<string, { name: string }>>({})
const projectsFull = ref<Record<string, { title: string; description?: string; projectPoints: { id: string; text: string }[] }>>({})
const experiencesFull = ref<Record<string, { title: string; company?: string; startDate?: string; endDate?: string; description?: string; experiencePoints: { id: string; text: string }[] }>>({})
const pictureFailed = ref(false)

onMounted(async () => {
  try {
    const [skills, education, languages, passions, pr, ex] = await Promise.all([
      api.getSkills(),
      api.getEducation(),
      api.getLanguages(),
      api.getPassions(),
      api.getProjects(),
      api.getExperiences(),
    ])
    for (const s of skills) {
      skillsMap.value[s.id] = { name: s.name, level: s.level ?? 0, cvCategory: s.cvCategory, categoryName: s.category?.name }
    }
    for (const e of education) {
      educationMap.value[e.id] = { title: e.title, school: e.school, startDate: e.startDate, endDate: e.endDate, date: e.date }
    }
    for (const l of languages) languagesMap.value[l.id] = { name: l.name, level: l.level }
    for (const p of passions) passionsMap.value[p.id] = { name: p.name }
    for (const p of pr) {
      projectsFull.value[p.id] = {
        title: p.title,
        description: p.description,
        projectPoints: (p.projectPoints ?? []).map((pt: { id: string; text: string }) => ({ id: pt.id, text: pt.text })),
      }
    }
    for (const x of ex) {
      experiencesFull.value[x.id] = {
        title: x.title,
        company: x.company,
        startDate: x.startDate,
        endDate: x.endDate,
        description: x.description,
        experiencePoints: (x.experiencePoints ?? []).map((pt: { id: string; text: string }) => ({ id: pt.id, text: pt.text })),
      }
    }
  } catch (e) {
    console.error('Failed to load preview entity data', e)
  }
})

watch(() => result.value?.cv.pictureId, () => { pictureFailed.value = false })

const styleAccent = computed(() => {
  const style = result.value?.cv.style
  if (style === 'ats') return '#18181B'
  if (style === 'two-column-blue') return '#1D4ED8'
  return '#2563EB'
})

const pictureUrl = computed(() => {
  const pid = result.value?.cv.pictureId
  return pid ? `${API_BASE}/images/${pid}` : null
})

function initials(name: string): string {
  return name.trim().split(/\s+/).slice(0, 2).map(w => w[0]?.toUpperCase() ?? '').join('') || 'CV'
}

function clampLevel(level: number): number {
  return Math.max(0, Math.min(5, level ?? 0))
}

const previewSkills = computed(() => {
  const res = result.value
  const hard: { name: string; level: number; suggested: boolean }[] = []
  const soft: { name: string; level: number; suggested: boolean }[] = []
  if (!res) return { hard, soft }
  for (const id of res.cv.skillIds) {
    const s = skillsMap.value[id]
    if (!s) continue
    const target = s.cvCategory === 'soft' ? soft : hard
    target.push({ name: s.name, level: s.level, suggested: false })
  }
  for (const s of acceptedSkillSuggestions.value) {
    const target = s.cvCategory === 'soft' ? soft : hard
    target.push({ name: s.name, level: s.level, suggested: true })
  }
  return { hard, soft }
})

const previewProjects = computed(() => {
  const res = result.value
  if (!res) return []
  const selectedIds = new Set(res.cv.cvProjectPointIds || [])
  return res.cv.projectIds.map(id => {
    const p = projectsFull.value[id]
    const points = (p?.projectPoints ?? [])
      .filter(pt => selectedIds.has(pt.id))
      .map(pt => pt.text)
      .filter((t): t is string => Boolean(t))
    const extra = acceptedBulletSuggestions.value
      .filter(b => b.entityType === 'project' && b.entityId === id)
      .map(b => b.text)
    return { id, title: p?.title ?? id, description: p?.description, points, extra }
  })
})

const previewExperiences = computed(() => {
  const res = result.value
  if (!res) return []
  return res.cv.experienceIds.map(id => {
    const x = experiencesFull.value[id]
    const extra = acceptedBulletSuggestions.value
      .filter(b => b.entityType === 'experience' && b.entityId === id)
      .map(b => b.text)
    return {
      id,
      title: x?.title ?? id,
      company: x?.company,
      startDate: x?.startDate,
      endDate: x?.endDate,
      description: x?.description,
      extra,
    }
  })
})

const previewEducation = computed(() => {
  const res = result.value
  if (!res) return []
  return res.cv.educationIds.map(id => educationMap.value[id] ?? { title: id })
})

const previewLanguages = computed(() => {
  const res = result.value
  if (!res) return []
  return res.cv.languageIds.map(id => languagesMap.value[id] ?? { name: id, level: '' })
})

const previewPassions = computed(() => {
  const res = result.value
  if (!res) return []
  return res.cv.passionIds.map(id => passionsMap.value[id] ?? { name: id })
})

const previewCounts = computed(() => {
  const res = result.value
  if (!res) return { skills: 0, points: 0, accepted: 0 }
  const skills = res.cv.skillIds.length + acceptedSkillSuggestions.value.length
  const points =
    previewProjects.value.reduce((n, p) => n + p.points.length + p.extra.length, 0) +
    previewExperiences.value.reduce((n, x) => n + x.extra.length, 0)
  return { skills, points, accepted: acceptedCounts.value.skills + acceptedCounts.value.bullets }
})

const skillGroups = computed(() => {
  const res = result.value
  if (!res) return []
  return [
    { key: 'hard', label: 'Compétences techniques', items: res.suggestions.skills.filter(s => s.cvCategory === 'hard') },
    { key: 'soft', label: 'Soft skills', items: res.suggestions.skills.filter(s => s.cvCategory === 'soft') },
  ].filter(g => g.items.length)
})

const bulletGroups = computed(() => {
  const res = result.value
  if (!res) return []
  return [
    { key: 'project', label: 'Projets', items: res.suggestions.bullets.filter(b => b.entityType === 'project') },
    { key: 'experience', label: 'Expériences', items: res.suggestions.bullets.filter(b => b.entityType === 'experience') },
  ].filter(g => g.items.length)
})
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-8">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-heading font-bold">Générateur de CV par IA</h1>
        <p class="text-surface-500 mt-1">Décrivez le poste, l'IA construit un CV avec des suggestions.</p>
      </div>
      <button @click="router.push('/admin/cvs')"
        class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
        Back
      </button>
    </div>

    <!-- ═══ PHASE 1 : INPUT ═══ -->
    <div v-if="phase === 'input'" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <div class="lg:col-span-2 bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6">
        <label class="block text-sm font-medium mb-2">
          Description du poste <span class="text-accent">*</span>
        </label>
        <textarea v-model="jobDescription" rows="12" placeholder="Collez ici la description de l'offre d'emploi : missions, stack technique, soft skills recherchés…"
          class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none resize-y leading-relaxed" />
        <p class="text-xs text-surface-400 mt-1">Champ requis — plus la description est détaillée, meilleur est le résultat.</p>
        <p v-if="validationError" class="text-error text-sm mt-2">{{ validationError }}</p>

        <div class="mt-6">
          <label class="block text-sm font-medium mb-2">Instructions personnalisées</label>
          <input v-model="options.customInstructions" placeholder="Ex. : mettre en avant l'expérience Kubernetes, éviter les clichés…"
            class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
        </div>

        <div class="mt-6">
          <p class="text-sm font-medium mb-3">Options de génération</p>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label class="block text-xs text-surface-500 mb-1">Spécialisation</label>
              <select v-model="options.specialization"
                class="w-full px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none cursor-pointer">
                <option v-for="(label, val) in specializationLabels" :key="val" :value="val">{{ label }}</option>
              </select>
            </div>
            <div>
              <label class="block text-xs text-surface-500 mb-1">Style du CV</label>
              <select v-model="options.style"
                class="w-full px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none cursor-pointer">
                <option value="auto">Automatique</option>
                <option value="classic">Classique</option>
                <option value="ats">ATS</option>
                <option value="two-column-blue">Deux colonnes bleu</option>
              </select>
            </div>
            <div>
              <label class="block text-xs text-surface-500 mb-1">Longueur du « À propos »</label>
              <select v-model="options.aboutLength"
                class="w-full px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none cursor-pointer">
                <option v-for="(label, val) in aboutLengthLabels" :key="val" :value="val">{{ label }}</option>
              </select>
            </div>
            <div>
              <label class="block text-xs text-surface-500 mb-1">Ton</label>
              <select v-model="options.tone"
                class="w-full px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none cursor-pointer">
                <option v-for="(label, val) in toneLabels" :key="val" :value="val">{{ label }}</option>
              </select>
            </div>
            <div>
              <label class="block text-xs text-surface-500 mb-1">Max. expériences (1–10)</label>
              <input v-model.number="options.maxExperiences" type="number" min="1" max="10"
                class="w-full px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
            </div>
            <div>
              <label class="block text-xs text-surface-500 mb-1">Max. projets (1–10)</label>
              <input v-model.number="options.maxProjects" type="number" min="1" max="10"
                class="w-full px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 outline-none" />
            </div>
          </div>
          <div class="mt-4 grid grid-cols-1 sm:grid-cols-2 gap-3">
            <label class="flex items-center gap-2 text-sm cursor-pointer">
              <input v-model="options.includeSoftSkills" type="checkbox" class="w-4 h-4 accent-accent cursor-pointer rounded" />
              Inclure les soft skills
            </label>
            <label class="flex items-center gap-2 text-sm cursor-pointer">
              <input v-model="options.includeLanguages" type="checkbox" class="w-4 h-4 accent-accent cursor-pointer rounded" />
              Inclure les langues
            </label>
            <label class="flex items-center gap-2 text-sm cursor-pointer">
              <input v-model="options.allowSkillSuggestions" type="checkbox" class="w-4 h-4 accent-accent cursor-pointer rounded" />
              Proposer des compétences
            </label>
            <label class="flex items-center gap-2 text-sm cursor-pointer">
              <input v-model="options.allowBulletSuggestions" type="checkbox" class="w-4 h-4 accent-accent cursor-pointer rounded" />
              Proposer des points clés
            </label>
          </div>
        </div>
      </div>

      <div class="space-y-6">
        <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6">
          <p class="font-medium mb-3">Service IA</p>
          <div v-if="aiStatus && aiStatus.available" class="flex items-center gap-2 text-sm">
            <span class="w-2 h-2 rounded-full bg-success animate-pulse" />
            <span class="text-surface-600 dark:text-surface-400">Ollama disponible</span>
            <span class="ml-auto text-xs font-mono text-surface-400">{{ aiStatus.model }}</span>
          </div>
          <p v-else class="text-sm text-surface-500">Le statut du service sera vérifié à la génération.</p>
        </div>

        <div v-if="aiUnavailable" class="bg-error/10 border border-error/30 rounded-2xl p-6">
          <div class="flex items-start gap-3">
            <svg class="w-6 h-6 text-error flex-shrink-0 mt-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M12 9v4m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" />
            </svg>
            <div>
              <p class="font-medium text-sm">Ollama n'est pas disponible</p>
              <p class="text-sm text-surface-600 dark:text-surface-400 mt-1 leading-relaxed">
                Lancez <code class="font-mono text-xs bg-white/60 dark:bg-surface-800 px-1.5 py-0.5 rounded">docker compose up -d ollama</code>
                puis patientez le téléchargement du modèle.
              </p>
              <p v-if="aiStatus?.error" class="text-xs font-mono mt-2 text-surface-500">{{ aiStatus.error }}</p>
            </div>
          </div>
        </div>

        <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6">
          <p class="font-medium mb-2">Récapitulatif</p>
          <ul class="text-sm text-surface-500 space-y-1">
            <li>Spécialisation : <span class="text-surface-700 dark:text-surface-300">{{ specializationLabels[options.specialization] }}</span></li>
            <li>Style : <span class="text-surface-700 dark:text-surface-300">{{ options.style === 'auto' ? 'Automatique' : styleLabels[options.style] }}</span></li>
            <li>Max. expériences : <span class="text-surface-700 dark:text-surface-300">{{ options.maxExperiences }}</span></li>
            <li>Max. projets : <span class="text-surface-700 dark:text-surface-300">{{ options.maxProjects }}</span></li>
          </ul>
        </div>

        <button @click="generate" :disabled="generating"
          class="w-full px-6 py-3 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors disabled:opacity-60 cursor-pointer font-medium flex items-center justify-center gap-2">
          <svg v-if="!generating" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <path d="M13 10V3L4 14h7v7l9-11h-7z" />
          </svg>
          <span v-else class="w-4 h-4 border-2 border-white/40 border-t-white rounded-full animate-spin" />
          {{ generating ? 'Génération…' : 'Générer le CV' }}
        </button>
        <p v-if="generationError" class="text-error text-sm">{{ generationError }}</p>
      </div>
    </div>

    <!-- ═══ PHASE 2 : GENERATING ═══ -->
    <div v-else-if="phase === 'generating'" class="max-w-xl mx-auto bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-8">
      <div class="flex items-center gap-3 mb-6">
        <svg class="w-8 h-8 text-accent animate-pulse" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M12 2l2.4 7.4H22l-6 4.6 2.3 7.4-6.3-4.6L5.7 21l2.3-7.4-6-4.6h7.6L12 2z" />
        </svg>
        <div>
          <p class="font-heading font-semibold text-lg">Génération du CV en cours</p>
          <p class="text-sm text-surface-500">Analyse de l'offre et construction de votre profil.</p>
        </div>
      </div>
      <ol class="space-y-4">
        <li v-for="s in stageMeta" :key="s.key" class="flex items-center gap-3">
          <span v-if="isStageDone(s.key) || s.key === 'done'"
            class="w-6 h-6 rounded-full bg-success text-white flex items-center justify-center text-xs flex-shrink-0">
            <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 13l4 4L19 7" /></svg>
          </span>
          <span v-else-if="isStageActive(s.key)"
            class="w-6 h-6 rounded-full border-2 border-accent/30 border-t-accent animate-spin flex-shrink-0" />
          <span v-else class="w-6 h-6 rounded-full border-2 border-gray-200 dark:border-surface-700 flex-shrink-0" />
          <div>
            <p class="text-sm font-medium" :class="isStageDone(s.key) || isStageActive(s.key) ? 'text-surface-700 dark:text-surface-200' : 'text-surface-400'">{{ s.label }}</p>
            <p class="text-xs text-surface-400">{{ s.detail }}</p>
          </div>
        </li>
      </ol>
    </div>

    <!-- ═══ PHASE 3 : RESULT ═══ -->
    <div v-else-if="phase === 'result' && result" class="space-y-6">
      <div v-if="saved" class="bg-success/10 border border-success/30 rounded-2xl p-4 flex items-center gap-3">
        <svg class="w-5 h-5 text-success flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M5 13l4 4L19 7" />
        </svg>
        <p class="text-sm font-medium">CV enregistré — redirection vers l'édition…</p>
      </div>

      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-4 flex flex-wrap items-center gap-x-6 gap-y-3">
        <div class="flex items-center gap-5">
          <div>
            <p class="text-2xl font-heading font-bold text-accent leading-none">{{ previewCounts.skills }}</p>
            <p class="text-xs text-surface-500 mt-1">compétences</p>
          </div>
          <div class="w-px h-9 bg-gray-200 dark:bg-surface-700" />
          <div>
            <p class="text-2xl font-heading font-bold leading-none">{{ previewCounts.points }}</p>
            <p class="text-xs text-surface-500 mt-1">points clés</p>
          </div>
          <div class="w-px h-9 bg-gray-200 dark:bg-surface-700" />
          <div>
            <p class="text-2xl font-heading font-bold text-success leading-none">{{ previewCounts.accepted }}</p>
            <p class="text-xs text-surface-500 mt-1">suggestions acceptées</p>
          </div>
        </div>
        <div class="ml-auto flex flex-wrap items-center gap-2">
          <button @click="router.push('/admin/cvs')"
            class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer text-sm">
            Annuler
          </button>
          <button @click="regenerate" :disabled="generating"
            class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer text-sm disabled:opacity-50">
            {{ generating ? 'Régénération…' : 'Régénérer' }}
          </button>
          <button @click="save" :disabled="saving"
            class="px-4 py-2 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer text-sm disabled:opacity-50 font-medium">
            {{ saving ? 'Enregistrement…' : 'Enregistrer le CV' }}
          </button>
        </div>
        <p v-if="saveError" class="w-full text-error text-sm">{{ saveError }}</p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
        <div class="lg:col-span-2 bg-white dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 overflow-hidden shadow-sm relative">
          <div v-if="result.cv.style === 'two-column-blue'" class="absolute inset-y-0 left-0 w-1.5" :style="{ background: styleAccent }" />
          <div class="p-6 flex items-center gap-5" :style="{ background: styleAccent }">
            <img v-if="pictureUrl && !pictureFailed" :src="pictureUrl" @error="pictureFailed = true"
              class="w-16 h-16 rounded-full object-cover ring-2 ring-white/70 flex-shrink-0" alt="Photo de profil" />
            <div v-else
              class="w-16 h-16 rounded-full bg-white/20 ring-2 ring-white/70 flex items-center justify-center text-white font-heading font-bold text-xl flex-shrink-0">
              {{ initials(result.cv.candidateName || result.cv.name) }}
            </div>
            <div class="min-w-0">
              <h2 class="text-2xl font-heading font-bold text-white truncate">{{ result.cv.candidateName || result.cv.name }}</h2>
              <div class="flex flex-wrap items-center gap-2 mt-1.5">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-white/20 text-white text-xs font-medium">
                  {{ result.cv.titleOverride || result.cv.specialization || 'Professionnel' }}
                </span>
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-white/10 text-white/90 text-xs border border-white/30">
                  {{ styleLabels[result.cv.style] }}
                </span>
              </div>
              <p v-if="result.cv.availability" class="text-sm text-white/90 mt-1.5">
                <span class="opacity-80">Disponibilité :</span>
                <span class="font-medium">{{ result.cv.availability }}</span>
              </p>
            </div>
          </div>

          <div class="p-6 space-y-6">
            <section>
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-2" :style="{ color: styleAccent }">À propos</h3>
              <p v-if="result.cv.aboutText" class="text-sm text-surface-600 dark:text-surface-300 leading-relaxed">{{ excerpt(result.cv.aboutText, 320) }}</p>
              <p v-else class="text-sm text-surface-400">Aucun texte généré.</p>
            </section>

            <section v-if="previewSkills.hard.length || previewSkills.soft.length">
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-3" :style="{ color: styleAccent }">Compétences</h3>
              <div v-if="previewSkills.hard.length" class="mb-3">
                <p class="text-xs text-surface-400 mb-1.5">Techniques</p>
                <div class="flex flex-wrap gap-2">
                  <span v-for="s in previewSkills.hard" :key="s.name + (s.suggested ? '-ia' : '')"
                    class="inline-flex items-center gap-2 px-2.5 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800 text-xs">
                    {{ s.name }}
                    <span class="w-10 h-1 rounded-full bg-gray-200 dark:bg-surface-700 overflow-hidden">
                      <span class="block h-full rounded-full" :style="{ width: `${clampLevel(s.level) * 20}%`, background: styleAccent }" />
                    </span>
                    <span v-if="s.suggested" class="text-[9px] font-bold px-1 py-px rounded bg-accent/10 text-accent">IA</span>
                  </span>
                </div>
              </div>
              <div v-if="previewSkills.soft.length">
                <p class="text-xs text-surface-400 mb-1.5">Soft skills</p>
                <div class="flex flex-wrap gap-2">
                  <span v-for="s in previewSkills.soft" :key="s.name + (s.suggested ? '-ia' : '')"
                    class="inline-flex items-center gap-2 px-2.5 py-1.5 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800 text-xs">
                    {{ s.name }}
                    <span v-if="s.suggested" class="text-[9px] font-bold px-1 py-px rounded bg-accent/10 text-accent">IA</span>
                  </span>
                </div>
              </div>
            </section>

            <section v-if="previewExperiences.length">
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-3" :style="{ color: styleAccent }">Expériences</h3>
              <div v-for="x in previewExperiences" :key="x.id" class="mb-4 last:mb-0">
                <div class="flex items-baseline justify-between gap-3">
                  <p class="font-medium text-sm">{{ x.title }}<span v-if="x.company" class="text-surface-500 font-normal"> · {{ x.company }}</span></p>
                  <p v-if="x.startDate || x.endDate" class="text-xs text-surface-400 whitespace-nowrap">{{ x.startDate }} – {{ x.endDate }}</p>
                </div>
                <p v-if="x.description" class="text-xs text-surface-500 mt-1 leading-relaxed">{{ excerpt(x.description) }}</p>
                <ul v-if="x.extra.length" class="mt-1.5 space-y-1">
                  <li v-for="(t, i) in x.extra" :key="i" class="flex items-start gap-1.5 text-xs text-surface-600 dark:text-surface-300">
                    <span class="text-accent mt-0.5">•</span>
                    <span>{{ t }}</span>
                    <span class="text-[9px] font-bold px-1 py-px rounded bg-accent/10 text-accent whitespace-nowrap">IA</span>
                  </li>
                </ul>
              </div>
            </section>

            <section v-if="previewProjects.length">
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-3" :style="{ color: styleAccent }">Projets</h3>
              <div v-for="p in previewProjects" :key="p.id" class="mb-4 last:mb-0">
                <p class="font-medium text-sm">{{ p.title }}</p>
                <p v-if="p.description" class="text-xs text-surface-500 mt-0.5 leading-relaxed">{{ excerpt(p.description) }}</p>
                <ul v-if="p.points.length || p.extra.length" class="mt-1.5 space-y-1">
                  <li v-for="(t, i) in p.points" :key="'b' + i" class="flex items-start gap-1.5 text-xs text-surface-600 dark:text-surface-300">
                    <span class="text-accent mt-0.5">•</span>
                    <span>{{ t }}</span>
                  </li>
                  <li v-for="(t, i) in p.extra" :key="'ia' + i" class="flex items-start gap-1.5 text-xs text-surface-600 dark:text-surface-300">
                    <span class="text-accent mt-0.5">•</span>
                    <span>{{ t }}</span>
                    <span class="text-[9px] font-bold px-1 py-px rounded bg-accent/10 text-accent whitespace-nowrap">IA</span>
                  </li>
                </ul>
                <p v-else class="text-xs text-surface-400 mt-1">Aucun point clé sélectionné.</p>
              </div>
            </section>

            <section v-if="previewEducation.length">
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-3" :style="{ color: styleAccent }">Formations</h3>
              <div v-for="(e, i) in previewEducation" :key="i" class="mb-2 last:mb-0">
                <p class="text-sm font-medium">{{ e.title }}<span v-if="e.school" class="text-surface-500 font-normal"> · {{ e.school }}</span></p>
                <p v-if="e.date || e.startDate || e.endDate" class="text-xs text-surface-400">{{ e.date || `${e.startDate} – ${e.endDate}` }}</p>
              </div>
            </section>

            <section v-if="previewLanguages.length">
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-3" :style="{ color: styleAccent }">Langues</h3>
              <div class="flex flex-wrap gap-2">
                <span v-for="(l, i) in previewLanguages" :key="i"
                  class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800 text-xs">
                  {{ l.name }}<span v-if="l.level" class="text-surface-400">{{ l.level }}</span>
                </span>
              </div>
            </section>

            <section v-if="previewPassions.length">
              <h3 class="text-xs uppercase tracking-wider font-semibold mb-3" :style="{ color: styleAccent }">Passions</h3>
              <div class="flex flex-wrap gap-2">
                <span v-for="(p, i) in previewPassions" :key="i"
                  class="px-2.5 py-1 rounded-lg border border-gray-200 dark:border-surface-700 bg-surface-50 dark:bg-surface-800 text-xs">
                  {{ p.name }}
                </span>
              </div>
            </section>
          </div>
        </div>

        <div class="space-y-6">
          <div v-if="skillGroups.length" class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
            <div class="flex items-center justify-between mb-4">
              <h3 class="font-heading font-semibold">Compétences proposées</h3>
              <span class="text-xs font-mono text-surface-400">{{ acceptedCounts.skills }}/{{ result.suggestions.skills.length }}</span>
            </div>
            <div v-for="g in skillGroups" :key="g.key" class="mb-4 last:mb-0">
              <p class="text-[10px] uppercase tracking-wider text-surface-400 font-medium mb-2">{{ g.label }}</p>
              <div class="space-y-2">
                <div v-for="s in g.items" :key="s.id"
                  class="rounded-xl border p-3 transition-colors"
                  :class="isSkillAccepted(s.id)
                    ? 'border-gray-200 dark:border-surface-700'
                    : 'border-gray-200 dark:border-surface-700 opacity-50'">
                  <div class="flex items-start gap-3">
                    <button @click="skillAccepts[s.id] = !isSkillAccepted(s.id)"
                      class="mt-0.5 w-10 h-6 rounded-full transition-colors relative flex-shrink-0 cursor-pointer"
                      :class="isSkillAccepted(s.id) ? 'bg-accent' : 'bg-gray-300 dark:bg-surface-700'">
                      <span class="absolute top-0.5 w-5 h-5 rounded-full bg-white shadow transition-all"
                        :class="isSkillAccepted(s.id) ? 'left-[18px]' : 'left-0.5'" />
                    </button>
                    <div class="flex-1 min-w-0">
                      <div class="flex items-center gap-2 flex-wrap">
                        <p class="font-medium text-sm">{{ s.name }}</p>
                        <span v-if="s.categoryName" class="text-[10px] px-2 py-0.5 rounded-full bg-surface-100 dark:bg-surface-800 border border-gray-200 dark:border-surface-700 text-surface-500">
                          {{ s.categoryName }}
                        </span>
                        <span class="text-[10px] font-mono text-surface-400">{{ s.level }}/5</span>
                      </div>
                      <p v-if="s.description" class="text-xs text-surface-500 mt-1">{{ s.description }}</p>
                      <p class="text-xs text-surface-400 mt-1 italic">« {{ s.rationale }} »</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div v-if="bulletGroups.length" class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
            <div class="flex items-center justify-between mb-4">
              <h3 class="font-heading font-semibold">Points clés proposés</h3>
              <span class="text-xs font-mono text-surface-400">{{ acceptedCounts.bullets }}/{{ result.suggestions.bullets.length }}</span>
            </div>
            <div v-for="g in bulletGroups" :key="g.key" class="mb-4 last:mb-0">
              <p class="text-[10px] uppercase tracking-wider text-surface-400 font-medium mb-2">{{ g.label }}</p>
              <div class="space-y-2">
                <div v-for="b in g.items" :key="b.id"
                  class="rounded-xl border p-3 transition-colors"
                  :class="isBulletAccepted(b.id)
                    ? 'border-gray-200 dark:border-surface-700'
                    : 'border-gray-200 dark:border-surface-700 opacity-50'">
                  <div class="flex items-start gap-3">
                    <button @click="bulletAccepts[b.id] = !isBulletAccepted(b.id)"
                      class="mt-0.5 w-10 h-6 rounded-full transition-colors relative flex-shrink-0 cursor-pointer"
                      :class="isBulletAccepted(b.id) ? 'bg-accent' : 'bg-gray-300 dark:bg-surface-700'">
                      <span class="absolute top-0.5 w-5 h-5 rounded-full bg-white shadow transition-all"
                        :class="isBulletAccepted(b.id) ? 'left-[18px]' : 'left-0.5'" />
                    </button>
                    <div class="flex-1 min-w-0">
                      <p class="text-xs font-medium text-surface-500">{{ entityTitle(b) }}</p>
                      <p class="text-sm mt-1">{{ b.text }}</p>
                      <div v-if="b.skillIds.length" class="mt-2">
                        <p class="text-[10px] uppercase tracking-wider text-surface-400 font-medium mb-1.5">Soft skills liés</p>
                        <div class="flex flex-wrap gap-1.5">
                          <button v-for="sid in b.skillIds" :key="sid" @click="toggleChip(b.id, sid)"
                            class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[11px] font-medium transition-colors cursor-pointer"
                            :class="isChipOn(b.id, sid)
                              ? 'bg-purple-500/10 text-purple-500 border border-purple-500/30'
                              : 'bg-surface-100 dark:bg-surface-800 text-surface-400 border border-gray-200 dark:border-surface-700 line-through'">
                            {{ skillName(sid) }}
                          </button>
                        </div>
                      </div>
                      <p class="text-xs text-surface-400 mt-2 italic">« {{ b.rationale }} »</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div v-if="result.justification" class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
            <h3 class="font-heading font-semibold mb-2">Justification</h3>
            <p class="text-sm text-surface-500 leading-relaxed">{{ result.justification }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
