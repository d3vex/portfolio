import { ref, onMounted } from 'vue'

export function useTerminalEffect() {
  const cmd1 = ref('')
  const cmd2 = ref('')
  const cmdOutput = ref('')
  const cursor = ref(true)
  const bioTyped = ref('')
  const bioDone = ref(false)

  const infoLines = [
    'os         Human 2.0 (x86_64)',
    'host       D3vex-Portfolio',
    'kernel     12,742h 33m uptime',
    'shell      /bin/creativity',
    'terminal   /dev/passion',
    'location   France (FR)',
    'role       IT Student & Engineer',
  ]
  const infoFullText = infoLines.join('\n')

  const bioText = 'French IT student passionate about software development and infrastructure engineering. I thrive at the intersection where code meets hardware \u2014 building everything from Vue frontends to Kubernetes clusters.'

  const cmdInfo = 'cat /etc/d3vex-release'
  const cmdBio = 'cat /home/loan_mata/bio.txt'

  function typeText(text: string, onChar: (v: string) => void, onDone: () => void) {
    let i = 0
    const t = setInterval(() => {
      i++
      onChar(text.slice(0, i))
      if (i >= text.length) {
        clearInterval(t)
        setTimeout(onDone, 250)
      }
    }, 16)
  }

  function typeBio() {
    let i = 0
    const t = setInterval(() => {
      bioTyped.value += bioText[i]!
      i++
      if (i >= bioText.length) {
        clearInterval(t)
        bioDone.value = true
      }
    }, 12)
  }

  onMounted(() => {
    setInterval(() => { cursor.value = !cursor.value }, 530)

    typeText(cmdInfo, (v) => { cmd1.value = v }, () => {
      typeText(infoFullText, (v) => { cmdOutput.value = v }, () => {})
    })

    typeText(cmdBio, (v) => { cmd2.value = v }, () => {
      setTimeout(typeBio, 300)
    })
  })

  return { cmd1, cmd2, cmdOutput, cursor, bioTyped, bioDone }
}
