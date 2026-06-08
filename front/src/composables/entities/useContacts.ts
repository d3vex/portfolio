import { useEntityFactory } from './useEntityFactory'

export function useContacts() {
  return useEntityFactory<any>('contacts')
}
