import { CaseInfo, StyleMetadata, ToneMetadata, SectionType } from '@/lib/types/common'

// Re-export SectionType for backward compatibility
export type { SectionType }

export interface GenerationContext {
  caseInfo?: CaseInfo
  selectedProviders?: string[]
  sourceDocuments?: string[]
  styleMetadata?: StyleMetadata
  toneMetadata?: ToneMetadata
  copyStyle?: boolean
  matchTone?: boolean
  customPrompt?: string
  analysisPoints?: {
    legalPoints?: Array<{id: string, text: string, category: string}>
    facts?: Array<{id: string, text: string, date?: string}>
    damages?: Array<{id: string, text: string, amount?: number, type: string}>
  }
  analysisId?: string
  targetPageCount?: number
}

export interface GenerationRequest {
  documentId: string
  sectionType: string
  context: GenerationContext
  prompt?: string
  model?: string
}

export interface GenerationResponse {
  success: boolean
  content?: string
  modelUsed?: string
  responseTime?: number
  error?: string
}

export interface StreamChunk {
  chunk?: string
  done?: boolean
  modelUsed?: string
  responseTime?: number
  error?: string
}

