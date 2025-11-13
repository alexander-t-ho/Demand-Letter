import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

export interface ApiError {
  success: false
  error: string | z.ZodError['errors']
}

export interface ApiSuccess<T = unknown> {
  success: true
  data?: T
}

export type ApiResponse<T = unknown> = ApiSuccess<T> | ApiError

/**
 * Handle API errors consistently
 */
export function handleApiError(error: unknown): NextResponse<ApiError> {
  if (error instanceof z.ZodError) {
    return NextResponse.json(
      { success: false, error: error.errors },
      { status: 400 }
    )
  }

  console.error('API Error:', error)
  return NextResponse.json(
    {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error',
    },
    { status: 500 }
  )
}

/**
 * Create a success response
 */
export function createSuccessResponse<T>(data?: T, status = 200): NextResponse<ApiSuccess<T>> {
  return NextResponse.json({ success: true, data }, { status })
}

/**
 * Create an error response
 */
export function createErrorResponse(
  error: string,
  status = 400
): NextResponse<ApiError> {
  return NextResponse.json({ success: false, error }, { status })
}

/**
 * Parse and validate request body with Zod schema
 */
export async function parseRequestBody<T>(
  request: NextRequest,
  schema: z.ZodSchema<T>
): Promise<{ success: true; data: T } | { success: false; response: NextResponse }> {
  try {
    const body = await request.json()
    const validated = schema.parse(body)
    return { success: true, data: validated }
  } catch (error) {
    if (error instanceof z.ZodError) {
      return {
        success: false,
        response: NextResponse.json(
          { success: false, error: error.errors },
          { status: 400 }
        ),
      }
    }
    return {
      success: false,
      response: NextResponse.json(
        { success: false, error: 'Invalid request body' },
        { status: 400 }
      ),
    }
  }
}

