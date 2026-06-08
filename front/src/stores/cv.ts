import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import * as api from '@/lib/api/cv'

export const useCvStore = defineStore('cv', () => {
  const token = ref<string | null>(localStorage.getItem('cv_token'))
  const user = ref<any>(null)
  const cvs = ref<any[]>([])
  const currentCv = ref<any>(null)
  const stats = ref<any>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const isAuthenticated = computed(() => !!token.value)

  async function login(username: string, password: string) {
    const res = await api.login(username, password)
    token.value = res.access_token
    user.value = res.user
    localStorage.setItem('cv_token', res.access_token)
    localStorage.setItem('cv_user', JSON.stringify(res.user))
  }

  async function register(username: string, password: string) {
    const res = await api.register(username, password)
    token.value = res.access_token
    user.value = res.user
    localStorage.setItem('cv_token', res.access_token)
    localStorage.setItem('cv_user', JSON.stringify(res.user))
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('cv_token')
    localStorage.removeItem('cv_user')
  }

  function init() {
    const saved = localStorage.getItem('cv_user')
    if (saved) user.value = JSON.parse(saved)
  }

  async function loadCvs() {
    loading.value = true
    try {
      cvs.value = await api.getCvs()
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  async function loadCv(id: string) {
    loading.value = true
    try {
      currentCv.value = await api.getCv(id)
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  async function loadStats() {
    try {
      stats.value = await api.getCvStats()
    } catch (e: any) {
      error.value = e.message
    }
  }

  async function saveCv(data: any, id?: string) {
    loading.value = true
    try {
      if (id) {
        await api.updateCv(id, data)
      } else {
        await api.createCv(data)
      }
      await loadCvs()
    } catch (e: any) {
      error.value = e.message
      throw e
    } finally {
      loading.value = false
    }
  }

  async function removeCv(id: string) {
    await api.deleteCv(id)
    await loadCvs()
  }

  return {
    token, user, cvs, currentCv, stats, loading, error,
    isAuthenticated,
    login, register, logout, init,
    loadCvs, loadCv, loadStats, saveCv, removeCv,
  }
})
