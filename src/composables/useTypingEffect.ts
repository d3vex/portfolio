import { ref, onMounted, onUnmounted } from 'vue';

export interface TypingEffectOptions {
  phrases: string[];
  typingSpeed?: number;
  deletingSpeed?: number;
  pauseDuration?: number;
  loop?: boolean;
}

export function useTypingEffect(options: TypingEffectOptions) {
  const {
    phrases,
    typingSpeed = 100,
    deletingSpeed = 50,
    pauseDuration = 2000,
    loop = true,
  } = options;

  const displayText = ref('');
  const currentPhraseIndex = ref(0);
  const isDeleting = ref(false);
  const isPaused = ref(false);
  
  let timeoutId: ReturnType<typeof setTimeout> | null = null;

  const getCommonPrefixLength = (str1: string, str2: string): number => {
    let i = 0;
    const minLength = Math.min(str1.length, str2.length);
    while (i < minLength && str1.charAt(i).toLowerCase() === str2.charAt(i).toLowerCase()) {
      i++;
    }
    return i;
  };

  const type = () => {
    if (phrases.length === 0) return;
    
    const currentPhrase = phrases[currentPhraseIndex.value];
    if (!currentPhrase) return;
    
    if (isPaused.value) {
      timeoutId = setTimeout(() => {
        isPaused.value = false;
        isDeleting.value = true;
        type();
      }, pauseDuration);
      return;
    }

    if (isDeleting.value) {
      // Find the next phrase and common prefix length
      const nextPhraseIndex = (currentPhraseIndex.value + 1) % phrases.length;
      const nextPhrase = phrases[nextPhraseIndex];
      const commonPrefixLength = nextPhrase ? getCommonPrefixLength(currentPhrase, nextPhrase) : 0;
      
      // Delete characters until we reach the common prefix
      if (displayText.value.length > commonPrefixLength) {
        displayText.value = currentPhrase.substring(0, displayText.value.length - 1);
        timeoutId = setTimeout(type, deletingSpeed);
      } else {
        // Move to next phrase
        isDeleting.value = false;
        currentPhraseIndex.value = nextPhraseIndex;
        
        // Stop if not looping and we've shown all phrases
        if (!loop && currentPhraseIndex.value === 0) {
          return;
        }
        
        timeoutId = setTimeout(type, typingSpeed);
      }
    } else {
      // Typing characters
      if (displayText.value.length < currentPhrase.length) {
        displayText.value = currentPhrase.substring(0, displayText.value.length + 1);
        timeoutId = setTimeout(type, typingSpeed);
      } else {
        // Pause before deleting
        isPaused.value = true;
        timeoutId = setTimeout(type, pauseDuration);
      }
    }
  };

  const start = () => {
    type();
  };

  const stop = () => {
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
  };

  const reset = () => {
    stop();
    displayText.value = '';
    currentPhraseIndex.value = 0;
    isDeleting.value = false;
    isPaused.value = false;
  };

  onMounted(() => {
    start();
  });

  onUnmounted(() => {
    stop();
  });

  return {
    displayText,
    currentPhraseIndex,
    isDeleting,
    start,
    stop,
    reset,
  };
}
