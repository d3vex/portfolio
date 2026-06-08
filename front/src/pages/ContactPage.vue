<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import AppButton from '@/components/ui/AppButton.vue'
import AppInput from '@/components/ui/AppInput.vue'
import { submitContactForm, getContactInfo } from '@/lib/api/contact'
import { useAsyncData } from '@/composables/useAsyncData'
import ServerRack from '@/components/3d/ServerRack.vue'

const { t } = useI18n()
const { data: contactInfo } = useAsyncData(() => getContactInfo())

const form = ref({ name: '', email: '', message: '' })
const submitting = ref(false)
const success = ref(false)
const error = ref('')

async function handleSubmit() {
  submitting.value = true
  error.value = ''
  success.value = false

  const result = await submitContactForm(form.value)
  if (result.error) {
    error.value = result.error
  } else {
    success.value = true
    form.value = { name: '', email: '', message: '' }
  }
  submitting.value = false
}
</script>

<template>
  <section class="contact_page">
    <div class="contact_page__container">
      <div class="contact_page__header">
        <h1 class="contact_page__title">{{ t('contact.title') }}</h1>
        <p class="contact_page__subtitle">{{ t('contact.subtitle') }}</p>
      </div>

      <div class="contact_page__grid">
        <div class="contact_page__left">
          <div class="contact_page__info">
            <div class="contact_page__info-card">
              <Icon icon="mdi:email" class="w-5 h-5 text-accent shrink-0" />
              <div class="min-w-0">
                <p class="font-medium text-sm">{{ contactInfo?.email || 'loan.mata@email.com' }}</p>
                <p class="text-xs text-zinc-500">Best way to reach me</p>
              </div>
            </div>
            <div class="contact_page__info-card">
              <Icon icon="mdi:github" class="w-5 h-5 text-accent shrink-0" />
              <div class="min-w-0">
                <a href="https://github.com/D3vex" target="_blank" rel="noopener" class="font-medium text-sm hover:text-accent truncate block">github.com/D3vex</a>
                <p class="text-xs text-zinc-500">Open source &amp; projects</p>
              </div>
            </div>
            <div class="contact_page__info-card">
              <Icon icon="mdi:linkedin" class="w-5 h-5 text-accent shrink-0" />
              <div class="min-w-0">
                <a href="https://linkedin.com/in/loanmata" target="_blank" rel="noopener" class="font-medium text-sm hover:text-accent truncate block">linkedin.com/in/loanmata</a>
                <p class="text-xs text-zinc-500">Professional profile</p>
              </div>
            </div>
            <div class="contact_page__info-card">
              <Icon icon="mdi:map-marker" class="w-5 h-5 text-accent shrink-0" />
              <div class="min-w-0">
                <p class="font-medium text-sm">{{ contactInfo?.location || 'France' }}</p>
                <p class="text-xs text-zinc-500">Available for remote work</p>
              </div>
            </div>
          </div>

          <form class="contact_page__form" @submit.prevent="handleSubmit">
            <AppInput
              v-model="form.name"
              :label="t('contact.name')"
              :placeholder="t('contact.placeholder_name')"
              iconLeft="mdi:account"
            />

            <AppInput
              v-model="form.email"
              :label="t('contact.email')"
              :placeholder="t('contact.placeholder_email')"
              type="email"
              iconLeft="mdi:email"
            />

            <AppInput
              v-model="form.message"
              :label="t('contact.message')"
              :placeholder="t('contact.placeholder_message')"
              textarea
              :rows="5"
            />

            <div v-if="error" class="contact_page__error">
              <Icon icon="mdi:alert-circle" class="w-4 h-4 shrink-0" />
              <span>{{ error }}</span>
            </div>

            <div v-if="success" class="contact_page__success">
              <Icon icon="mdi:check-circle" class="w-4 h-4 shrink-0" />
              <span>{{ t('contact.success') }}</span>
            </div>

            <AppButton
              type="submit"
              variant="primary"
              size="lg"
              :loading="submitting"
              :disabled="submitting"
              iconRight="mdi:send"
            >
              {{ t('contact.send') }}
            </AppButton>
          </form>
        </div>

        <div class="contact_page__right">
          <ServerRack />
        </div>
      </div>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.contact_page {
  @apply py-20 px-4;

  &__container {
    @apply max-w-6xl mx-auto;
  }

  &__header {
    @apply text-center mb-12;
  }

  &__title {
    @apply text-4xl md:text-5xl font-heading font-bold mb-4;
    color: var(--color-text);
  }

  &__subtitle {
    @apply text-lg;
    color: var(--color-text-secondary);
  }

  &__grid {
    @apply grid grid-cols-1 lg:grid-cols-2 gap-8 items-start;
  }

  &__left {
    @apply space-y-8;
  }

  &__info {
    @apply grid grid-cols-1 sm:grid-cols-2 gap-3;
  }

  &__info-card {
    @apply flex items-start gap-3 p-3.5 rounded-xl border;
    background-color: var(--color-surface);
    border-color: var(--color-border);
    color: var(--color-text);
  }

  &__form {
    @apply space-y-5 p-6 rounded-xl border;
    background-color: var(--color-surface);
    border-color: var(--color-border);
  }

  &__right {
    @apply lg:sticky lg:top-24 h-[500px];
  }

  &__error {
    @apply flex items-center gap-2 p-3 rounded-lg text-sm;
    @apply bg-red-500/10 text-red-500 border border-red-500/20;
  }

  &__success {
    @apply flex items-center gap-2 p-3 rounded-lg text-sm;
    @apply bg-green-500/10 text-green-500 border border-green-500/20;
  }
}
</style>
