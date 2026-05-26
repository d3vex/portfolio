<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import AppButton from '@/components/ui/AppButton.vue'

const router = useRouter()
const { t } = useI18n()
</script>

<template>
  <section class="not_found">
    <div class="not_found__content">
      <h1 class="not_found__code">404</h1>
      <h2 class="not_found__title">{{ t('errors.404_title') }}</h2>
      <p class="not_found__message">{{ t('errors.404_message') }}</p>
      <AppButton variant="primary" iconLeft="mdi:arrow-left" @click="router.push('/')">
        {{ t('errors.404_back') }}
      </AppButton>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.not_found {
  @apply min-h-[60vh] flex items-center justify-center px-4;

  &__content {
    @apply text-center max-w-md;
  }

  &__code {
    @apply text-8xl font-heading font-bold mb-4;
    color: var(--color-accent);
    opacity: 0.5;
  }

  &__title {
    @apply text-2xl font-heading font-bold mb-3;
    color: var(--color-text);
  }

  &__message {
    @apply mb-8;
    color: var(--color-text-secondary);
  }
}
</style>
