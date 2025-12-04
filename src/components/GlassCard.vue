<template>
  <div class="glass-card" :class="{ hoverable, clickable }" @click="handleClick">
    <slot></slot>
  </div>
</template>

<script setup lang="ts">
interface Props {
  hoverable?: boolean;
  clickable?: boolean;
}

withDefaults(defineProps<Props>(), {
  hoverable: false,
  clickable: false,
});

const emit = defineEmits<{
  click: [];
}>();

const handleClick = () => {
  emit('click');
};
</script>

<style scoped>
@reference "../style.css";

.glass-card {
  @apply bg-glass-bg backdrop-blur-md border border-glass-border rounded-xl p-8
   shadow-glass-shadow transition-all duration-300 ease-in-out;
  
  &.hoverable:hover {
    @apply bg-glass-bg-hover border-glass-border-hover shadow-lg shadow-shadow transform -translate-y-1;
  }
  &.clickable {
    @apply cursor-pointer;
  }

}

</style>
