import { PrismaClient } from '@prisma/client';

// Evita múltiples instancias en desarrollo con HMR
const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient };

export const prisma: PrismaClient =
  globalForPrisma.prisma ?? new PrismaClient({});

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}


