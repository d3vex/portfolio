import type { ApiResponse } from '@/lib/types'

const MOCK_DELAY = 300

export async function mockFetch<T>(data: T): Promise<ApiResponse<T>> {
  await new Promise(resolve => setTimeout(resolve, MOCK_DELAY))
  return {
    data,
    error: null,
    loading: false,
  }
}

export async function mockError<T>(message: string): Promise<ApiResponse<T>> {
  await new Promise(resolve => setTimeout(resolve, MOCK_DELAY))
  return {
    data: null,
    error: message,
    loading: false,
  }
}

export async function mockPaginatedFetch<T>(
  data: T[],
  page: number = 1,
  pageSize: number = 10
): Promise<{ data: T[]; error: null; loading: false; total: number; page: number; pageSize: number }> {
  await new Promise(resolve => setTimeout(resolve, MOCK_DELAY))
  const start = (page - 1) * pageSize
  const paginated = data.slice(start, start + pageSize)
  return {
    data: paginated,
    error: null,
    loading: false,
    total: data.length,
    page,
    pageSize,
  }
}
