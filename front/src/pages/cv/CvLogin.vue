<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCvStore } from '@/stores/cv'

const router = useRouter()
const store = useCvStore()

const username = ref('')
const password = ref('')
const error = ref('')
const isRegister = ref(false)

async function submit() {
  error.value = ''
  try {
    if (isRegister.value) {
      await store.register(username.value, password.value)
    } else {
      await store.login(username.value, password.value)
    }
    router.push('/admin/dashboard')
  } catch (e: any) {
    error.value = e.message
  }
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center px-4">
    <div class="w-full max-w-md">
      <div class="bg-surface dark:bg-surface-900 rounded-2xl border border-gray-200 dark:border-surface-700 p-8 shadow-xl">
        <div class="text-center mb-8">
          <h1 class="text-2xl font-heading font-bold">CV Manager</h1>
          <p class="text-surface-500 mt-1">Sign in to manage your CVs</p>
        </div>

        <form @submit.prevent="submit" class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-1">Username</label>
            <input v-model="username" type="text" required
              class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 focus:border-accent outline-none transition-all" />
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Password</label>
            <input v-model="password" type="password" required
              class="w-full px-4 py-2.5 rounded-xl border border-gray-200 dark:border-surface-700 bg-white dark:bg-surface-800 focus:ring-2 focus:ring-accent/50 focus:border-accent outline-none transition-all" />
          </div>

          <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

          <button type="submit"
            class="w-full py-2.5 px-4 bg-accent hover:bg-accent-hover text-white rounded-xl font-medium transition-colors cursor-pointer">
            {{ isRegister ? 'Create Account' : 'Sign In' }}
          </button>
        </form>

        <p class="text-center mt-4 text-sm text-surface-500">
          {{ isRegister ? 'Already have an account?' : "Don't have an account?" }}
          <button @click="isRegister = !isRegister" class="text-accent hover:underline cursor-pointer">
            {{ isRegister ? 'Sign In' : 'Register' }}
          </button>
        </p>
      </div>
    </div>
  </div>
</template>
