import { NextRequest, NextResponse } from 'next/server'
import path from 'path'
import fs from 'fs/promises'

// Download configuration
const DOWNLOAD_CONFIG = {
  'augment-macos': {
    filename: 'Augment-v1.0.0-macOS.dmg',
    displayName: 'Augment for macOS',
    version: '1.0.0',
    size: '15.2 MB',
    mimeType: 'application/x-apple-diskimage',
    checksum: 'sha256:ff9f25ca608e28ec2d32375fa69d023fb2df13438cbc58f02dc5d468f63437ab',
    description: 'Universal Binary for Intel and Apple Silicon Macs',
    path: '/downloads/Augment-v1.0.0-macOS.dmg',
  }
}

type DownloadType = keyof typeof DOWNLOAD_CONFIG

// Track download analytics
async function trackDownload(downloadType: DownloadType, userAgent: string, ip: string) {
  console.log(`Download tracked: ${downloadType} from ${ip} using ${userAgent}`)
}

export async function POST(request: NextRequest) {
  try {
    const { type = 'augment-macos' } = await request.json()
    if (!DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]) {
      return NextResponse.json({ error: 'Invalid download type' }, { status: 400 })
    }

    const downloadInfo = DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]
    const filePath = path.join(process.cwd(), 'public', downloadInfo.path.substring(1))

    try {
      await fs.access(filePath)
    } catch (err) {
      return NextResponse.json({ error: 'Download file not found' }, { status: 404 })
    }

    const headers = request.headers
    const userAgent = headers.get('user-agent')?.toString() || 'Unknown'
    const ip = headers.get('x-forwarded-for')?.toString() || 
              headers.get('x-real-ip')?.toString() || 
              'Unknown'
    await trackDownload(type as DownloadType, userAgent, ip)

    return NextResponse.json({
      ...downloadInfo,
      url: headers.get('x-forwarded-proto') === 'https' 
        ? `https://${headers.get('host')}${downloadInfo.path}`
        : `http://${headers.get('host')}${downloadInfo.path}`
    }, {
      headers: {
        'Content-Type': 'application/json',
        'X-File-Version': downloadInfo.version,
        'X-File-Checksum': downloadInfo.checksum
      }
    })

  } catch (error) {
    console.error('Download POST error:', error)
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 })
  }
}
