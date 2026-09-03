<script setup lang="ts">
// #SIZE_OK — Vue SFC with ~300 LOC scoped CSS; script logic extracted to composables
import { computed, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { useTerminalEffect } from '@/composables/useTerminalEffect'
import { useSkillsAnimation } from '@/composables/useSkillsAnimation'
import { getSkills } from '@/lib/api/skills'
import type { Skill } from '@/lib/types'

const { t } = useI18n()
const { data: skills, loading } = useAsyncData(() => getSkills())

const hardSkills = computed(() => skills.value?.filter((s: Skill) => s.cvCategory === 'hard') || [])
const softSkills = computed(() => skills.value?.filter((s: Skill) => s.cvCategory === 'soft') || [])

const { cmd1, cmd2, cmdOutput, cursor, bioTyped, bioDone } = useTerminalEffect()
const { widths, initWidths } = useSkillsAnimation(skills)

onMounted(() => {
  initWidths()
})
</script>

<template>
  <section class="about_page">
    <div class="about_page__bg" />

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

      <div class="about_page__skills">
      <div class="about_page__skills-head">
        <span class="about_page__badge">// skills — inventory</span>
        <h2 class="about_page__skills-title">{{ t('about.skills_title') }}</h2>
      </div>

      <div v-if="loading" class="about_page__loading">
        <div v-for="n in 4" :key="n" class="about_page__skeleton" />
      </div>

      <template v-else>
        <div class="about_page__columns">
          <div class="about_page__group">
            <div class="about_page__group-header">
              <Icon icon="mdi:code-tags" class="w-5 h-5" />
              <span class="about_page__group-title">Hard Skills</span>
              <span class="about_page__group-count">{{ hardSkills.length }}</span>
            </div>
            <TransitionGroup name="blade" tag="div" class="about_page__blades">
              <div
                v-for="skill in hardSkills"
                :key="skill.id"
                class="about_page__blade about_page__blade--hard"
              >
                <div class="about_page__blade-led about_page__blade-led--hard" />
                <div class="about_page__blade-inner">
                  <div class="about_page__blade-body">
                    <Icon :icon="skill.icon" class="w-4 h-4 text-accent flex-shrink-0" />
                    <span class="about_page__blade-name">{{ skill.name }}</span>
                    <div class="about_page__blade-bar">
                      <div
                        class="about_page__blade-fill about_page__blade-fill--hard"
                        :style="{ width: `${widths[skill.id] ?? 0}%` }"
                      />
                    </div>
                    <span class="about_page__blade-pct about_page__blade-pct--hard">{{ skill.level }}%</span>
                  </div>
                  <div v-if="skill.keywords?.length" class="about_page__blade-tags">
                    <span v-for="kw in skill.keywords" :key="kw" class="about_page__blade-tag">{{ kw }}</span>
                  </div>
                </div>
              </div>
            </TransitionGroup>
          </div>

          <div class="about_page__group">
            <div class="about_page__group-header">
              <Icon icon="mdi:account-group" class="w-5 h-5" />
              <span class="about_page__group-title">Soft Skills</span>
              <span class="about_page__group-count">{{ softSkills.length }}</span>
            </div>
            <TransitionGroup name="blade" tag="div" class="about_page__blades">
              <div
                v-for="skill in softSkills"
                :key="skill.id"
                class="about_page__blade about_page__blade--soft"
              >
                <div class="about_page__blade-led about_page__blade-led--soft" />
                <div class="about_page__blade-inner">
                  <div class="about_page__blade-body">
                    <Icon :icon="skill.icon" class="w-4 h-4 text-secondary flex-shrink-0" />
                    <span class="about_page__blade-name">{{ skill.name }}</span>
                    <div class="about_page__blade-bar">
                      <div
                        class="about_page__blade-fill about_page__blade-fill--soft"
                        :style="{ width: `${widths[skill.id] ?? 0}%` }"
                      />
                    </div>
                    <span class="about_page__blade-pct about_page__blade-pct--soft">{{ skill.level }}%</span>
                  </div>
                  <div v-if="skill.keywords?.length" class="about_page__blade-tags">
                    <span v-for="kw in skill.keywords" :key="kw" class="about_page__blade-tag">{{ kw }}</span>
                  </div>
                </div>
              </div>
            </TransitionGroup>
          </div>
        </div>
      </template>
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

  &__output {
    @apply mb-4;
    animation: fade-up 0.35s ease-out;
  }

  &__output-cmd {
    @apply font-mono text-sm;
    color: var(--color-text);
  }

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

  &__skills {
    @apply max-w-5xl mx-auto;
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

  &__columns {
    @apply grid grid-cols-1 md:grid-cols-2 gap-6;
  }

  &__group {
    @apply min-w-0;
  }

  &__group-header {
    @apply flex items-center gap-2 mb-4 pb-2 border-b;
    border-color: var(--color-border);
    color: var(--color-text);
  }

  &__group-title {
    @apply text-base font-heading font-semibold;
  }

  &__group-count {
    @apply ml-auto text-xs font-mono px-2 py-0.5 rounded-full;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
    color: var(--color-text-secondary);
  }

  &__loading {
    @apply space-y-3;
  }

  &__skeleton {
    @apply h-16 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  &__blades {
    @apply space-y-2;
  }

  &__blade {
    @apply flex rounded-lg border overflow-hidden transition-all duration-300;
    background-color: var(--color-surface);
    border-color: var(--color-border);
    animation: blade-in 0.35s ease-out both;

    &--hard:hover {
      border-color: var(--color-accent);
      background: color-mix(in srgb, var(--color-surface) 90%, var(--color-accent));
    }

    &--soft:hover {
      border-color: #a855f7;
      background: color-mix(in srgb, var(--color-surface) 90%, rgba(168, 85, 247, 0.08));
    }
  }

  &__blade-inner {
    @apply flex flex-col flex-1 min-w-0;
  }

  &__blade-led {
    width: 3px;
    flex-shrink: 0;
    opacity: 0.5;
    transition: opacity 0.3s;

    &--hard {
      background: var(--color-accent);
    }

    &--soft {
      background: #a855f7;
    }

    .about_page__blade:hover & {
      opacity: 1;
    }
  }

  &__blade-body {
    @apply flex items-center gap-2 px-3 py-2 flex-1 min-w-0;
  }

  &__blade-name {
    @apply font-heading font-semibold text-xs flex-shrink-0;
    color: var(--color-text);
    min-width: 60px;
  }

  &__blade-bar {
    @apply flex-1 h-[5px] rounded-full overflow-hidden;
    background-color: var(--color-bg);
    min-width: 40px;
  }

  &__blade-fill {
    @apply h-full rounded-full transition-all duration-1000 ease-out;

    &--hard {
      background: var(--color-accent);
    }

    &--soft {
      background: #a855f7;
    }
  }

  &__blade-pct {
    @apply font-mono text-[10px] font-bold flex-shrink-0 w-8 text-right;

    &--hard {
      color: var(--color-accent);
    }

    &--soft {
      color: #a855f7;
    }
  }

  &__blade-tags {
    @apply flex items-center flex-wrap gap-1 px-3 pb-2;
  }

  &__blade-tag {
    @apply px-1.5 py-0.5 rounded text-[10px] font-mono;
    color: var(--color-text-secondary);
    border: 1px solid var(--color-border);
    opacity: 0.7;
  }
}

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
</style>
