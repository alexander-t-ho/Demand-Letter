import { SectionType, SECTION_KEYWORDS, SECTION_LABELS } from '@/lib/types/common'

/**
 * Get the display label for a section type
 */
export function getSectionLabel(sectionType: string): string {
  return SECTION_LABELS[sectionType as SectionType] || 
    sectionType.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())
}

/**
 * Detect which section type is mentioned in instructions
 */
export function detectSectionFromInstructions(instructions: string): SectionType | null {
  const lowerInstructions = instructions.toLowerCase()
  
  // Check for exact section type matches first (e.g., "introduction", "liability")
  for (const sectionType of Object.keys(SECTION_KEYWORDS) as SectionType[]) {
    if (lowerInstructions.includes(sectionType.replace(/_/g, ' '))) {
      return sectionType
    }
  }
  
  // Then check for keywords
  for (const [sectionType, keywords] of Object.entries(SECTION_KEYWORDS)) {
    if (keywords.some(keyword => lowerInstructions.includes(keyword))) {
      return sectionType as SectionType
    }
  }
  
  return null
}

