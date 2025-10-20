import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    const users = await prisma.user.findMany({ orderBy: { id: 'asc' } });
    return NextResponse.json({ users });
  } catch (error: unknown) {
    return NextResponse.json({ error: `Internal Server Error: ${error}` }, { status: 500 });
  }
}


