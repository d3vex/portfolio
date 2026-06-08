import { useEntityFactory } from './useEntityFactory'

export function useCategories() {
  return useEntityFactory<any>('categories')
}
