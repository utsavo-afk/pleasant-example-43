import { NextRequest, NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ message: "Hello from Next.js 15 API route!" });
}

export async function POST(request: NextRequest) {
  const data = await request.json();
  return NextResponse.json({
    message: "Hello from Next.js 15 API route!",
    data,
  });
}
