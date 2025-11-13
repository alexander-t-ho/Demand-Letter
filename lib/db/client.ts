// Conditional import to handle cases where Prisma is not generated (e.g., Vercel frontend-only builds)
let PrismaClient: any
try {
  PrismaClient = require('@prisma/client').PrismaClient
} catch (error) {
  // Prisma not available (e.g., in frontend-only builds)
  PrismaClient = null
}

const globalForPrisma = globalThis as unknown as {
  prisma: any | undefined
}

// Only initialize Prisma on server-side when available
// In frontend builds or when Prisma is not generated, this will be null
export const prisma =
  typeof window === 'undefined' && PrismaClient
    ? globalForPrisma.prisma ??
      new PrismaClient({
        log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
      })
    : (null as any)

if (typeof window === 'undefined' && process.env.NODE_ENV !== 'production' && prisma) {
  globalForPrisma.prisma = prisma
}

export default prisma

