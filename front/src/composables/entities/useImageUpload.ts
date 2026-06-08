import { ref } from 'vue'

const API_BASE = 'http://localhost:3001/api'

function getToken(): string | null {
  return localStorage.getItem('cv_token')
}

export function useImageUpload() {
  const uploading = ref(false)
  const error = ref<string | null>(null)

  async function upload(file: File): Promise<{ id: string; url: string } | null> {
    uploading.value = true
    error.value = null
    try {
      const formData = new FormData()
      formData.append('file', file)
      const headers: Record<string, string> = {}
      const token = getToken()
      if (token) headers['Authorization'] = `Bearer ${token}`
      const res = await fetch(`${API_BASE}/images/upload`, {
        method: 'POST',
        headers,
        body: formData,
      })
      if (!res.ok) throw new Error('Upload failed')
      const data = await res.json()
      return data
    } catch (e: any) {
      error.value = e.message
      return null
    } finally {
      uploading.value = false
    }
  }

  return { uploading, error, upload }
}
