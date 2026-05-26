import { ref, type Ref } from 'vue'
import type { ApiResponse } from '@/lib/types'

export function useAsyncData<T>(fetcher: () => Promise<ApiResponse<T>>) {
  const data = ref<T | null>(null) as Ref<T | null>
  const error = ref<string | null>(null)
  const loading = ref(true)

  async function execute() {
    loading.value = true
    error.value = null
    try {
      const result = await fetcher()
      data.value = result.data
      error.value = result.error
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'An unexpected error occurred'
    } finally {
      loading.value = false
    }
  }

  execute()

  return { data, error, loading, refresh: execute }
}
