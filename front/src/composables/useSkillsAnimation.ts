import { ref, watch, type Ref } from 'vue'
import type { Skill } from '@/lib/types'

export function useSkillsAnimation(skills: Ref<Skill[] | null>) {
  const widths = ref<Record<string, number>>({})

  function initWidths() {
    if (!skills.value) return
    const init: Record<string, number> = {}
    skills.value.forEach((s: Skill) => { init[s.id] = 0 })
    widths.value = init
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        const next: Record<string, number> = {}
        skills.value!.forEach((s: Skill) => { next[s.id] = s.level })
        widths.value = next
      })
    })
  }

  watch(skills, () => {
    initWidths()
  })

  return { widths, initWidths }
}
