import { NextRequest, NextResponse } from 'next/server'
import { generateSection } from '@/lib/ai/generator'
import { z } from 'zod'
import { handleApiError, parseRequestBody } from '@/lib/utils/api'

const generateRequestSchema = z.object({
  documentId: z.string(),
  sectionType: z.string(),
  context: z.object({
    caseInfo: z.any().optional(), // Keep as any for flexibility with metadata
    selectedProviders: z.array(z.string()).optional(),
    sourceDocuments: z.array(z.string()).optional(),
    styleMetadata: z.any().optional(), // Keep as any for flexibility with metadata
    toneMetadata: z.any().optional(), // Keep as any for flexibility with metadata
    copyStyle: z.boolean().optional(),
    matchTone: z.boolean().optional(),
    customPrompt: z.string().optional(),
  }),
  customPrompt: z.string().optional(),
  prompt: z.string().optional(),
  model: z.string().optional(),
})

// POST /api/generate
export async function POST(request: NextRequest) {
  const parseResult = await parseRequestBody(request, generateRequestSchema)
  
  if (!parseResult.success) {
    return parseResult.response
  }

  try {
    const result = await generateSection(parseResult.data)

    if (!result.success) {
      return NextResponse.json(result, { status: 400 })
    }

    return NextResponse.json(result)
  } catch (error) {
    return handleApiError(error)
  }
}

