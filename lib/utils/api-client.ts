/**
 * API Client Utility
 * Handles API calls with support for both same-origin and cross-origin (Vercel frontend -> Render backend)
 */

// Get API base URL from environment variable or use relative path
export function getApiUrl(path: string): string {
  // Remove leading slash if present to avoid double slashes
  const cleanPath = path.startsWith('/') ? path : `/${path}`
  
  // If NEXT_PUBLIC_API_URL is set (for Vercel frontend -> Render backend), use it
  if (typeof window !== 'undefined' && process.env.NEXT_PUBLIC_API_URL) {
    const baseUrl = process.env.NEXT_PUBLIC_API_URL.replace(/\/$/, '') // Remove trailing slash
    return `${baseUrl}${cleanPath}`
  }
  
  // For server-side or same-origin, use relative path
  return cleanPath
}

/**
 * Fetch wrapper that automatically handles API URL resolution
 */
export async function apiFetch(
  path: string,
  options?: RequestInit
): Promise<Response> {
  const url = getApiUrl(path)
  
  // Determine content type - don't set for FormData
  const isFormData = options?.body instanceof FormData
  const headers: HeadersInit = {
    ...(isFormData ? {} : { 'Content-Type': 'application/json' }),
    ...options?.headers,
  }
  
  return fetch(url, {
    ...options,
    credentials: 'include', // Include cookies for authentication
    headers,
  })
}

