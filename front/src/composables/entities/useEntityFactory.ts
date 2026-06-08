import { ref, type Ref } from 'vue'
import * as api from '@/lib/api/cv'

export interface EntityState<T> {
  items: Ref<T[]>
  current: Ref<T | null>
  loading: Ref<boolean>
  error: Ref<string | null>
}

export function useEntityFactory<T extends { id: string }>(entityKey: string) {
  const items = ref<T[]>([]) as Ref<T[]>
  const current = ref<T | null>(null) as Ref<T | null>
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      items.value = await api.getEntity(entityKey)
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  async function fetchOne(id: string) {
    loading.value = true
    error.value = null
    try {
      const all = await api.getEntity(entityKey)
      current.value = all.find((i: T) => i.id === id) || null
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  async function create(data: Partial<T>) {
    error.value = null
    const saved: T = await api.createEntity(entityKey, data)
    items.value = [...items.value, saved]
    return saved
  }

  async function update(id: string, data: Partial<T>) {
    error.value = null
    const saved: T = await api.updateEntity(entityKey, id, data)
    items.value = items.value.map(i => i.id === id ? saved : i)
    if (current.value?.id === id) current.value = saved
    return saved
  }

  async function remove(id: string) {
    error.value = null
    await api.deleteEntity(entityKey, id)
    items.value = items.value.filter(i => i.id !== id)
    if (current.value?.id === id) current.value = null
  }

  return {
    items,
    current,
    loading,
    error,
    fetchAll,
    fetchOne,
    create,
    update,
    remove,
  }
}
