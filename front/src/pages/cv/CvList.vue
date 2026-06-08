<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCvStore } from '@/stores/cv'

const router = useRouter()
const store = useCvStore()

onMounted(() => store.loadCvs())

function formatDate(d: string) {
  return new Date(d).toLocaleDateString('fr-FR', { year: 'numeric', month: 'short', day: 'numeric' })
}
</script>

<template>
  <div class="max-w-6xl mx-auto px-4 py-8">
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-heading font-bold">CVs</h1>
        <p class="text-surface-500 mt-1">{{ store.cvs.length }} CV{{ store.cvs.length > 1 ? 's' : '' }} created</p>
      </div>
      <div class="flex gap-3">
        <button @click="router.push('/admin/dashboard')"
          class="px-4 py-2 border border-gray-200 dark:border-surface-700 rounded-xl hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
          Dashboard
        </button>
        <button @click="router.push('/admin/cvs/new')"
          class="px-4 py-2 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer">
          New CV
        </button>
      </div>
    </div>

    <div v-if="store.loading" class="text-center py-12 text-surface-500">Loading...</div>

    <div v-else-if="store.cvs.length === 0" class="text-center py-12">
      <p class="text-surface-500 text-lg mb-4">No CVs created yet</p>
      <button @click="router.push('/admin/cvs/new')"
        class="px-6 py-3 bg-accent text-white rounded-xl hover:bg-accent-hover transition-colors cursor-pointer">
        Create your first CV
      </button>
    </div>

    <div v-else class="grid gap-4">
      <div v-for="cv in store.cvs" :key="cv.id"
        class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-6 hover:border-accent/50 transition-all">
        <div class="flex items-start justify-between">
          <div>
            <h3 class="text-lg font-heading font-semibold">{{ cv.name }}</h3>
            <p class="text-surface-500 text-sm mt-1">
              {{ cv.specialization || 'General' }}
              <span v-if="cv.titleOverride"> &middot; {{ cv.titleOverride }}</span>
            </p>
            <p class="text-surface-400 text-xs mt-2">Created {{ formatDate(cv.createdAt) }}</p>
          </div>
          <div class="flex gap-2">
            <button @click="router.push(`/admin/cvs/${cv.id}`)"
              class="px-3 py-1.5 text-sm border border-gray-200 dark:border-surface-700 rounded-lg hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
              View
            </button>
            <button @click="router.push(`/admin/cvs/${cv.id}/edit`)"
              class="px-3 py-1.5 text-sm border border-gray-200 dark:border-surface-700 rounded-lg hover:bg-surface-100 dark:hover:bg-surface-800 transition-colors cursor-pointer">
              Edit
            </button>
            <button @click="store.removeCv(cv.id)"
              class="px-3 py-1.5 text-sm border border-red-200 dark:border-red-900 text-red-600 rounded-lg hover:bg-red-50 dark:hover:bg-red-950 transition-colors cursor-pointer">
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
