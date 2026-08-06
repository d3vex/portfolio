<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import * as api from '@/lib/api/cv'
import type { CvStyle, CvStyleId } from '@/lib/types'
import cvStyleCss from '@/../../CV/style.css?raw'

const route = useRoute()
const router = useRouter()
const cv = ref<any>(null)
const skills = ref<any[]>([])
const languages = ref<any[]>([])
const passions = ref<any[]>([])
const experiences = ref<any[]>([])
const projects = ref<any[]>([])
const education = ref<any[]>([])
const contacts = ref<any[]>([])
const loading = ref(true)
const cvStyles = ref<CvStyle[]>([])
const chosenStyle = ref<CvStyleId>('classic')
const exporting = ref(false)
const exportError = ref('')

const linkedData = computed(() => {
  if (!cv.value) return { skills: [], languages: [], passions: [], experiences: [], projects: [], education: [], contacts: [] }
  const cvIds = (key: string) => (cv.value?.[key] || []).map((e: any) => e.id)
  // The backend returns cv.skills/cv.projects/cv.passions already ordered per-CV
  // (junction order). Prefer those payload arrays; fall back to id-based filtering
  // of the global lists when the payload array is empty (stale cached CVs).
  const payloadOrdered = (key: 'skills' | 'projects' | 'passions'): any[] | null => {
    const arr = cv.value?.[key]
    return Array.isArray(arr) && arr.length > 0 ? arr : null
  }
  const orderedSkills = payloadOrdered('skills')
  const orderedPassions = payloadOrdered('passions')
  const orderedProjects = payloadOrdered('projects')
  const selectedProjects = orderedProjects ?? projects.value.filter(p => cvIds('projects').includes(p.id))
  const selectedEducation = education.value.filter(e => cvIds('education').includes(e.id))
  return {
    skills: orderedSkills ?? skills.value.filter(s => cvIds('skills').includes(s.id)),
    languages: languages.value.filter(l => cvIds('languages').includes(l.id)),
    passions: orderedPassions ?? passions.value.filter(p => cvIds('passions').includes(p.id)),
    experiences: experiences.value.filter(e => cvIds('experiences').includes(e.id)),
    projects: selectedProjects,
    education: selectedEducation.map(e => ({
      ...e,
      linkedProjects: selectedProjects.filter(p => p.educationId === e.id),
    })),
    contacts: contacts.value.filter(c => cvIds('contacts').includes(c.id)),
  }
})

const softSkills = computed(() => linkedData.value.skills.filter(s => s.cvCategory === 'soft'))
const hardSkills = computed(() => linkedData.value.skills.filter(s => s.cvCategory === 'hard'))

const chosenStyleMeta = computed<CvStyle | undefined>(() =>
  cvStyles.value.find(s => s.id === chosenStyle.value)
)

const cvContainerStyle = computed<Record<string, string>>(() => {
  const meta = chosenStyleMeta.value
  return {
    '--accent': meta?.accent || '#2563EB',
    // Backend classic style.css defaults --accent-light to #3B82F6; the style
    // registry does not expose accent-light, so keep the default instead of
    // falling back to --accent (#2563EB) which darkens sidebar headings.
    '--accent-light': '#3B82F6',
    '--sidebar-bg': meta?.sidebar || '#18181B',
  }
})

onMounted(async () => {
  try {
    const [c, sk, la, pa, ex, pr, ed, co] = await Promise.all([
      api.getCv(route.params.id as string),
      api.getSkills(),
      api.getLanguages(),
      api.getPassions(),
      api.getExperiences(),
      api.getProjects(),
      api.getEducation(),
      api.getContacts(),
    ])
    cv.value = c
    chosenStyle.value = c.style || 'classic'
    skills.value = sk
    languages.value = la
    passions.value = pa
    experiences.value = ex
    projects.value = pr
    education.value = ed
    contacts.value = co
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
  try {
    cvStyles.value = await api.getCvStyles()
  } catch (e) {
    console.error('Failed to load CV styles', e)
  }
})

function iconUrl(icon: string, color?: string): string {
  if (!icon) return ''
  const [prefix, name] = icon.split(':')
  let url = `https://api.iconify.design/${prefix}/${name}.svg?height=16`
  if (color) url += `&color=${encodeURIComponent(color)}`
  return url
}

function formatAboutHtml(text: string): string {
  return text.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>').replace(/\n/g, '<br>')
}

function formatDate(d: string | null | undefined): string {
  if (!d) return ''
  try {
    return new Intl.DateTimeFormat('fr-FR', { month: 'short', year: 'numeric' }).format(new Date(d))
  } catch {
    return d
  }
}

function es(str: string | null | undefined): string {
  if (str == null) return ''
  return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')
}

function buildPrintHtml(): string {
  const c = cv.value
  if (!c) return ''

  const skillMap: Record<string, any> = {}
  skills.value.forEach(s => { skillMap[s.id] = s })

  function skillN(ids: string[] | undefined): string {
    if (!ids?.length) return ''
    return ids.map(id => skillMap[id]?.name).filter(Boolean).join(', ')
  }

  function pts(entity: any, key: string): any[] {
    return entity?.[key] || []
  }

  function desc(d: any): string {
    return d.text || d || ''
  }

  const personName = c.candidateName || c.name
  const initials = personName ? personName.split(/\s+/).map((s: string) => s[0]).join('').slice(0, 2).toUpperCase() : 'LM'
  const picPrintUrl = c.pictureId ? `http://localhost:3001/api/images/${c.pictureId}` : null
  const photoHtml = picPrintUrl
    ? `<img src="${es(picPrintUrl)}" alt="" style="width:100%;height:100%;object-fit:cover;transform:scale(${pictureZoom.value})">`
    : `<span class="photo-initials">${initials}</span>`
  const contactHtml = linkedData.value.contacts.map(c => {
    const v = c.value || ''
    const display = v.replace(/^https?:\/\//, '').replace(/\/$/, '')
    let link = ''
    if (c.type === 'link') {
      const href = v.startsWith('http') ? v : 'https://' + v
      link = `<a href="${es(href)}" target="_blank">${es(display)}</a>`
    } else {
      link = `<span>${es(display)}</span>`
    }
    return `<div class="contact-item">${c.icon ? `<img src="${iconUrl(c.icon, '#E4E4E7')}" width="16" height="16" alt="">` : ''}${link}</div>`
  }).join('\n      ')

  const hardSkillsHtml = linkedData.value.skills.filter(s => s.cvCategory === 'hard').map(s =>
    `<span class="skill-tag">${s.icon ? `<img src="${iconUrl(s.icon, '#3B82F6')}" width="16" height="16" alt="">` : ''}${es(s.name)}</span>`
  ).join('\n        ')

  const softSkillsHtml = linkedData.value.skills.filter(s => s.cvCategory === 'soft').map(s =>
    `<div class="soft-skill-item"><span class="soft-skill-dot"></span><div><span class="soft-skill-name">${es(s.name)}</span>${s.description ? `<span class="soft-skill-desc">${es(s.description)}</span>` : ''}</div></div>`
  ).join('\n      ')

  const langHtml = linkedData.value.languages.map(l =>
    `<div class="lang-item"><span>${es(l.name)}</span><span class="lang-level">${es(l.level)}</span></div>`
  ).join('\n      ')

  const passionHtml = linkedData.value.passions.map(p =>
    `<div class="passion-item">${p.icon ? `<img src="${iconUrl(p.icon, '#3B82F6')}" width="16" height="16" alt="">` : ''}<div><span class="passion-name">${es(p.name)}</span>${p.description ? `<span class="passion-desc">${es(p.description)}</span>` : ''}</div></div>`
  ).join('\n      ')

  const aboutHtml = c.aboutText ? formatAboutHtml(c.aboutText) : ''
  const aboutSection = aboutHtml ? `<section><h2>À Propos</h2><div class="about-text"><p>${aboutHtml}</p></div></section>` : ''

  const expHtml = linkedData.value.experiences.map(exp => {
    const items = pts(exp, 'experiencePoints').map((d: any) => {
      const txt = desc(d)
      const ref = d.skillIds?.length ? ` <span class="skill-ref">— ${skillN(d.skillIds)}</span>` : ''
      return `<li>${es(txt)}${ref}</li>`
    }).join('\n            ')
    const companyLink = exp.companyUrl
      ? `${es(exp.company)} <a href="${es(exp.companyUrl)}" target="_blank" class="exp-link">${es(new URL(exp.companyUrl).hostname)}</a>`
      : es(exp.company)
    const loc = exp.location ? `<p class="exp-place">${es(exp.location)}</p>` : ''
    return `<div class="experience-item"><div class="exp-header"><div><div class="exp-title">${es(exp.title)}</div><div class="exp-subtitle">${companyLink}</div></div><span class="exp-date">${es(formatDate(exp.startDate))} - ${es(formatDate(exp.endDate))}</span></div>${loc}${items ? `<ul class="exp-desc">${items}</ul>` : ''}</div>`
  }).join('\n      ')

  const projHtml = linkedData.value.projects.map(proj => {
    const pBullets = (() => {
      const map = c.projectBullets
      if (!map) return pts(proj, 'projectPoints')
      const sel = map[proj.id]
      if (sel === undefined) return pts(proj, 'projectPoints')
      return pts(proj, 'projectPoints').filter((_: any, i: number) => sel.includes(i))
    })()
    const items = pBullets.map((d: any) => {
      const txt = desc(d)
      const ref = d.skillIds?.length ? ` <span class="skill-ref">— ${skillN(d.skillIds)}</span>` : ''
      return `<li>${es(txt)}${ref}</li>`
    }).join('\n            ')
    const subParts: string[] = []
    if (proj.subtitle) subParts.push(`<span>${es(proj.subtitle)}</span>`)
    if (proj.liveUrl) subParts.push(`<a href="${es(proj.liveUrl)}" target="_blank" class="exp-link">Live</a>`)
    if (proj.sourceUrl) subParts.push(`<a href="${es(proj.sourceUrl)}" target="_blank" class="exp-link">Source</a>`)
    const sub = subParts.length ? `<div class="exp-subtitle">${subParts.join(' ')}</div>` : ''
    return `<div class="project-item"><div class="exp-header"><div><div class="exp-title">${es(proj.title)}</div>${sub}</div><span class="exp-date">${es(formatDate(proj.startDate))} - ${es(formatDate(proj.endDate))}</span></div>${items ? `<ul class="exp-desc">${items}</ul>` : ''}</div>`
  }).join('\n      ')

  const eduHtml = linkedData.value.education.map(edu =>
    `<div class="education-item"><div><div class="edu-title">${es(edu.title)}</div><div class="edu-school">${es(edu.school)} ${edu.school && edu.startDate ? '· ' : ''}${es(formatDate(edu.startDate || edu.date))} - ${es(formatDate(edu.endDate))}</div></div><span class="edu-date">${es(formatDate(edu.startDate || edu.date))} - ${es(formatDate(edu.endDate))}</span></div>`
  ).join('\n      ')

  const personNamePrint = c.candidateName || c.name
  return `<!DOCTYPE html><html lang="fr"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${es(personNamePrint || 'CV')}</title><link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Archivo:wght@400;500;600;700;800&family=Space+Grotesk:wght@300;400;500;600;700&display=swap" rel="stylesheet"><style>${cvStyleCss}</style></head><body><div class="cv-container"><aside class="sidebar"><div><div class="photo-placeholder">${photoHtml}</div><h1>${es(personNamePrint)}</h1><span class="title-badge">${es(c.titleOverride || c.specialization || 'Professional')}</span>${c.availability ? `<span class="availability-badge">${es(c.availability)}</span>` : ''}</div>${linkedData.value.contacts.length ? `<div><h2>Contact</h2>${contactHtml}</div>` : ''}${hardSkillsHtml ? `<div><h2>Hard Skills</h2><div class="skills-grid">${hardSkillsHtml}</div></div>` : ''}${softSkillsHtml ? `<div><h2>Soft Skills</h2>${softSkillsHtml}</div>` : ''}${langHtml ? `<div><h2>Langues</h2>${langHtml}</div>` : ''}${passionHtml ? `<div><h2>Passions</h2>${passionHtml}</div>` : ''}</aside><main class="main">${aboutSection}${expHtml ? `<section><h2>Expériences Professionnelles</h2>${expHtml}</section>` : ''}${projHtml ? `<section><h2>Projets</h2>${projHtml}</section>` : ''}${eduHtml ? `<section><h2>Formation</h2>${eduHtml}</section>` : ''}</main></div></body></html>`
}

async function printCv() {
  let html: string
  try {
    if (cv.value?.id && chosenStyle.value) {
      html = await api.getCvHtml(cv.value.id, chosenStyle.value)
    } else {
      html = buildPrintHtml()
    }
  } catch (e) {
    console.error('Backend render fetch failed, falling back to local print HTML', e)
    html = buildPrintHtml()
  }
  const iframe = document.createElement('iframe')
  iframe.style.position = 'fixed'
  iframe.style.top = '0'
  iframe.style.left = '0'
  iframe.style.width = '0'
  iframe.style.height = '0'
  iframe.style.border = 'none'
  document.body.appendChild(iframe)

  const doc = iframe.contentDocument!
  doc.open()
  doc.write(html)
  doc.close()

  doc.fonts.ready.then(() => {
    iframe.contentWindow!.focus()
    iframe.contentWindow!.print()
  })
  setTimeout(() => {
    document.body.removeChild(iframe)
  }, 500)
}

async function exportPdf() {
  if (!cv.value) return
  exporting.value = true
  exportError.value = ''
  try {
    await api.exportCvPdf(cv.value.id, chosenStyle.value)
  } catch (e) {
    exportError.value = e instanceof Error ? e.message : 'Export failed'
  } finally {
    exporting.value = false
  }
}

function descriptionText(d: any): string {
  return d.text || d
}

function skillNamesByIds(ids: string[] | undefined): string[] {
  if (!ids?.length) return []
  return ids.map(id => skills.value.find(s => s.id === id)?.name).filter(Boolean)
}

function formatAbout(text: string): string {
  if (!text) return ''
  let html = text.replace(/\n/g, '<br>')
  html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
  return html
}

function nameInitials(): string {
  const n = cv.value?.candidateName || cv.value?.name
  return n ? n.split(/\s+/).map((s: string) => s[0]).join('').slice(0, 2).toUpperCase() : 'LM'
}

const picUrl = computed(() => {
  if (!cv.value?.pictureId) return null
  return `http://localhost:3001/api/images/${cv.value.pictureId}`
})

const atsRenderUrl = computed(() => (cv.value?.id ? api.getCvRenderUrl(cv.value.id, 'ats') : ''))

const pictureZoom = ref(1)

function zoomIn() { pictureZoom.value = Math.min(2, Number((pictureZoom.value + 0.1).toFixed(1))) }
function zoomOut() { pictureZoom.value = Math.max(0.5, Number((pictureZoom.value - 0.1).toFixed(1))) }

const picStyle = computed(() => ({
  transform: `scale(${pictureZoom.value})`,
}))

function selectedProjectPoints(proj: any): any[] {
  const map = cv.value?.projectBullets
  if (!map) return proj.projectPoints || []
  const selected = map[proj.id]
  if (selected === undefined) return proj.projectPoints || []
  return (proj.projectPoints || []).filter((_: any, i: number) => selected.includes(i))
}

function hostname(url: string): string {
  try { return new URL(url).hostname } catch { return url }
}
</script>

<template>
  <div class="no-print flex items-center justify-between px-4 py-4 max-w-[1240px] mx-auto print:hidden">
    <button @click="router.push('/admin/cvs')"
      class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer text-sm">
      &larr; Back
    </button>
    <div class="flex items-center gap-2">
      <select v-model="chosenStyle" aria-label="CV Style"
        class="px-3 py-2 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 text-sm focus:ring-2 focus:ring-accent/50 outline-none cursor-pointer">
        <option v-for="s in cvStyles" :key="s.id" :value="s.id">{{ s.name }}</option>
      </select>
      <button @click="exportPdf" :disabled="exporting"
        class="px-4 py-2 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer text-sm disabled:opacity-50">
        {{ exporting ? 'Exporting…' : 'Export PDF' }}
      </button>
      <button @click="printCv"
        class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer text-sm">
        Print
      </button>
    </div>
  </div>

  <p v-if="exportError" class="no-print text-center text-sm text-red-500 print:hidden">{{ exportError }}</p>

  <div v-if="loading" class="text-center py-12 text-surface-500">Loading...</div>

  <div v-else-if="cv">
      <!-- ══ ATS layout — live backend render (single source of truth for preview & print) ══ -->
      <div v-if="chosenStyle === 'ats'" class="ats-frame">
        <iframe class="ats-iframe" :src="atsRenderUrl" title="ATS preview"></iframe>
      </div>

      <!-- ══ Two-Column Blue layout ══ -->
      <div v-else-if="chosenStyle === 'two-column-blue'" class="tc-container">
        <aside class="tc-sidebar">
          <div>
            <div class="tc-photo">
              <img v-if="picUrl" :src="picUrl" :style="picStyle" :alt="nameInitials()" />
              <span v-else class="tc-initials">{{ nameInitials() }}</span>
            </div>
            <div v-if="picUrl" class="tc-zoom-row">
              <button @click="zoomOut" class="tc-zoom-btn" :disabled="pictureZoom <= 0.5">&minus;</button>
              <span class="text-[10px] font-mono text-surface-400">{{ (pictureZoom * 100).toFixed(0) }}%</span>
              <button @click="zoomIn" class="tc-zoom-btn" :disabled="pictureZoom >= 2">&plus;</button>
            </div>
            <h1>{{ cv.candidateName || cv.name }}</h1>
            <span class="tc-badge">{{ cv.titleOverride || cv.specialization || 'Professional' }}</span>
            <div v-if="cv.availability" class="tc-availability">{{ cv.availability }}</div>
          </div>

          <section v-if="linkedData.contacts.length">
            <h2>Contact</h2>
            <div v-for="c in linkedData.contacts" :key="c.id" class="tc-contact">
              <Icon v-if="c.icon" :icon="c.icon" class="w-4 h-4 flex-shrink-0" />
              <a v-if="c.type === 'link'" :href="c.value.startsWith('http') ? c.value : 'https://' + c.value" target="_blank">
                {{ c.value.replace(/^https?:\/\//, '').replace(/\/$/, '') }}
              </a>
              <span v-else>{{ c.value }}</span>
            </div>
          </section>

          <section v-if="hardSkills.length">
            <h2>Skills</h2>
            <div class="tc-skill-grid">
              <span v-for="s in hardSkills" :key="s.id" class="tc-skill">{{ s.name }}</span>
            </div>
          </section>

          <section v-if="softSkills.length">
            <h2>Soft Skills</h2>
            <div v-for="s in softSkills" :key="s.id" class="tc-soft">
              <span class="tc-soft-name">{{ s.name }}</span>
              <span v-if="s.description" class="tc-soft-desc">{{ s.description }}</span>
            </div>
          </section>

          <section v-if="linkedData.languages.length">
            <h2>Languages</h2>
            <div v-for="l in linkedData.languages" :key="l.id" class="tc-lang">
              <span>{{ l.name }}</span>
              <span class="tc-lang-level">{{ l.level }}</span>
            </div>
          </section>

          <section v-if="linkedData.passions.length">
            <h2>Passions</h2>
            <div v-for="p in linkedData.passions" :key="p.id" class="tc-passion">
              <Icon v-if="p.icon" :icon="p.icon" class="w-4 h-4" />
              <span>{{ p.name }}</span>
            </div>
          </section>
        </aside>

        <main class="tc-main">
          <section v-if="cv.aboutText">
            <h2>About</h2>
            <div class="tc-about" v-html="formatAbout(cv.aboutText)" />
          </section>

          <section v-if="linkedData.experiences.length">
            <h2>Experience</h2>
            <div v-for="exp in linkedData.experiences" :key="exp.id" class="tc-item">
              <div class="tc-item-head">
                <div>
                  <div class="tc-item-title">{{ exp.title }}</div>
                  <div class="tc-item-sub">
                    {{ exp.company }}
                    <template v-if="exp.companyUrl"> · <a :href="exp.companyUrl" target="_blank">{{ hostname(exp.companyUrl) }}</a></template>
                    <template v-if="exp.location"> · {{ exp.location }}</template>
                  </div>
                </div>
                <span class="tc-item-date">{{ formatDate(exp.startDate) }} – {{ formatDate(exp.endDate) }}</span>
              </div>
              <ul v-if="exp.experiencePoints?.length" class="tc-item-list">
                <li v-for="(d, i) in exp.experiencePoints" :key="i">
                  {{ descriptionText(d) }}
                  <span v-if="d.skillIds?.length" class="tc-skill-ref">— {{ skillNamesByIds(d.skillIds).join(', ') }}</span>
                </li>
              </ul>
            </div>
          </section>

          <section v-if="linkedData.projects.length">
            <h2>Projects</h2>
            <div v-for="proj in linkedData.projects" :key="proj.id" class="tc-item">
              <div class="tc-item-head">
                <div>
                  <div class="tc-item-title">{{ proj.title }}</div>
                  <div class="tc-item-sub">
                    <span v-if="proj.subtitle">{{ proj.subtitle }}</span>
                    <a v-if="proj.liveUrl" :href="proj.liveUrl" target="_blank"> · Live</a>
                    <a v-if="proj.sourceUrl" :href="proj.sourceUrl" target="_blank"> · Source</a>
                  </div>
                </div>
                <span class="tc-item-date">{{ formatDate(proj.startDate) }} – {{ formatDate(proj.endDate) }}</span>
              </div>
              <ul v-if="selectedProjectPoints(proj).length" class="tc-item-list">
                <li v-for="(d, i) in selectedProjectPoints(proj)" :key="i">
                  {{ descriptionText(d) }}
                  <span v-if="d.skillIds?.length" class="tc-skill-ref">— {{ skillNamesByIds(d.skillIds).join(', ') }}</span>
                </li>
              </ul>
              <div v-if="proj.technologies?.length" class="flex flex-wrap gap-1 mt-2">
                <span v-for="t in proj.technologies" :key="t.name || t" class="project-tech-tag">
                  <Icon v-if="t.icon" :icon="t.icon" class="w-3.5 h-3.5" />
                  {{ t.name || t }}
                </span>
              </div>
            </div>
          </section>

          <section v-if="linkedData.education.length">
            <h2>Education</h2>
            <div v-for="edu in linkedData.education" :key="edu.id" class="tc-item">
              <div class="tc-item-head">
                <div>
                  <div class="tc-item-title">{{ edu.title }}</div>
                  <div class="tc-item-sub">{{ edu.school }}</div>
                </div>
                <span class="tc-item-date">{{ formatDate(edu.startDate || edu.date) }} – {{ formatDate(edu.endDate) }}</span>
              </div>
            </div>
          </section>
        </main>
      </div>

      <!-- ══ Classic layout (default) ══ -->
      <div v-else class="cv-container" :style="cvContainerStyle">
      <!-- Sidebar -->
      <aside class="sidebar">
        <div>
          <div class="photo-placeholder">
            <img v-if="picUrl" :src="picUrl" :style="picStyle" :alt="nameInitials()" />
            <span v-else class="photo-initials">{{ nameInitials() }}</span>
          </div>
          <div v-if="picUrl" class="flex items-center justify-center gap-2 mt-1">
            <button @click="zoomOut" class="zoom-btn" :disabled="pictureZoom <= 0.5">&minus;</button>
            <span class="text-[10px] font-mono text-surface-400">{{ (pictureZoom * 100).toFixed(0) }}%</span>
            <button @click="zoomIn" class="zoom-btn" :disabled="pictureZoom >= 2">&plus;</button>
          </div>
          <h1>{{ cv.candidateName || cv.name }}</h1>
          <span class="title-badge">{{ cv.titleOverride || cv.specialization || 'Professional' }}</span>
          <div v-if="cv.availability" class="availability-badge">{{ cv.availability }}</div>
        </div>

        <!-- Contact -->
        <div v-if="linkedData.contacts.length">
          <h2>Contact</h2>
          <div v-for="c in linkedData.contacts" :key="c.id" class="contact-item">
            <Icon v-if="c.icon" :icon="c.icon" class="w-4 h-4 flex-shrink-0" />
            <a v-if="c.type === 'link'" :href="c.value.startsWith('http') ? c.value : 'https://' + c.value" target="_blank">
              {{ c.value.replace(/^https?:\/\//, '').replace(/\/$/, '') }}
            </a>
            <span v-else>{{ c.value }}</span>
          </div>
        </div>

        <!-- Hard Skills -->
        <div v-if="hardSkills.length">
          <h2>Hard Skills</h2>
          <div class="skills-grid">
            <span v-for="s in hardSkills" :key="s.id" class="skill-tag">
              <Icon v-if="s.icon" :icon="s.icon" class="w-4 h-4" />
              {{ s.name }}
            </span>
          </div>
        </div>

        <!-- Soft Skills -->
        <div v-if="softSkills.length">
          <h2>Soft Skills</h2>
          <div v-for="s in softSkills" :key="s.id" class="soft-skill-item">
            <span class="soft-skill-dot" />
            <div>
              <span class="soft-skill-name">{{ s.name }}</span>
              <span v-if="s.description" class="soft-skill-desc">{{ s.description }}</span>
            </div>
          </div>
        </div>

        <!-- Languages -->
        <div v-if="linkedData.languages.length">
          <h2>Langues</h2>
          <div v-for="l in linkedData.languages" :key="l.id" class="lang-item">
            <span>{{ l.name }}</span>
            <span class="lang-level">{{ l.level }}</span>
          </div>
        </div>

        <!-- Passions -->
        <div v-if="linkedData.passions.length">
          <h2>Passions</h2>
          <div v-for="p in linkedData.passions" :key="p.id" class="passion-item">
            <Icon v-if="p.icon" :icon="p.icon" class="w-4 h-4" />
            <div>
              <span class="passion-name">{{ p.name }}</span>
              <span v-if="p.description" class="passion-desc">{{ p.description }}</span>
            </div>
          </div>
        </div>
      </aside>

      <!-- Main Content -->
      <main class="main">
        <section v-if="cv.aboutText">
          <h2>À Propos</h2>
          <div class="about-text" v-html="formatAbout(cv.aboutText)" />
        </section>

        <section v-if="linkedData.experiences.length">
          <h2>Expériences Professionnelles</h2>
          <div v-for="exp in linkedData.experiences" :key="exp.id" class="experience-item">
            <div class="exp-header">
              <div>
                <div class="exp-title">{{ exp.title }}</div>
                <div class="exp-subtitle">
                  {{ exp.company }}
                  <a v-if="exp.companyUrl" :href="exp.companyUrl" target="_blank" class="exp-link">
                    <Icon icon="mdi:external-link" class="w-3 h-3" />
                    {{ hostname(exp.companyUrl) }}
                  </a>
                </div>
              </div>
              <span class="exp-date">{{ formatDate(exp.startDate) }} - {{ formatDate(exp.endDate) }}</span>
            </div>
            <p v-if="exp.location" class="exp-place">{{ exp.location }}</p>
            <ul v-if="exp.experiencePoints?.length" class="exp-desc">
              <li v-for="(d, i) in exp.experiencePoints" :key="i">
                {{ descriptionText(d) }}
                <span v-if="d.skillIds?.length" class="skill-ref">— {{ skillNamesByIds(d.skillIds).join(', ') }}</span>
              </li>
            </ul>
          </div>
        </section>

        <section v-if="linkedData.projects.length">
          <h2>Projets</h2>
          <div v-for="proj in linkedData.projects" :key="proj.id" class="project-item">
            <div class="exp-header">
              <div>
                <div class="exp-title">{{ proj.title }}</div>
                <div v-if="proj.subtitle || proj.liveUrl || proj.sourceUrl" class="exp-subtitle">
                  <span v-if="proj.subtitle">{{ proj.subtitle }}</span>
                  <a v-if="proj.liveUrl" :href="proj.liveUrl" target="_blank" class="exp-link">
                    <Icon icon="mdi:external-link" class="w-3 h-3" />
                    Live
                  </a>
                  <a v-if="proj.sourceUrl" :href="proj.sourceUrl" target="_blank" class="exp-link">
                    <Icon icon="mdi:github" class="w-3 h-3" />
                    Source
                  </a>
              </div>
            </div>
            <span class="exp-date">{{ formatDate(proj.startDate) }} - {{ formatDate(proj.endDate) }}</span>
            </div>
            <ul v-if="selectedProjectPoints(proj).length" class="exp-desc">
              <li v-for="(d, i) in selectedProjectPoints(proj)" :key="i">
                {{ descriptionText(d) }}
                <span v-if="d.skillIds?.length" class="skill-ref">— {{ skillNamesByIds(d.skillIds).join(', ') }}</span>
              </li>
            </ul>
            <div v-if="proj.technologies?.length" class="flex flex-wrap gap-1 mt-2">
              <span v-for="t in proj.technologies" :key="t.name || t" class="project-tech-tag">
                <Icon v-if="t.icon" :icon="t.icon" class="w-3.5 h-3.5" />
                {{ t.name || t }}
              </span>
            </div>
          </div>
        </section>

        <section v-if="linkedData.education.length">
          <h2>Formation</h2>
          <div v-for="edu in linkedData.education" :key="edu.id" class="education-item">
            <div>
              <div class="edu-title">{{ edu.title }}</div>
              <div class="edu-school">{{ edu.school }}{{ edu.school && edu.startDate ? ' · ' : '' }}{{ formatDate(edu.startDate || edu.date) }} - {{ formatDate(edu.endDate) }}</div>
            </div>
            <span class="edu-date">{{ formatDate(edu.startDate || edu.date) }} - {{ formatDate(edu.endDate) }}</span>
          </div>
          <div v-for="edu in linkedData.education" :key="'linked-' + edu.id">
            <div v-if="edu.linkedProjects?.length" class="mt-2 space-y-1">
              <p class="text-[10px] font-mono uppercase tracking-wider text-surface-400">Projets Associés</p>
              <div v-for="p in edu.linkedProjects" :key="p.id" class="text-xs text-surface-600 dark:text-surface-400 flex gap-2">
                <span class="text-accent">&bull;</span>
                <span>{{ p.title }}</span>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  </div>
  </template>

<style scoped>
/* ── CSS variables scoped to CV container ── */
.cv-container {
  --primary: #18181B;
  --secondary: #3F3F46;
  --accent: #2563EB;
  --accent-light: #3B82F6;
  --bg: #FAFAFA;
  --text: #09090B;
  --text-light: #71717A;
  --sidebar-bg: #18181B;
  --sidebar-text: #E4E4E7;
  --card-bg: #FFFFFF;
  --border: #E4E4E7;
  --tag-bg: #EFF6FF;
  --tag-text: #1D4ED8;
  max-width: 1240px;
  margin: 30px auto;
  display: grid;
  grid-template-columns: 320px 1fr;
  min-height: 1100px;
  box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
  border-radius: 16px;
  overflow: hidden;
}
.sidebar {
  background: var(--sidebar-bg);
  color: var(--sidebar-text);
  padding: 40px 28px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.sidebar h1 {
  font-family: 'Archivo', sans-serif;
  font-size: 32px;
  font-weight: 800;
  color: #fff;
  line-height: 1.1;
  text-align: center;
  letter-spacing: -0.02em;
}
.photo-placeholder {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: rgba(255,255,255,0.06);
  border: 3px solid var(--accent);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 10px;
  overflow: hidden;
}
.photo-placeholder img { width: 100%; height: 100%; object-fit: cover; }
.zoom-btn {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  border: 1px solid rgba(255,255,255,0.2);
  background: rgba(255,255,255,0.08);
  color: #E4E4E7;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  line-height: 1;
  cursor: pointer;
}
.zoom-btn:disabled { opacity: 0.3; cursor: default; }
.zoom-btn:not(:disabled):hover { background: rgba(255,255,255,0.15); border-color: var(--accent); }
.photo-initials {
  font-family: 'Archivo', sans-serif;
  font-size: 30px;
  font-weight: 800;
  color: var(--accent-light);
}
.sidebar .title-badge {
  display: block;
  text-align: center;
  background: var(--accent);
  color: #fff;
  font-family: 'Archivo', sans-serif;
  font-weight: 600;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  padding: 4px 12px;
  border-radius: 100px;
  margin: 6px auto 0;
}
.availability-badge {
  display: block;
  text-align: center;
  background: rgba(37,99,235,0.15);
  color: var(--accent-light);
  font-size: 13px;
  font-weight: 500;
  padding: 6px 14px;
  border-radius: 8px;
  border: 1px solid rgba(37,99,235,0.2);
  width: 100%;
  margin: 8px auto 0;
}
.sidebar h2 {
  font-family: 'Archivo', sans-serif;
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: var(--accent-light);
  margin-bottom: 10px;
  padding-bottom: 6px;
  border-bottom: 2px solid rgba(255,255,255,0.08);
}
.contact-item {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  font-size: 13px;
}
.contact-item svg { width: 16px; height: 16px; flex-shrink: 0; opacity: 0.6; }
.contact-item a { color: var(--sidebar-text); text-decoration: none; }
.contact-item a:hover { color: var(--accent-light); }
.skills-grid { display: flex; flex-wrap: wrap; gap: 4px; }
.skill-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.08);
  padding: 5px 12px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  margin: 3px;
}
.skill-tag:hover { background: rgba(37,99,235,0.2); border-color: var(--accent); }
.skill-tag svg, .skill-tag img { width: 16px; height: 16px; flex-shrink: 0; }
.soft-skill-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  padding: 4px 0;
  border-bottom: 1px solid rgba(255,255,255,0.05);
}
.soft-skill-item:last-child { border-bottom: none; }
.soft-skill-dot {
  width: 8px; height: 8px;
  border-radius: 50%;
  background: var(--accent);
  flex-shrink: 0;
  margin-top: 5px;
}
.soft-skill-name { display: block; font-size: 14px; color: #fff; }
.soft-skill-desc { display: block; font-size: 14px; color: rgba(255,255,255,0.6); margin-top: 2px; }
.lang-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 4px 0;
  font-size: 14px;
  font-weight: 500;
}
.lang-level {
  font-size: 14px;
  font-weight: 500;
  color: rgba(255,255,255,0.5);
  background: rgba(255,255,255,0.06);
  padding: 2px 8px;
  border-radius: 100px;
}
.passion-item {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  padding: 6px 0;
  border-bottom: 1px solid rgba(255,255,255,0.05);
}
.passion-item:last-child { border-bottom: none; }
.passion-item svg {
  width: 16px; height: 16px;
  margin-top: 3px;
  flex-shrink: 0;
  color: var(--accent-light);
}
.passion-name { display: block; font-size: 15px; color: #fff; }
.passion-desc { display: block; font-size: 13px; color: rgba(255,255,255,0.6); margin-top: 2px; }

/* ── Main ── */
.main {
  background: var(--bg);
  padding: 40px 40px 40px 32px;
  display: flex;
  flex-direction: column;
  gap: 30px;
}
.main h2 {
  font-family: 'Archivo', sans-serif;
  font-size: 18px;
  font-weight: 700;
  color: var(--primary);
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 14px;
}
.main h2::after {
  content: '';
  flex: 1;
  height: 2px;
  background: linear-gradient(90deg, var(--accent) 0%, transparent 100%);
}
.about-text { font-size: 14px; line-height: 1.8; color: var(--secondary); }
.about-text :deep(strong) { color: var(--primary); }
.experience-item,
.project-item {
  margin-bottom: 20px;
  position: relative;
  padding-left: 20px;
  border-left: 2px solid var(--border);
}
.experience-item::before,
.project-item::before {
  content: '';
  position: absolute;
  left: -5px;
  top: 6px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--accent);
}
.exp-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: 5px;
}
.exp-title { font-size: 16px; font-weight: 700; color: var(--primary); }
.exp-subtitle {
  font-size: 12px;
  font-weight: 600;
  color: #fff;
  background: var(--accent);
  padding: 3px 10px;
  border-radius: 100px;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  margin-top: 2px;
}
.exp-subtitle a {
  color: rgba(255,255,255,0.85);
  font-size: 11px;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 3px;
}
.exp-subtitle a:hover { text-decoration: underline; }
.exp-date {
  font-size: 12px;
  font-weight: 700;
  color: var(--accent);
  white-space: nowrap;
  background: var(--border);
  padding: 2px 10px;
  border-radius: 100px;
}
.exp-place { font-size: 12px; color: var(--text-light); margin-bottom: 6px; }
.exp-desc { margin-top: 6px; padding-left: 0; }
.exp-desc li {
  list-style: none;
  font-size: 13px;
  font-weight: 500;
  color: var(--secondary);
  padding: 3px 0;
  padding-left: 14px;
  position: relative;
}
.exp-desc li::before {
  content: '\2192';
  position: absolute;
  left: 0;
  color: var(--accent);
  font-weight: 600;
}
.skill-ref {
  font-size: 11px;
  color: var(--accent);
  font-weight: 500;
}

/* ── Custom for CvView (not in CV/style.css) ── */
.project-tech-tag {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  padding: 2px 6px;
  font-size: 10px;
  border-radius: 6px;
  font-weight: 500;
  background: rgba(37,99,235,0.08);
  border: 1px solid rgba(37,99,235,0.15);
  color: #1D4ED8;
}
.education-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 12px 0;
  border-bottom: 1px solid var(--border);
}
.education-item:last-child { border-bottom: none; }
.edu-title { font-weight: 800; font-size: 16px; color: var(--primary); }
.edu-school { font-size: 14px; color: var(--text-light); }
.edu-date { font-size: 12px; color: var(--text-light); white-space: nowrap; }

/* ── ATS style — live backend render in iframe (matches print/PDF byte-for-byte) ── */
.ats-frame {
  width: 794px; /* A4 width @96dpi — must equal the PDF page width for pixel-identical layout */
  max-width: 100%;
  margin: 30px auto;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  overflow: hidden;
}
.ats-iframe {
  display: block;
  width: 100%;
  height: 1123px; /* A4 height @96dpi — first PDF page */
  border: 0;
  background: #fff;
}

/* ── Two-Column Blue style ── */
.tc-container {
  --accent: #2563EB;
  --accent-dark: #1D4ED8;
  --accent-soft: #DBEAFE;
  --sidebar-bg: #EFF6FF;
  --sidebar-text: #1E293B;
  --main-text: #0F172A;
  --muted: #64748B;
  --line: #E2E8F0;
  max-width: 1240px;
  margin: 30px auto;
  display: grid;
  grid-template-columns: 300px 1fr;
  min-height: 1100px;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.2);
  border-radius: 16px;
  overflow: hidden;
  background: #fff;
  font-family: 'Space Grotesk', sans-serif;
  color: var(--main-text);
  line-height: 1.6;
}
.tc-sidebar {
  background: var(--sidebar-bg);
  color: var(--sidebar-text);
  padding: 40px 28px;
  display: flex;
  flex-direction: column;
  gap: 22px;
}
.tc-photo {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  background: #fff;
  border: 3px solid var(--accent);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 8px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
}
.tc-photo img { width: 100%; height: 100%; object-fit: cover; }
.tc-initials {
  font-family: 'Archivo', sans-serif;
  font-size: 30px;
  font-weight: 800;
  color: var(--accent);
}
.tc-zoom-row { display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 2px; }
.tc-zoom-btn {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  border: 1px solid var(--accent-soft);
  background: #fff;
  color: var(--accent-dark);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  line-height: 1;
  cursor: pointer;
}
.tc-zoom-btn:disabled { opacity: 0.3; cursor: default; }
.tc-zoom-btn:not(:disabled):hover { background: var(--accent-soft); }
.tc-sidebar h1 {
  font-family: 'Archivo', sans-serif;
  font-size: 28px;
  font-weight: 800;
  color: #0F172A;
  line-height: 1.1;
  text-align: center;
  letter-spacing: -0.02em;
  margin-top: 10px;
}
.tc-badge {
  display: block;
  text-align: center;
  background: var(--accent);
  color: #fff;
  font-family: 'Archivo', sans-serif;
  font-weight: 600;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  padding: 4px 12px;
  border-radius: 100px;
  margin: 4px auto 0;
}
.tc-availability {
  display: block;
  text-align: center;
  background: #fff;
  color: var(--accent-dark);
  font-size: 13px;
  font-weight: 600;
  padding: 5px 12px;
  border-radius: 8px;
  border: 1px solid var(--accent-soft);
  width: 100%;
  margin: 6px auto 0;
}
.tc-sidebar h2 {
  font-family: 'Archivo', sans-serif;
  font-size: 13px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--accent-dark);
  margin-bottom: 9px;
  padding-bottom: 5px;
  border-bottom: 2px solid var(--accent-soft);
}
.tc-contact {
  display: flex;
  align-items: center;
  gap: 9px;
  margin-bottom: 10px;
  font-size: 13px;
  word-break: break-word;
}
.tc-contact svg { width: 16px; height: 16px; flex-shrink: 0; color: var(--accent-dark); }
.tc-contact a { color: var(--sidebar-text); text-decoration: none; }
.tc-contact a:hover { color: var(--accent); }
.tc-skill-grid { display: flex; flex-wrap: wrap; gap: 4px; }
.tc-skill {
  background: #fff;
  border: 1px solid var(--accent-soft);
  color: var(--accent-dark);
  padding: 4px 10px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  margin: 3px;
}
.tc-soft {
  display: flex;
  align-items: flex-start;
  gap: 7px;
  padding: 5px 0;
  border-bottom: 1px solid var(--accent-soft);
}
.tc-soft:last-child { border-bottom: none; }
.tc-soft-name { display: block; font-size: 14px; font-weight: 600; color: #0F172A; }
.tc-soft-desc { display: block; font-size: 13px; color: var(--muted); margin-top: 1px; }
.tc-lang {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 4px 0;
  font-size: 14px;
  font-weight: 500;
}
.tc-lang-level {
  font-size: 12px;
  font-weight: 600;
  color: var(--accent-dark);
  background: #fff;
  border: 1px solid var(--accent-soft);
  padding: 2px 8px;
  border-radius: 100px;
}
.tc-passion {
  display: flex;
  align-items: flex-start;
  gap: 7px;
  padding: 5px 0;
  border-bottom: 1px solid var(--accent-soft);
  font-size: 14px;
  font-weight: 500;
}
.tc-passion:last-child { border-bottom: none; }
.tc-passion svg { width: 16px; height: 16px; margin-top: 3px; flex-shrink: 0; color: var(--accent); }
.tc-main {
  background: #fff;
  padding: 40px 40px 40px 32px;
  display: flex;
  flex-direction: column;
  gap: 26px;
}
.tc-main h2 {
  font-family: 'Archivo', sans-serif;
  font-size: 18px;
  font-weight: 700;
  color: #0F172A;
  margin-bottom: 12px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.tc-main h2::after {
  content: '';
  flex: 1;
  height: 2px;
  background: linear-gradient(90deg, var(--accent) 0%, transparent 100%);
}
.tc-about { font-size: 14px; line-height: 1.75; color: var(--sidebar-text); }
.tc-about :deep(strong) { color: #0F172A; }
.tc-item {
  margin-bottom: 18px;
  position: relative;
  padding-left: 18px;
  border-left: 2px solid var(--line);
}
.tc-item::before {
  content: '';
  position: absolute;
  left: -5px;
  top: 6px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--accent);
}
.tc-item-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: 5px;
}
.tc-item-title { font-size: 16px; font-weight: 700; color: #0F172A; }
.tc-item-sub {
  font-size: 12px;
  font-weight: 500;
  color: var(--muted);
  margin-top: 2px;
}
.tc-item-sub a { color: var(--accent); text-decoration: none; }
.tc-item-sub a:hover { text-decoration: underline; }
.tc-item-date {
  font-size: 11px;
  font-weight: 700;
  color: var(--accent-dark);
  white-space: nowrap;
  background: var(--sidebar-bg);
  padding: 2px 9px;
  border-radius: 100px;
}
.tc-item-list { margin-top: 6px; padding-left: 0; }
.tc-item-list li {
  list-style: none;
  font-size: 13px;
  font-weight: 500;
  color: var(--sidebar-text);
  padding: 2px 0 2px 14px;
  position: relative;
}
.tc-item-list li::before {
  content: '';
  position: absolute;
  left: 2px;
  top: 9px;
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: var(--accent);
}
.tc-skill-ref { font-size: 11px; color: var(--accent); font-weight: 600; }

@media (max-width: 768px) {
  .tc-container { grid-template-columns: 1fr; margin: 0; border-radius: 0; }
  .tc-sidebar { padding: 24px; }
  .tc-main { padding: 24px; }
  .tc-item-head { flex-direction: column; }
}

@media (max-width: 768px) {
  .cv-container { grid-template-columns: 1fr; margin: 0; border-radius: 0; }
  .sidebar { padding: 24px; }
  .main { padding: 24px; }
  .exp-header { flex-direction: column; }
}

/* ── Print ── */
@media print {
  .no-print { display: none !important; }
  .cv-container {
    max-width: 100%;
    margin: 0;
    box-shadow: none;
    border-radius: 0;
    display: table;
    width: 100%;
    height: 297mm;
    overflow: hidden;
    table-layout: fixed;
  }
  .sidebar {
    display: table-cell;
    width: 260px;
    vertical-align: top;
    padding: 2rem 1.6rem;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
  .main {
    display: table-cell;
    vertical-align: top;
    padding: 1.6rem;
  }
  .main > * { margin-bottom: 1.4rem; }
  .main > *:last-child { margin-bottom: 0; }
  .sidebar > * { margin-bottom: 1.8rem; }
  .sidebar > *:last-child { margin-bottom: 0; }
  .sidebar h1 { font-size: 3rem; }
  .sidebar h2 { font-size: 1.5rem; margin-bottom: 0.8rem; }
  .experience-item,
  .project-item { margin-bottom: 0.8rem; }
  .exp-header { display: grid; grid-template-columns: 1fr auto; align-items: start; gap: 0.4rem 1rem; }
  .exp-header > div { grid-column: 1; }
  .exp-date { font-size: 1rem; white-space: nowrap; grid-column: 2; grid-row: 1; }
  .main h2 { font-size: 1.8rem; margin-bottom: 0.6rem; }
  .exp-subtitle { font-size: 1.1rem; padding: 0.3rem 0.8rem; }
  .contact-item { font-size: 1.3rem; }
  .skill-tag { font-size: 1.1rem; }
  .photo-placeholder { width: 84px; height: 84px; }
  .photo-initials { font-size: 1.8rem; }
  p, li { font-size: 1.1rem; }
  .about-text p { font-size: 1.4rem; font-weight: 500; }
  .title-badge { font-size: 1.25rem; text-align: center; }
  .skill-tag, .sidebar, .title-badge, .exp-subtitle, .exp-date, .project-tech-tag, .availability-badge {
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
}
</style>

<style>
@page { size: A4; margin: 0; }
@media print {
  html { font-size: 48%; }
  header, .app_header, footer, .app_footer, .particle-network, canvas { display: none !important; }
  .app_layout { background: white !important; }
  body {
    margin: 0 !important;
    background: white !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
  .app_layout__main { padding-top: 0 !important; }
}
</style>
