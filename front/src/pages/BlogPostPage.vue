<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { getBlogPost } from '@/lib/api/blog'

const route = useRoute()
const router = useRouter()
const { t } = useI18n()
const { data: post, loading } = useAsyncData(() => getBlogPost(route.params.slug as string))
</script>

<template>
  <section class="blog_post">
    <div class="blog_post__container">
      <button class="blog_post__back" @click="router.push('/blog')">
        <Icon icon="mdi:arrow-left" class="w-5 h-5" />
        Back to blog
      </button>

      <div v-if="loading" class="blog_post__loading">
        <div class="blog_post__skeleton" />
        <div class="blog_post__skeleton" />
        <div class="blog_post__skeleton h-64" />
      </div>

      <template v-else-if="post">
        <div class="blog_post__header">
          <div class="blog_post__tags">
            <span v-for="tag in post.tags" :key="tag" class="blog_post__tag">
              {{ tag }}
            </span>
          </div>
          <h1 class="blog_post__title">{{ post.title }}</h1>
          <div class="blog_post__meta">
            <span> {{ t('blog.published_on') }} {{ post.publishedAt }}</span>
            <span>·</span>
            <span>{{ post.readingTime }} min read</span>
          </div>
        </div>
        <div class="blog_post__content" v-html="post.content" />
      </template>

      <div v-else class="blog_post__not-found">
        <Icon icon="mdi:alert-circle-outline" class="w-16 h-16 mb-4 opacity-30" />
        <p>Post not found</p>
        <button class="blog_post__back-link mt-4" @click="router.push('/blog')">
          Back to blog
        </button>
      </div>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.blog_post {
  @apply py-20 px-4;

  &__container {
    @apply max-w-3xl mx-auto;
  }

  &__back {
    @apply flex items-center gap-2 text-sm mb-8 transition-colors cursor-pointer;
    color: var(--color-text-secondary);

    &:hover {
      color: var(--color-accent);
    }
  }

  &__loading {
    @apply space-y-4;
  }

  &__skeleton {
    @apply h-12 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  &__header {
    @apply mb-10;
  }

  &__tags {
    @apply flex flex-wrap gap-2 mb-4;
  }

  &__tag {
    @apply px-2.5 py-1 rounded text-xs font-mono;
    background-color: var(--color-accent);
    color: white;
    opacity: 0.8;
  }

  &__title {
    @apply text-3xl md:text-4xl font-heading font-bold mb-4;
    color: var(--color-text);
  }

  &__meta {
    @apply flex items-center gap-2 text-sm font-mono;
    color: var(--color-text-secondary);
  }

  &__content {
    @apply prose prose-zinc max-w-none;
    color: var(--color-text-secondary);

    :deep(h1), :deep(h2), :deep(h3), :deep(h4) {
      color: var(--color-text);
    }

    :deep(code) {
      @apply px-1.5 py-0.5 rounded text-sm font-mono;
      background-color: var(--color-surface);
      border: 1px solid var(--color-border);
    }

    :deep(pre) {
      @apply p-4 rounded-xl overflow-x-auto;
      background-color: var(--color-surface);
      border: 1px solid var(--color-border);
    }
  }

  &__not-found {
    @apply text-center py-20;
    color: var(--color-text-secondary);
  }

  &__back-link {
    @apply text-accent hover:underline;
  }
}
</style>
