import { useEntityFactory } from './useEntityFactory'

export function usePassions() {
  return useEntityFactory<any>('passions')
}
