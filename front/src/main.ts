import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { createI18n } from 'vue-i18n'
import { Icon } from '@iconify/vue'

import App from './App.vue'
import router from './router/index.ts'
import en from './locales/en.json'
import fr from './locales/fr.json'
import './app.css'

const i18n = createI18n({
  locale: 'en',
  fallbackLocale: 'en',
  messages: { en, fr },
})

const app = createApp(App)
app.use(createPinia())
app.use(router)
app.use(i18n)
app.component('Icon', Icon)

app.mount('#app')
