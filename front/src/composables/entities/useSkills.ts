import { useEntityFactory } from './useEntityFactory'

export function useSkills() {
  return useEntityFactory<any>('skills')
}
