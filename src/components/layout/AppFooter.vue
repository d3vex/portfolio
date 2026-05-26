<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
const year = new Date().getFullYear()
</script>

<template>
  <footer class="app_footer">
    <div class="app_footer__inner">
      <p class="app_footer__copyright">{{ t('footer.copyright', { year }) }}</p>
      <p class="app_footer__made">{{ t('footer.made_with') }}</p>
      <div class="app_footer__socials">
        <a href="https://github.com/D3vex" target="_blank" rel="noopener" class="app_footer__social" aria-label="GitHub">
          <Icon icon="mdi:github" class="w-5 h-5" />
        </a>
        <a href="https://linkedin.com/in/loanmata" target="_blank" rel="noopener" class="app_footer__social" aria-label="LinkedIn">
          <Icon icon="mdi:linkedin" class="w-5 h-5" />
        </a>
        <a href="mailto:loan.mata@email.com" class="app_footer__social" aria-label="Email">
          <Icon icon="mdi:email" class="w-5 h-5" />
        </a>
      </div>
    </div>
  </footer>
</template>

<style lang="scss" scoped>
.app_footer {
  @apply border-t transition-colors duration-300;
  border-color: var(--color-border);

  &__inner {
    @apply max-w-6xl mx-auto px-4 py-8 flex flex-col items-center gap-3 text-sm;
  }

  &__copyright {
    color: var(--color-text-secondary);
  }

  &__made {
    @apply text-xs;
    color: var(--color-text-secondary);
    opacity: 0.7;
  }

  &__socials {
    @apply flex items-center gap-3 mt-2;
  }

  &__social {
    @apply p-2 rounded-lg transition-colors duration-200;
    color: var(--color-text-secondary);

    &:hover {
      color: var(--color-text);
      @apply bg-zinc-800/30 dark:bg-zinc-200/30;
    }
  }
}
</style>
