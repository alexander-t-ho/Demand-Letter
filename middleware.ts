import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  // Only apply CORS to API routes
  if (request.nextUrl.pathname.startsWith('/api')) {
    const origin = request.headers.get('origin')
    
    // Allow requests from Vercel frontend or localhost
    const allowedOrigins = [
      process.env.NEXT_PUBLIC_FRONTEND_URL,
      'http://localhost:3000',
      'http://localhost:3003',
    ].filter(Boolean) as string[]

    const allowOrigin = 
      process.env.NODE_ENV === 'development' || 
      (origin && allowedOrigins.includes(origin))
        ? origin || '*'
        : allowedOrigins[0] || '*'

    // Handle preflight requests
    if (request.method === 'OPTIONS') {
      return new NextResponse(null, {
        status: 200,
        headers: {
          'Access-Control-Allow-Origin': allowOrigin,
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS, PATCH',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Max-Age': '86400',
        },
      })
    }

    // Add CORS headers to response
    const response = NextResponse.next()
    response.headers.set('Access-Control-Allow-Origin', allowOrigin)
    response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH')
    response.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With')
    response.headers.set('Access-Control-Allow-Credentials', 'true')
    
    return response
  }

  return NextResponse.next()
}

export const config = {
  matcher: '/api/:path*',
}

