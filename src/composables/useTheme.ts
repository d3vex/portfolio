import { ref, watch } from 'vue';

export type Theme = 'light' | 'dark';

const THEME_KEY = 'portfolio-theme';

export function useTheme() {
  // Get initial theme from localStorage or default to light
  const getInitialTheme = (): Theme => {
    const stored = localStorage.getItem(THEME_KEY);
    if (stored === 'light' || stored === 'dark') {
      return stored;
    }
    // Check system preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      return 'dark';
    }
    return 'light';
  };

  const currentTheme = ref<Theme>(getInitialTheme());

  // Apply theme to document
  const applyTheme = (theme: Theme) => {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem(THEME_KEY, theme);
  };

  // Watch for theme changes
  watch(currentTheme, (newTheme) => {
    applyTheme(newTheme);
  }, { immediate: true });

  const toggleTheme = () => {
    currentTheme.value = currentTheme.value === 'light' ? 'dark' : 'light';
  };

  const setTheme = (theme: Theme) => {
    currentTheme.value = theme;
  };

  return {
    currentTheme,
    toggleTheme,
    setTheme,
  };
}
