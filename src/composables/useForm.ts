import { ref } from 'vue';

export function useForm<T extends Record<string, any>>(initialValues: T) {
  const formData = ref<T>({ ...initialValues });
  const errors = ref<Partial<Record<keyof T, string>>>({});
  const isSubmitting = ref(false);

  const resetForm = () => {
    formData.value = { ...initialValues };
    errors.value = {};
    isSubmitting.value = false;
  };

  const setError = (field: keyof T, message: string) => {
    errors.value[field] = message;
  };

  const clearError = (field: keyof T) => {
    delete errors.value[field];
  };

  const clearErrors = () => {
    errors.value = {};
  };

  const validate = (validators: Partial<Record<keyof T, (value: any) => string | null>>) => {
    clearErrors();
    let isValid = true;

    for (const field in validators) {
      const validator = validators[field];
      if (validator) {
        const error = validator(formData.value[field]);
        if (error) {
          setError(field, error);
          isValid = false;
        }
      }
    }

    return isValid;
  };

  return {
    formData,
    errors,
    isSubmitting,
    resetForm,
    setError,
    clearError,
    clearErrors,
    validate,
  };
}
