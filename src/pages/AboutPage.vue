<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { getSkills } from '@/lib/api/skills'
import type { Skill } from '@/lib/types'

const { t } = useI18n()
const { data: skills, loading } = useAsyncData(() => getSkills())

const activeCategory = ref<'all' | Skill['category']>('all')

const filteredSkills = computed(() => {
  if (!skills.value) return []
  if (activeCategory.value === 'all') return skills.value
  return skills.value.filter(s => s.category === activeCategory.value)
})

// ── Terminal state ──────────────────────

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

onMounted(() => {
  setInterval(() => { cursor.value = !cursor.value }, 530)

  // Both terminals animate simultaneously
  typeText(cmdInfo, (v) => { cmd1.value = v }, () => {
    typeText(infoFullText, (v) => { cmdOutput.value = v }, () => {})
  })

  typeText(cmdBio, (v) => { cmd2.value = v }, () => {
    setTimeout(typeBio, 300)
  })

  if (skills.value) {
    const init: Record<string, number> = {}
    skills.value.forEach(s => { init[s.id] = 0 })
    widths.value = init
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        const next: Record<string, number> = {}
        skills.value!.forEach(s => { next[s.id] = s.level })
        widths.value = next
      })
    })
  }
})

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

const widths = ref<Record<string, number>>({})

watch(skills, (val) => {
  if (val) {
    const init: Record<string, number> = {}
    val.forEach(s => { init[s.id] = 0 })
    widths.value = init
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        const next: Record<string, number> = {}
        val.forEach(s => { next[s.id] = s.level })
        widths.value = next
      })
    })
  }
})

const categories = [
  { key: 'all' as const, label: 'projects.filters.all' },
  { key: 'dev' as const, label: 'about.dev_title' },
  { key: 'infra' as const, label: 'about.infra_title' },
  { key: 'sysadmin' as const, label: 'about.infra_title' },
]
</script>

<template>
  <section class="about_page">
    <div class="about_page__bg" />

    <!-- ── Terminals ── -->
    <div class="about_page__terminals">
      <div class="about_page__terminal">
        <div class="about_page__terminal-bar">
          <div class="about_page__terminal-dots">
            <span class="bg-red-500" /><span class="bg-amber-500" /><span class="bg-green-500" />
          </div>
          <div class="about_page__terminal-title">
            <Icon icon="mdi:server" class="w-3.5 h-3.5" />
            <span>system-info</span>
          </div>
        </div>

        <div class="about_page__terminal-body">
          <p v-if="cmd1" class="about_page__output-cmd">
            <span class="text-cyber-green">visitor@d3vex-portfolio</span>:<span class="text-cyber-cyan">~</span>$ {{ cmd1 }}<span :class="{ 'opacity-0': !cursor }">|</span>
          </p>

          <div v-if="cmdOutput" class="about_page__output">
            <div v-for="(line, i) in cmdOutput.split('\n')" :key="i" class="about_page__neofetch-line">
              <span class="about_page__neofetch-key">{{ line.split(/\s+/)[0] }}</span>
              <span class="about_page__neofetch-val">{{ line.slice(line.split(/\s+/)[0].length) }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="about_page__terminal">
        <div class="about_page__terminal-bar">
          <div class="about_page__terminal-dots">
            <span class="bg-red-500" /><span class="bg-amber-500" /><span class="bg-green-500" />
          </div>
          <div class="about_page__terminal-title">
            <Icon icon="mdi:account" class="w-3.5 h-3.5" />
            <span>profile</span>
          </div>
        </div>

        <div class="about_page__terminal-body">
          <p v-if="cmd2" class="about_page__output-cmd">
            <span class="text-cyber-green">visitor@d3vex-portfolio</span>:<span class="text-cyber-cyan">~</span>$ {{ cmd2 }}<span :class="{ 'opacity-0': !cursor }">|</span>
          </p>

          <div v-if="bioTyped.length > 0 || bioDone" class="about_page__bio-section">
            <div class="about_page__bio-header">
              <Icon icon="mdi:file-document-outline" class="w-3.5 h-3.5" />
              <span>bio.txt</span>
            </div>
            <p class="about_page__bio-text">
              {{ bioTyped }}<span v-if="!bioDone" :class="{ 'opacity-0': !cursor }">|</span>
            </p>
          </div>

        </div>
      </div>
    </div>

    <!-- ── Skills ── -->
    <div class="about_page__skills">
      <div class="about_page__skills-head">
        <span class="about_page__badge">// skills — inventory</span>
        <h2 class="about_page__skills-title">{{ t('about.skills_title') }}</h2>
      </div>

      <div class="about_page__filters">
        <button
          v-for="cat in categories"
          :key="cat.key"
          class="about_page__filter"
          :class="{ 'about_page__filter--active': activeCategory === cat.key }"
          @click="activeCategory = cat.key"
        >
          {{ t(cat.label) }}
        </button>
      </div>

      <div v-if="loading" class="about_page__loading">
        <div v-for="n in 4" :key="n" class="about_page__skeleton" />
      </div>

      <TransitionGroup v-else name="blade" tag="div" class="about_page__blades">
        <div
          v-for="skill in filteredSkills"
          :key="skill.id"
          class="about_page__blade"
        >
          <div class="about_page__blade-led" />
          <div class="about_page__blade-body">
            <Icon :icon="skill.icon" class="w-4 h-4 text-accent flex-shrink-0" />
            <span class="about_page__blade-name">{{ skill.name }}</span>
            <div class="about_page__blade-bar">
              <div
                class="about_page__blade-fill"
                :style="{ width: `${widths[skill.id] ?? 0}%` }"
              />
            </div>
            <span class="about_page__blade-pct">{{ skill.level }}%</span>
          </div>
          <div class="about_page__blade-tags">
            <span v-for="kw in skill.keywords" :key="kw" class="about_page__blade-tag">{{ kw }}</span>
          </div>
        </div>
      </TransitionGroup>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.about_page {
  @apply py-24 px-4 relative overflow-hidden;

  &__bg {
    @apply absolute inset-0 pointer-events-none;
    background:
      radial-gradient(ellipse at 50% 0%, rgba(37, 99, 235, 0.04) 0%, transparent 60%),
      radial-gradient(ellipse at 50% 100%, rgba(37, 99, 235, 0.03) 0%, transparent 50%);
  }

  // ── Terminals ────────────────────────

  &__terminals {
    @apply max-w-5xl mx-auto mb-24 flex flex-col lg:flex-row gap-4;
  }

  &__terminal {
    @apply flex-1 min-w-0 rounded-xl border overflow-hidden;
    border-color: var(--color-border);
    background-color: var(--color-surface);
    box-shadow: 0 0 30px rgba(37, 99, 235, 0.04);
  }

  &__terminal-bar {
    @apply flex items-center gap-2 px-4 py-2.5 border-b;
    border-color: var(--color-border);
    background: color-mix(in srgb, var(--color-bg) 60%, transparent);
  }

  &__terminal-dots {
    @apply flex items-center gap-1.5;
    span {
      width: 10px; height: 10px;
      @apply rounded-full;
    }
  }

  &__terminal-title {
    @apply flex items-center gap-2 font-mono text-xs ml-2;
    color: var(--color-text-secondary);
    opacity: 0.6;
  }

  &__terminal-body {
    @apply p-6 md:p-8 space-y-1;
  }

  // ── Output entries ────────────────────

  &__output {
    @apply mb-4;
    animation: fade-up 0.35s ease-out;
  }

  &__output-cmd {
    @apply font-mono text-sm;
    color: var(--color-text);
  }

  // ── Neofetch lines ────────────────────

  &__neofetch-line {
    @apply font-mono text-sm py-1;
    animation: fade-line 0.25s ease-out both;
    padding-left: 3px;
  }

  &__neofetch-key {
    @apply text-accent font-semibold inline-block w-[90px];
  }

  &__neofetch-val {
    color: var(--color-text);
  }

  // ── Bio section ──────────────────────

  &__bio-section {
    @apply mt-4 rounded-lg border overflow-hidden;
    border-color: var(--color-border);
    animation: fade-up 0.4s ease-out;
  }

  &__bio-header {
    @apply flex items-center gap-2 px-4 py-2.5 border-b font-mono text-xs;
    border-color: var(--color-border);
    background: color-mix(in srgb, var(--color-bg) 50%, transparent);
    color: var(--color-text-secondary);
  }

  &__bio-text {
    @apply px-4 py-4 text-base leading-relaxed;
    color: var(--color-text);
  }

  // ── Final status ──────────────────────

  &__final {
    @apply mt-4 font-mono text-xs flex items-center gap-2;
    color: var(--color-text-secondary);
    opacity: 0.6;
    animation: fade-up 0.4s ease-out;
  }

  &__final-check {
    color: #00ff88;
    animation: pulse-glow 2s ease-in-out infinite;
  }

  // ── Skills ───────────────────────────

  &__skills {
    @apply max-w-2xl mx-auto;
  }

  &__skills-head {
    @apply text-center mb-10;
  }

  &__badge {
    @apply font-mono text-xs tracking-widest block mb-3;
    color: var(--color-text-secondary);
    opacity: 0.4;
  }

  &__skills-title {
    @apply text-2xl md:text-3xl font-heading font-bold;
    color: var(--color-text);
  }

  &__filters {
    @apply flex items-center justify-center gap-2 mb-10 flex-wrap;
  }

  &__filter {
    @apply px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200;
    color: var(--color-text-secondary);
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);

    &:hover {
      color: var(--color-text);
      border-color: var(--color-accent);
    }

    &--active {
      @apply bg-accent text-white border-accent;
    }
  }

  &__loading {
    @apply space-y-3;
  }

  &__skeleton {
    @apply h-16 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  // ── Blades ───────────────────────────

  &__blades {
    @apply space-y-2;
  }

  &__blade {
    @apply flex items-center rounded-lg border overflow-hidden transition-all duration-300;
    background-color: var(--color-surface);
    border-color: var(--color-border);
    animation: blade-in 0.35s ease-out both;

    &:hover {
      border-color: var(--color-accent);
      background: color-mix(in srgb, var(--color-surface) 90%, var(--color-accent));
    }
  }

  &__blade-led {
    width: 3px;
    flex-shrink: 0;
    align-self: stretch;
    background: var(--color-accent);
    opacity: 0.5;
    transition: opacity 0.3s;

    .about_page__blade:hover & {
      opacity: 1;
    }
  }

  &__blade-body {
    @apply flex items-center gap-2.5 px-4 py-2.5 flex-1 min-w-0;
  }

  &__blade-name {
    @apply font-heading font-semibold text-sm flex-shrink-0;
    color: var(--color-text);
    min-width: 80px;
  }

  &__blade-bar {
    @apply flex-1 h-[6px] rounded-full overflow-hidden;
    background-color: var(--color-bg);
    min-width: 60px;
  }

  &__blade-fill {
    @apply h-full rounded-full transition-all duration-1000 ease-out;
    background: var(--color-accent);
  }

  &__blade-pct {
    @apply font-mono text-xs font-bold flex-shrink-0 w-10 text-right;
    color: var(--color-accent);
  }

  &__blade-tags {
    @apply hidden lg:flex items-center gap-1 pr-4;
  }

  &__blade-tag {
    @apply px-1.5 py-0.5 rounded text-[10px] font-mono;
    color: var(--color-text-secondary);
    border: 1px solid var(--color-border);
    opacity: 0.7;
  }
}

// ── Transitions ────────────────────────

.blade-enter-active {
  transition: all 0.3s ease-out;
}
.blade-leave-active {
  transition: all 0.25s ease-in;
}
.blade-enter-from {
  opacity: 0;
  transform: translateX(-14px) scale(0.95);
}
.blade-leave-to {
  opacity: 0;
  transform: translateX(14px) scale(0.95);
}
.blade-move {
  transition: transform 0.3s ease;
}

// ── Keyframes ──────────────────────────

@keyframes fade-up {
  0% { opacity: 0; transform: translateY(8px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes fade-line {
  0% { opacity: 0; transform: translateX(-6px); }
  100% { opacity: 1; transform: translateX(0); }
}

@keyframes blade-in {
  0% { opacity: 0; transform: translateY(6px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
