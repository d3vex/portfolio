<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCvStore } from '@/stores/cv'
import * as api from '@/lib/api/cv'

const router = useRouter()
const store = useCvStore()
const stats = ref<any>(null)

onMounted(async () => {
  try {
    stats.value = await api.getCvStats()
  } catch (e) {
    console.error(e)
  }
})

const entities = [
  { key: 'skills', label: 'Skills', icon: 'M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z' },
  { key: 'experiences', label: 'Experiences', icon: 'M21 13.255A23.93 23.93 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z' },
  { key: 'projects', label: 'Projects', icon: 'M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z' },
  { key: 'education', label: 'Education', icon: 'M12 14l9-5-9-5-9 5 9 5zm0 7l-9-5 3-1.5m12-2l-3 1.5M12 14l-9-5' },
  { key: 'languages', label: 'Languages', icon: 'M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z' },
  { key: 'passions', label: 'Passions', icon: 'M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z' },
  { key: 'contacts', label: 'Contacts', icon: 'M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z' },
  { key: 'categories', label: 'Categories', icon: 'M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z' },
]
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-8">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-heading font-bold">Dashboard</h1>
        <p class="text-surface-500 mt-1">Overview of your CV portfolio</p>
      </div>
      <div class="flex gap-3">
        <button @click="router.push('/admin/cvs')"
          class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
          View CVs
        </button>
        <button @click="router.push('/admin/cvs/new')"
          class="px-4 py-2 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer">
          New CV
        </button>
      </div>
    </div>

    <div v-if="stats" class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
        <p class="text-3xl font-bold font-heading">{{ stats.totalCvs }}</p>
        <p class="text-surface-500 text-sm mt-1">Total CVs</p>
      </div>
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
        <p class="text-3xl font-bold font-heading">{{ stats.hardSkills + stats.softSkills }}</p>
        <p class="text-surface-500 text-sm mt-1">Total Skills</p>
      </div>
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
        <p class="text-3xl font-bold font-heading">{{ stats.experiences }}</p>
        <p class="text-surface-500 text-sm mt-1">Experiences</p>
      </div>
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5">
        <p class="text-3xl font-bold font-heading">{{ stats.projects }}</p>
        <p class="text-surface-500 text-sm mt-1">Projects</p>
      </div>
    </div>

    <button @click="router.push('/admin/cvs/ai-generator')"
      class="w-full text-left mb-8 bg-gradient-to-r from-accent to-accent-hover rounded-2xl p-6 text-white hover:opacity-95 active:opacity-90 transition-opacity cursor-pointer shadow-lg shadow-accent/25">
      <div class="flex items-center gap-5">
        <div class="w-12 h-12 rounded-xl bg-white/15 flex items-center justify-center flex-shrink-0">
          <Icon icon="mdi:auto-fix" class="w-7 h-7" />
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-lg font-heading font-semibold">Générateur de CV par IA</p>
          <p class="text-sm text-white/85 mt-0.5">Collez une description de poste : l'IA génère un CV complet avec des suggestions de compétences et de points clés à valider.</p>
        </div>
        <svg class="w-6 h-6 text-white/70 flex-shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M13 7l5 5-5 5M18 12H6" />
        </svg>
      </div>
    </button>

    <h2 class="text-xl font-heading font-semibold mb-4">Manage Data</h2>
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <button v-for="e in entities" :key="e.key"
        @click="router.push(`/admin/manage/${e.key}`)"
        class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-5 hover:border-accent/50 transition-all cursor-pointer text-left">
        <svg class="w-8 h-8 text-accent mb-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path :d="e.icon" />
        </svg>
        <p class="font-medium">{{ e.label }}</p>
      </button>
    </div>
  </div>
</template>
