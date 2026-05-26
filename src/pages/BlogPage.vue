<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAsyncData } from '@/composables/useAsyncData'
import { getBlogPosts } from '@/lib/api/blog'

const { t } = useI18n()
const router = useRouter()
const { data: posts, loading } = useAsyncData(() => getBlogPosts(1, 20))

function viewPost(slug: string) {
  router.push(`/blog/${slug}`)
}
</script>

<template>
  <section class="blog_page">
    <div class="blog_page__container">
      <div class="blog_page__header">
        <h1 class="blog_page__title">{{ t('blog.title') }}</h1>
        <p class="blog_page__subtitle">{{ t('blog.subtitle') }}</p>
      </div>

      <div v-if="loading" class="blog_page__loading">
        <div v-for="n in 4" :key="n" class="blog_page__skeleton" />
      </div>

      <div v-else-if="!posts || posts.length === 0" class="blog_page__empty">
        <Icon icon="mdi:book-open-outline" class="w-16 h-16 mb-4 opacity-30" />
        <p>No posts yet</p>
      </div>

      <div v-else class="blog_page__grid">
        <article
          v-for="post in posts"
          :key="post.id"
          class="blog_page__card"
          @click="viewPost(post.slug)"
        >
          <div class="blog_page__card-tags">
            <span v-for="tag in post.tags.slice(0, 3)" :key="tag" class="blog_page__card-tag">
              {{ tag }}
            </span>
          </div>
          <h3 class="blog_page__card-title">{{ post.title }}</h3>
          <p class="blog_page__card-excerpt">{{ post.excerpt }}</p>
          <div class="blog_page__card-footer">
            <span class="blog_page__card-date font-mono text-xs">{{ post.publishedAt }}</span>
            <span class="blog_page__card-reading font-mono text-xs">{{ post.readingTime }} min read</span>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>

<style lang="scss" scoped>
.blog_page {
  @apply py-20 px-4;

  &__container {
    @apply max-w-4xl mx-auto;
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

  &__loading {
    @apply grid grid-cols-1 md:grid-cols-2 gap-6;
  }

  &__skeleton {
    @apply h-48 rounded-xl animate-pulse;
    background-color: var(--color-surface);
    border: 1px solid var(--color-border);
  }

  &__empty {
    @apply text-center py-20;
    color: var(--color-text-secondary);
  }

  &__grid {
    @apply grid grid-cols-1 md:grid-cols-2 gap-6;
  }

  &__card {
    @apply p-6 rounded-xl border transition-all duration-200 cursor-pointer;
    background-color: var(--color-surface);
    border-color: var(--color-border);

    &:hover {
      border-color: var(--color-accent);
      transform: translateY(-2px);
    }
  }

  &__card-tags {
    @apply flex flex-wrap gap-1.5 mb-3;
  }

  &__card-tag {
    @apply px-2 py-0.5 rounded text-xs font-mono;
    background-color: var(--color-accent);
    color: white;
    opacity: 0.8;
  }

  &__card-title {
    @apply text-lg font-heading font-bold mb-2;
    color: var(--color-text);
  }

  &__card-excerpt {
    @apply text-sm mb-4 line-clamp-2;
    color: var(--color-text-secondary);
  }

  &__card-footer {
    @apply flex items-center justify-between;
    color: var(--color-text-secondary);
  }
}
</style>
