import { useEntityFactory } from './useEntityFactory'

export function useExperiences() {
  return useEntityFactory<any>('experiences')
}
