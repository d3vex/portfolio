<template>
  <div class="max-w-3xl mx-auto py-16 px-8">
    <!-- Title Section -->
    <div class="text-center mb-16 animate-fade-in-down">
      <h1
        class="
          text-[clamp(2.5rem,5vw,4rem)]
          font-bold
          mb-4
          bg-gradient-to-br
          from-accent
          to-red-600
          bg-clip-text
          text-transparent
        "
      >
        Get In Touch
      </h1>

      <p
        class="
          text-[clamp(1rem,2vw,1.25rem)]
          text-text-secondary
        "
      >
        Have a question or want to work together?
      </p>
    </div>

    <!-- Contact Form Card -->
    <GlassCard class="animate-fade-in">
      <form
        @submit.prevent="handleSubmit"
        class="flex flex-col gap-6"
      >
        <GlassInput
          v-model="formData.name"
          label="Name"
          placeholder="Your name"
          :error="errors.name"
        />

        <GlassInput
          v-model="formData.email"
          type="email"
          label="Email"
          placeholder="your.email@example.com"
          :error="errors.email"
        />

        <GlassInput
          v-model="formData.subject"
          label="Subject"
          placeholder="What's this about?"
          :error="errors.subject"
        />

        <GlassInput
          v-model="formData.message"
          type="textarea"
          label="Message"
          placeholder="Your message..."
          :rows="6"
          :error="errors.message"
        />

        <!-- Success / Error Message -->
        <div
          v-if="submitMessage"
          :class="[
            'p-4 rounded-xl text-center font-medium animate-slide-in',
            submitSuccess
              ? 'bg-[rgba(16,185,129,0.15)] border border-secondary text-secondary'
              : 'bg-[rgba(239,68,68,0.15)] border border-danger text-danger'
          ]"
        >
          {{ submitMessage }}
        </div>

        <!-- Submit button -->
        <GlassButton type="submit" :disabled="isSubmitting" size="large">
          {{ isSubmitting ? 'Sending...' : 'Send Message' }}
        </GlassButton>
      </form>
    </GlassCard>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useContacts } from '@/composables/useContacts';
import { useForm } from '@/composables/useForm';
import GlassCard from '@/components/GlassCard.vue';
import GlassInput from '@/components/GlassInput.vue';
import GlassButton from '@/components/GlassButton.vue';

const { createContact } = useContacts();

const { formData, errors, isSubmitting, resetForm, validate } = useForm({
  name: '',
  email: '',
  subject: '',
  message: '',
});

const submitMessage = ref('');
const submitSuccess = ref(false);

const validators = {
  name: (value: string) => !value ? 'Name is required' : null,
  email: (value: string) => {
    if (!value) return 'Email is required';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) return 'Invalid email format';
    return null;
  },
  subject: (value: string) => !value ? 'Subject is required' : null,
  message: (value: string) => !value ? 'Message is required' : null,
};

const handleSubmit = async () => {
  if (!validate(validators)) {
    return;
  }

  isSubmitting.value = true;
  submitMessage.value = '';

  try {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    createContact({
      name: formData.value.name,
      email: formData.value.email,
      subject: formData.value.subject,
      message: formData.value.message,
    });

    submitMessage.value = 'Message sent successfully! I\'ll get back to you soon.';
    submitSuccess.value = true;
    resetForm();
    
    // Clear success message after 5 seconds
    setTimeout(() => {
      submitMessage.value = '';
    }, 5000);
  } catch (error) {
    submitMessage.value = 'Failed to send message. Please try again.';
    submitSuccess.value = false;
  } finally {
    isSubmitting.value = false;
  }
};
</script>
