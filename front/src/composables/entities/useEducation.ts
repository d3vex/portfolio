import { useEntityFactory } from './useEntityFactory'

export function useEducation() {
  return useEntityFactory<any>('education')
}
