import { SectionType } from '@/lib/ai/types'

// Common document interfaces
export interface CaseInfo {
  claimNumber?: string
  insured?: string
  dateOfLoss?: string
  client?: string
  adjuster?: string
  dateOfLetter?: string
  target?: string
}

export interface DocumentSection {
  id: string
  sectionType: string
  content: string
  order: number
  isGenerated: boolean
}

export interface DocumentMetadata {
  caseInfo?: CaseInfo
  submissionDetails?: string
  strategicPositioning?: string
  selectedProviders?: string[]
  selectedTranscriptions?: string[]
  customInstructions?: Record<string, string>
  customPrompt?: string
  styleSettings?: {
    copyStyle?: boolean
    matchTone?: boolean
  }
  styleMetadata?: StyleMetadata
  toneMetadata?: ToneMetadata
}

export interface StyleMetadata {
  fonts?: {
    heading?: string
    body?: string
  }
  spacing?: {
    paragraph?: number
    section?: number
  }
  headers?: {
    style?: 'bold' | 'underline' | 'both'
    size?: number
  }
  lists?: {
    style?: 'bullet' | 'numbered'
  }
}

export interface ToneMetadata {
  formality?: 'formal' | 'professional' | 'assertive' | 'conversational'
  voice?: string
  descriptors?: string[]
}

export interface DocumentWithSections {
  id: string
  filename: string
  status: string
  templateId: string | null
  template?: {
    id: string
    name: string
    sections?: string[]
  } | null
  metadata: DocumentMetadata
  sections: DocumentSection[]
}

export interface AvailableData {
  providers: Array<{ id: string; [key: string]: unknown }>
  transcriptions: Array<{ id: string; [key: string]: unknown }>
  expertReports: Array<{ id: string; [key: string]: unknown }>
}

// Section constants
export const DEFAULT_SECTION_TYPES: SectionType[] = [
  'introduction',
  'statement_of_facts',
  'liability',
  'damages',
  'medical_chronology',
  'economic_damages',
  'treatment_reasonableness',
  'conclusion',
]

export const SECTION_LABELS: Record<SectionType, string> = {
  introduction: 'Introduction',
  statement_of_facts: 'Statement of Facts',
  liability: 'Liability',
  damages: 'Damages',
  medical_chronology: 'Medical/Injury Chronology',
  economic_damages: 'Economic Damages',
  treatment_reasonableness: 'Reasonableness and Necessity of Treatment',
  conclusion: 'Conclusion',
  coverage_analysis: 'Coverage Analysis',
  policy_limits: 'Policy Limits',
  negligence_analysis: 'Negligence Analysis',
  comparative_fault: 'Comparative Fault',
  violations: 'Violations',
  remedies: 'Remedies',
  statutory_damages: 'Statutory Damages',
  contract_terms: 'Contract Terms',
  breach_analysis: 'Breach Analysis',
  business_context: 'Business Context',
  business_impact: 'Business Impact',
  legal_basis: 'Legal Basis',
  circumstances: 'Circumstances',
  best_interests: 'Best Interests',
  estate_context: 'Estate Context',
}

export const SECTION_KEYWORDS: Record<SectionType, string[]> = {
  introduction: ['introduction', 'intro', 'opening', 'opening paragraph'],
  statement_of_facts: ['statement of facts', 'facts', 'factual', 'incident', 'what happened'],
  liability: ['liability', 'negligence', 'fault', 'responsible', 'responsibility', 'at fault'],
  damages: ['damages', 'damage', 'injuries', 'losses', 'harm'],
  medical_chronology: ['medical', 'treatment', 'chronology', 'medical history', 'medical treatment', 'injury chronology'],
  economic_damages: ['economic', 'financial', 'wages', 'income', 'lost wages', 'economic loss'],
  treatment_reasonableness: ['treatment', 'reasonable', 'necessity', 'medical necessity', 'reasonableness'],
  conclusion: ['conclusion', 'closing', 'summary', 'final', 'closing paragraph'],
  coverage_analysis: ['coverage', 'insurance coverage', 'policy coverage'],
  policy_limits: ['policy limits', 'limits', 'policy limit'],
  negligence_analysis: ['negligence', 'negligent', 'negligence analysis'],
  comparative_fault: ['comparative fault', 'comparative', 'fault'],
  violations: ['violations', 'violation', 'statutory violations'],
  remedies: ['remedies', 'remedy', 'legal remedies'],
  statutory_damages: ['statutory damages', 'statutory', 'statutory relief'],
  contract_terms: ['contract terms', 'contract', 'agreement terms'],
  breach_analysis: ['breach', 'breach of contract', 'contract breach'],
  business_context: ['business context', 'business', 'company context'],
  business_impact: ['business impact', 'impact', 'business effect'],
  legal_basis: ['legal basis', 'legal foundation', 'basis'],
  circumstances: ['circumstances', 'situation', 'context'],
  best_interests: ['best interests', 'interests', 'benefit'],
  estate_context: ['estate context', 'estate', 'probate context'],
}

