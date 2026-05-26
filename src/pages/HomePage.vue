<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores/app'
import AppButton from '@/components/ui/AppButton.vue'

const { t } = useI18n()
const router = useRouter()
const appStore = useAppStore()

const typedText = ref('')
const fullText = '> systemctl start portfolio.service'
const showCursor = ref(true)


onMounted(() => {
  let i = 0
  const interval = setInterval(() => {
    if (i < fullText.length) {
      typedText.value += fullText[i]!
      i++
    } else {
      clearInterval(interval)
    }
  }, 50)

  setInterval(() => {
    showCursor.value = !showCursor.value
  }, 500)

})
</script>

<template>
  <section class="home_hero">
    <div class="home_hero__racks">
      <div v-for="rack in 2" :key="rack" class="home_hero__rack">
        <div class="home_hero__rack-header">
          <span class="home_hero__rack-label">SRV-RACK-{{ rack === 1 ? 'A' : 'B' }}</span>
          <span class="home_hero__rack-status">ONLINE</span>
        </div>
        <div
          v-for="unit in 16"
          :key="unit"
          class="home_hero__unit"
          :style="{ '--unit-idx': unit, '--rack-idx': rack }"
        >
          <div class="home_hero__unit-led" :class="`led-${(unit + rack) % 4}`" />
          <span class="home_hero__unit-label">SRV-{{ String(unit).padStart(2, '0') }}</span>
          <div class="home_hero__unit-slots">
            <div
              v-for="slot in 8"
              :key="slot"
              class="home_hero__unit-slot"
              :style="{ '--slot-idx': slot }"
            />
          </div>
          <div class="home_hero__unit-activity">
            <div class="home_hero__unit-bar" />
          </div>
        </div>
        <div class="home_hero__rack-footer">
          <span class="text-[10px] font-mono opacity-40">PWR: {{(Math.random() * 5).toFixed(2)}}kW | TEMP: {{ Math.floor(Math.random() * 20) + 30 }}°C | FAN: {{ Math.floor(Math.random() * 1000) + 2000 }} RPM</span>
        </div>
      </div>
    </div>

    <div class="home_hero__content">
      <div class="home_hero__terminal-line">
        <span class="text-cyber-green font-mono text-sm">{{ typedText }}</span>
        <span class="text-cyber-green font-mono text-sm" :class="{ 'opacity-0': !showCursor }">|</span>
      </div>

      <p class="home_hero__greeting">{{ t('hero.greeting') }}</p>
      <h1 class="home_hero__name">{{ t('hero.name') }}</h1>
      <p class="home_hero__tagline">{{ t('hero.tagline') }}</p>
      <p class="home_hero__subtitle">{{ t('hero.subtitle') }}</p>

      <div class="home_hero__stats">
        <div class="home_hero__stat">
          <span class="home_hero__stat-value">8+</span>
          <span class="home_hero__stat-label">{{ t('hero.stat_projects') }}</span>
        </div>
        <div class="home_hero__stat">
          <span class="home_hero__stat-value">3</span>
          <span class="home_hero__stat-label">{{ t('hero.stat_years') }}</span>
        </div>
        <div class="home_hero__stat">
          <span class="home_hero__stat-value">6</span>
          <span class="home_hero__stat-label">{{ t('hero.stat_techs') }}</span>
        </div>
      </div>

      <div class="home_hero__actions">
        <AppButton
          variant="primary"
          size="lg"
          iconRight="mdi:arrow-right"
          @click="router.push('/projects')"
        >
          {{ t('hero.cta_primary') }}
        </AppButton>
        <AppButton
          variant="outline"
          size="lg"
          iconRight="mdi:send"
          @click="router.push('/contact')"
        >
          {{ t('hero.cta_secondary') }}
        </AppButton>
      </div>

      <p class="home_hero__hint" @click="appStore.toggleTerminal()">
        <Icon icon="mdi:console" class="w-4 h-4 inline" />
        {{ t('hero.terminal_hint') }}
        <Icon icon="mdi:open-in-new" class="w-3 h-3 inline" />
      </p>
    </div>
  </section>
</template>

<style lang="scss" scoped>
$rack-width: 400px;
$unit-gap: 2px;
$unit-led-size: 8px;
$slot-size: 14px;

.home_hero {
  @apply relative min-h-screen flex items-center justify-center overflow-hidden;

  &__racks {
    @apply absolute inset-0 flex items-center justify-center gap-6;
    pointer-events: none;
    perspective: 1200px;
    -webkit-mask-image: linear-gradient(to bottom, transparent 0%, black 15%, black 85%, transparent 100%);
    mask-image: linear-gradient(to bottom, transparent 0%, black 15%, black 20%, transparent 100%);
  }

  &__rack {
    @apply flex flex-col rounded-lg border;
    border-color: var(--color-border);
    background: color-mix(in srgb, var(--color-surface) 60%, transparent);
    padding: 10px;
    gap: $unit-gap;
    width: $rack-width;
    transform: rotateX(2deg) translateY(-2%);

    &:first-child {
      transform: rotateX(2deg) rotateY(-3deg) translateY(-2%);
    }
    &:last-child {
      transform: rotateX(2deg) rotateY(3deg) translateY(-2%);
    }
  }

  &__rack-header {
    @apply flex items-center justify-between px-2 pb-1.5 mb-1 border-b;
    border-color: var(--color-border);
  }

  &__rack-label {
    @apply font-mono text-xs font-bold;
    color: var(--color-text);
    letter-spacing: 0.1em;
  }

  &__rack-status {
    @apply font-mono text-[10px] px-2 py-0.5 rounded-full;
    color: #00ff88;
    background: rgba(0, 255, 136, 0.1);
    border: 1px solid rgba(0, 255, 136, 0.2);
    animation: status-pulse 2s ease-in-out infinite;
  }

  &__rack-footer {
    @apply px-2 pt-1.5 mt-1 border-t text-center;
    border-color: var(--color-border);
  }

  &__unit {
    @apply flex items-center gap-2 rounded px-2.5 py-1.5 border;
    border-color: var(--color-border);
    background: color-mix(in srgb, var(--color-bg) 70%, transparent);
    transition: border-color 0.3s, background 0.3s;
    animation: unit-fade-in 0.4s ease-out both;
    animation-delay: calc((var(--rack-idx) - 1) * 0.2s + var(--unit-idx) * 0.05s);

    &:hover {
      border-color: rgba(0, 240, 255, 0.3);
      background: color-mix(in srgb, var(--color-bg) 50%, rgba(0, 240, 255, 0.05));
    }
  }

  &__unit-led {
    width: $unit-led-size;
    height: $unit-led-size;
    @apply rounded-full flex-shrink-0;
    animation: led-blink 1.5s ease-in-out infinite;

    &.led-0 {
      background: #00ff88;
      box-shadow: 0 0 4px #00ff88;
    }
    &.led-1 {
      background: #00f0ff;
      box-shadow: 0 0 4px #00f0ff;
      animation-delay: 0.37s;
    }
    &.led-2 {
      background: #ffb703;
      box-shadow: 0 0 4px #ffb703;
      animation-delay: 0.74s;
    }
    &.led-3 {
      background: #a855f7;
      box-shadow: 0 0 6px #a855f7;
      animation-delay: 1.11s;
    }
  }

  &__unit-label {
    @apply font-mono text-[10px] flex-shrink-0;
    color: var(--color-text-secondary);
    width: 32px;
  }

  &__unit-slots {
    @apply flex gap-[3px] flex-1;
  }

  &__unit-slot {
    width: $slot-size;
    height: 10px;
    @apply rounded-sm border;
    border-color: var(--color-border);
    background: color-mix(in srgb, var(--color-bg) 80%, transparent);
    transition: background 0.3s, border-color 0.3s;
    animation: slot-idle 3s ease-in-out infinite;
    animation-delay: calc(var(--slot-idx) * 0.15s + var(--unit-idx) * 0.03s);

    &:nth-child(3n) {
      animation-name: slot-active-1;
    }
    &:nth-child(3n+1) {
      animation-name: slot-active-2;
    }
    &:nth-child(3n+2) {
      animation-name: slot-active-3;
    }
  }

  &__unit-activity {
    width: 30px;
    height: 4px;
    @apply rounded-full overflow-hidden flex-shrink-0;
    background: color-mix(in srgb, var(--color-border) 50%, transparent);
  }

  &__unit-bar {
    height: 100%;
    @apply rounded-full;
    background: linear-gradient(90deg, rgba(0, 240, 255, 0.3), rgba(0, 240, 255, 0.8));
    animation: activity-bar 2s ease-in-out infinite;
    animation-delay: calc(var(--unit-idx) * 0.1s);
  }

  &__content {
    @apply relative z-20 text-center px-4;
    max-width: 620px;
    // glass-like backdrop for readability
    > * {
      position: relative;
    }
  }

  &__terminal-line {
    @apply mb-3 h-6;
  }

  &__statuses {
    @apply mb-5 space-y-0.5;
  }

  &__status-line {
    @apply font-mono text-xs text-left;
    color: var(--color-text-secondary);
    animation: status-appear 0.4s ease-out both;
    padding-left: 1.5rem;
  }

  &__greeting {
    @apply text-lg md:text-xl mb-2;
    color: var(--color-text-secondary);
  }

  &__name {
    @apply text-5xl md:text-7xl font-heading font-bold mb-4;
    color: var(--color-text);
  }

  &__tagline {
    @apply text-xl md:text-2xl font-medium mb-3;
    color: var(--color-accent);
  }

  &__subtitle {
    @apply text-base md:text-lg mx-auto mb-6;
    max-width: 520px;
    color: var(--color-text-secondary);
  }

  &__stats {
    @apply flex items-center justify-center gap-8 mb-7;
  }

  &__stat {
    @apply flex flex-col items-center;
  }

  &__stat-value {
    @apply text-2xl font-bold font-heading;
    color: var(--color-accent);
  }

  &__stat-label {
    @apply text-xs;
    color: var(--color-text-secondary);
  }

  &__actions {
    @apply flex flex-col sm:flex-row items-center justify-center gap-4 mb-8;
  }

  &__hint {
    @apply text-sm flex items-center justify-center gap-1.5 cursor-pointer;
    color: var(--color-text-secondary);
  }

  &__hint-link {
    @apply hover:text-accent transition-colors;
  }
}

// ── Keyframes ──────────────────────────────────

@keyframes led-blink {
  0%, 85%, 100% { opacity: 1; transform: scale(1); }
  92% { opacity: 0.3; transform: scale(0.7); }
}

@keyframes slot-idle {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 0.6; }
}

@keyframes slot-active-1 {
  0%, 85%, 100% {
    background: rgba(0, 240, 255, 0.25);
    border-color: rgba(0, 240, 255, 0.3);
  }
  15% {
    background: rgba(0, 240, 255, 0.5);
    border-color: rgba(0, 240, 255, 0.7);
    box-shadow: 0 0 6px rgba(0, 240, 255, 0.3);
  }
}

@keyframes slot-active-2 {
  0%, 80%, 100% {
    background: rgba(0, 255, 136, 0.2);
    border-color: rgba(0, 255, 136, 0.3);
  }
  40% {
    background: rgba(0, 255, 136, 0.5);
    border-color: rgba(0, 255, 136, 0.7);
    box-shadow: 0 0 6px rgba(0, 255, 136, 0.3);
  }
}

@keyframes slot-active-3 {
  0%, 88%, 100% {
    background: rgba(168, 85, 247, 0.2);
    border-color: rgba(168, 85, 247, 0.3);
  }
  65% {
    background: rgba(168, 85, 247, 0.5);
    border-color: rgba(168, 85, 247, 0.7);
    box-shadow: 0 0 6px rgba(168, 85, 247, 0.3);
  }
}

@keyframes activity-bar {
  0% { width: 10%; opacity: 0.4; }
  50% { width: 85%; opacity: 1; }
  100% { width: 10%; opacity: 0.4; }
}

@keyframes unit-fade-in {
  0% { opacity: 0; transform: translateY(8px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes status-pulse {
  0%, 100% { opacity: 0.8; }
  50% { opacity: 1; }
}

@keyframes status-appear {
  0% { opacity: 0; transform: translateX(-10px); }
  100% { opacity: 1; transform: translateX(0); }
}
</style>
