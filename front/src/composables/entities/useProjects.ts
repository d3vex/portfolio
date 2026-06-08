import { useEntityFactory } from './useEntityFactory'

export function useProjects() {
  return useEntityFactory<any>('projects')
}
