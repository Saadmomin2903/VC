import { NextRequest, NextResponse } from 'next/server'
import { supabase } from '@/lib/supabase'


// Download configuration
const DOWNLOAD_CONFIG = {
  'augment-macos': {
    filename: 'Augment-v1.0.0-macOS.dmg',
    displayName: 'Augment for macOS',
    version: '1.0.0',
    size: '15.2 MB',
    mimeType: 'application/x-apple-diskimage',
    checksum: 'sha256:a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456',
    description: 'Universal Binary for Intel and Apple Silicon Macs',
    downloadUrl: 'https://8qsgkc8xxtebfxp0.public.blob.vercel-storage.com/Augment-4Eg9UHneIX9WkktyW3uacBwPlTbsUW.dmg',
  },
  'augment-github': {
    filename: 'Augment-v1.0.0-Source.zip',
    displayName: 'Augment Source Code',
    version: '1.0.0',
    size: '2.8 MB',
    mimeType: 'application/zip',
    checksum: 'sha256:b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567a',
    description: 'Source code for Augment',
    downloadUrl: 'https://github.com/Saadmomin2903/VC/releases/download/v1.0.1/Augment.dmg',
  },
}

type DownloadType = keyof typeof DOWNLOAD_CONFIG

// Track download analytics
async function trackDownload(downloadType: DownloadType, userAgent: string, ip: string) {
  console.log(`Download tracked: ${downloadType} from ${ip} using ${userAgent}`)
}



export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const type = searchParams.get('type') || 'augment-macos'
    
    if (!DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]) {
      return NextResponse.json({ error: 'Invalid download type' }, { status: 400 })
    }

    const downloadInfo = DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]

    const headers = request.headers
    const userAgent = headers.get('user-agent')?.toString() || 'Unknown'
    const ip = headers.get('x-forwarded-for')?.toString() || 
              headers.get('x-real-ip')?.toString() || 
              'Unknown'
    await trackDownload(type as DownloadType, userAgent, ip)

    // Increment download count in Supabase
    await supabase.rpc('increment_download_count', { download_type: type })

    return NextResponse.redirect(downloadInfo.downloadUrl)

  } catch (error) {
     console.error('Download GET error:', error)
     return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
   }
}

export async function POST(request: NextRequest) {
  try {
    const { type = 'augment-macos' } = await request.json()
    
    if (!DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]) {
      return NextResponse.json({ error: 'Invalid download type' }, { status: 400 })
    }

    const downloadInfo = DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]

    const headers = request.headers
    const userAgent = headers.get('user-agent')?.toString() || 'Unknown'
    const ip = headers.get('x-forwarded-for')?.toString() || 
              headers.get('x-real-ip')?.toString() || 
              'Unknown'
    await trackDownload(type as DownloadType, userAgent, ip)

    // Increment download count in Supabase
    await supabase.rpc('increment_download_count', { download_type: type })

    // Return download information as JSON instead of redirecting
    return NextResponse.json({ 
      download: {
        ...downloadInfo,
        timestamp: new Date().toISOString()
      }
    })

   } catch (error) {
     console.error('Download POST error:', error)
     return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
   }
}
