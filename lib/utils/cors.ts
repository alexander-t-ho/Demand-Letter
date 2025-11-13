import { NextResponse } from 'next/server'

/**
 * CORS headers for API routes
 * Allows requests from Vercel frontend to Render backend
 */
export function getCorsHeaders(request: Request): Record<string, string> {
  const origin = request.headers.get('origin')
  const allowedOrigins = [
    process.env.NEXT_PUBLIC_FRONTEND_URL,
    'http://localhost:3000',
    'http://localhost:3003',
    // Add your Vercel domain here
  ].filter(Boolean) as string[]

  // Allow requests from allowed origins or any origin in development
  const allowOrigin = 
    process.env.NODE_ENV === 'development' || 
    (origin && allowedOrigins.includes(origin))
      ? origin || '*'
      : allowedOrigins[0] || '*'

  return {
    'Access-Control-Allow-Origin': allowOrigin,
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS, PATCH',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Max-Age': '86400',
  }
}

/**
 * Handle OPTIONS preflight requests
 */
export function handleCorsPreflight(request: Request): NextResponse | null {
  if (request.method === 'OPTIONS') {
    return new NextResponse(null, {
      status: 200,
      headers: getCorsHeaders(request),
    })
  }
  return null
}

/**
 * Add CORS headers to a response
 */
export function addCorsHeaders(
  response: NextResponse,
  request: Request
): NextResponse {
  const corsHeaders = getCorsHeaders(request)
  Object.entries(corsHeaders).forEach(([key, value]) => {
    response.headers.set(key, value)
  })
  return response
}

