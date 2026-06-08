<script setup lang="ts">
import { onMounted, watch, nextTick } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores/app'
import { useTerminal } from '@/composables/useTerminal'

const { t } = useI18n()
const appStore = useAppStore()
const { lines, currentInput, inputRef, terminalRef, handleSubmit, focus, addLine } = useTerminal()

watch(() => appStore.terminalOpen, (open) => {
  if (open) {
    nextTick(() => focus())
  }
})

function onKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape') {
    appStore.toggleTerminal()
  }
}
</script>

<template>
  <Teleport to="body">
    <Transition name="terminal">
      <div
        v-if="appStore.terminalOpen"
        class="terminal_overlay"
        @click.self="appStore.toggleTerminal()"
        @keydown="onKeydown"
      >
        <div class="terminal_modal" ref="terminalRef" @click.stop>
          <div class="terminal_modal__header">
            <div class="terminal_modal__dots">
              <span class="terminal_modal__dot terminal_modal__dot--red" @click="appStore.toggleTerminal()" />
              <span class="terminal_modal__dot terminal_modal__dot--yellow" />
              <span class="terminal_modal__dot terminal_modal__dot--green" />
            </div>
            <span class="terminal_modal__title">d3vex-portfolio — Interactive Terminal</span>
          </div>

          <div class="terminal_modal__body">
            <div v-for="(line, i) in lines" :key="i" class="terminal_modal__line" :class="`terminal_modal__line--${line.type}`">
              <span v-if="line.type === 'input'" class="terminal_modal__prompt">{{ t('terminal.prompt') }}</span>
              <pre class="terminal_modal__content">{{ line.content }}</pre>
            </div>

            <div class="terminal_modal__input-line">
              <span class="terminal_modal__prompt">{{ t('terminal.prompt') }}</span>
              <input
                ref="inputRef"
                v-model="currentInput"
                class="terminal_modal__input"
                type="text"
                autofocus
                autocomplete="off"
                spellcheck="false"
                @keydown.enter="handleSubmit"
              />
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style lang="scss" scoped>
.terminal_overlay {
  @apply fixed inset-0 z-[100] flex items-center justify-center p-4;
  background: rgba(0, 0, 0, 0.75);
  @apply backdrop-blur-sm;
}

.terminal_modal {
  @apply w-full max-w-3xl rounded-xl overflow-hidden shadow-2xl border transition-colors duration-300;
  background: #0D0D0D;
  border-color: #1a1a2e;
  max-height: 80vh;
  display: flex;
  flex-direction: column;

  &__header {
    @apply flex items-center gap-3 px-4 py-2.5 border-b;
    background: #1a1a1a;
    border-color: #2a2a2a;
  }

  &__dots {
    @apply flex items-center gap-1.5;
  }

  &__dot {
    @apply w-3 h-3 rounded-full cursor-pointer transition-opacity hover:opacity-80;

    &--red { @apply bg-red-500; }
    &--yellow { @apply bg-yellow-500; }
    &--green { @apply bg-green-500; }
  }

  &__title {
    @apply text-xs font-mono text-zinc-500 ml-2;
  }

  &__body {
    @apply p-4 font-mono text-sm overflow-y-auto flex-1;
    background: #0D0D0D;
    min-height: 300px;
    max-height: 60vh;
  }

  &__line {
    @apply mb-1 flex gap-2;

    &--input {
      .terminal_modal__content {
        @apply text-green-400;
      }
    }

    &--output {
      .terminal_modal__content {
        @apply text-zinc-300;
      }
    }

    &--system {
      .terminal_modal__content {
        @apply text-cyan-400;
      }
    }
  }

  &__prompt {
    @apply text-green-500 whitespace-nowrap flex-shrink-0;
  }

  &__content {
    @apply whitespace-pre-wrap m-0 font-mono text-sm leading-relaxed;
  }

  &__input-line {
    @apply flex gap-2 mt-2;
  }

  &__input {
    @apply flex-1 bg-transparent border-none outline-none text-green-400 font-mono text-sm;
    caret-color: #00FF00;
  }
}

.terminal-enter-active {
  transition: all 0.2s ease-out;
}

.terminal-leave-active {
  transition: all 0.15s ease-in;
}

.terminal-enter-from,
.terminal-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>
