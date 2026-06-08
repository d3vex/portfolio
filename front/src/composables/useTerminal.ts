import { ref, nextTick } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores/app'

interface TerminalLine {
  content: string
  type: 'input' | 'output' | 'system'
}

const BANNER = [
  '  ____   ___  __     __',
  ' |  _ \\ / _ \\ \\ \\   / /',
  ' | | | | | | |\\ \\_/ / ',
  ' | |_| | |_| | \\   /  ',
  ' |____/ \\___/   \\_/   ',
  '                       ',
  ' Welcome to my portfolio',
].join('\n')

const BANNER_FR = [
  '  ____   ___  __     __',
  ' |  _ \\ / _ \\ \\ \\   / /',
  ' | | | | | | |\\ \\_/ / ',
  ' | |_| | |_| | \\   /  ',
  ' |____/ \\___/   \\_/   ',
  '                       ',
  ' Bienvenue sur mon portfolio',
].join('\n')

export function useTerminal() {
  const { t, locale } = useI18n()
  const appStore = useAppStore()

  const lines = ref<TerminalLine[]>([
    { content: t('terminal.welcome'), type: 'system' },
    { content: banner(), type: 'output' },
  ])
  const currentInput = ref('')
  const inputRef = ref<HTMLInputElement | null>(null)
  const terminalRef = ref<HTMLDivElement | null>(null)

  const commands: Record<string, () => void | string> = {
    help: () => {
      const helpText = [
        t('terminal.help_title'),
        t('terminal.help_about'),
        t('terminal.help_skills'),
        t('terminal.help_projects'),
        t('terminal.help_contact'),
        t('terminal.help_theme'),
        t('terminal.help_lang'),
        t('terminal.help_social'),
        t('terminal.help_banner'),
        t('terminal.help_clear'),
        t('terminal.help_help'),
      ]
      helpText.forEach(line => addLine(line, 'output'))
    },
    about: () => addLine(t('terminal.about_text'), 'output'),
    skills: () => addLine(t('terminal.skills_text'), 'output'),
    projects: () => addLine('Opening projects page...', 'output'),
    contact: () => addLine(t('terminal.contact_text'), 'output'),
    theme: () => {
      appStore.toggleTheme()
      addLine(t('terminal.theme_text'), 'output')
    },
    lang: () => {
      locale.value = locale.value === 'en' ? 'fr' : 'en'
      addLine(t('terminal.lang_text', { lang: locale.value === 'en' ? 'English' : 'Français' }), 'output')
    },
    social: () => {
      addLine('GitHub: github.com/D3vex\nLinkedIn: linkedin.com/in/loanmata', 'output')
    },
    banner: () => addLine(banner(), 'output'),
    clear: () => {
      lines.value = []
    },
  }

  function addLine(content: string, type: TerminalLine['type']) {
    lines.value.push({ content, type })
    scrollToBottom()
  }

  function scrollToBottom() {
    nextTick(() => {
      if (terminalRef.value) {
        terminalRef.value.scrollTop = terminalRef.value.scrollHeight
      }
    })
  }

  function executeCommand(cmd: string) {
    const trimmed = cmd.trim().toLowerCase()
    addLine(`${t('terminal.prompt')} ${cmd}`, 'input')

    if (!trimmed) return

    const handler = commands[trimmed]
    if (handler) {
      handler()
    } else {
      addLine(t('terminal.not_found', { cmd: trimmed }), 'output')
    }
  }

  function handleSubmit() {
    const cmd = currentInput.value
    if (!cmd.trim()) return
    executeCommand(cmd)
    currentInput.value = ''
    nextTick(() => inputRef.value?.focus())
  }

  function focus() {
    inputRef.value?.focus()
  }

  function banner() {
    return locale.value === 'fr' ? BANNER_FR : BANNER
  }

  return {
    lines,
    currentInput,
    inputRef,
    terminalRef,
    executeCommand,
    handleSubmit,
    focus,
    addLine,
  }
}
