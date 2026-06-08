import { useEntityFactory } from './useEntityFactory'

export function useLanguages() {
  return useEntityFactory<any>('languages')
}
