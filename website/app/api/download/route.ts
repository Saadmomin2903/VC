import { NextRequest, NextResponse } from 'next/server'
import { headers } from 'next/headers'
import path from 'path'
import fs from 'fs'

// Download configuration
const DOWNLOAD_CONFIG = {
  'augment-macos': {
    filename: 'Augment-v1.0.0-macOS.dmg',
    displayName: 'Augment for macOS',
    version: '1.0.0',
    size: '15.2 MB',
    mimeType: 'application/x-apple-diskimage',
    checksum: 'sha256:a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456',
    description: 'Universal Binary for Intel and Apple Silicon Macs'
  },
  'augment-github': {
    filename: 'Augment-v1.0.0-Source.zip',
    displayName: 'Augment Source Code',
    version: '1.0.0',
    size: '2.8 MB',
    mimeType: 'application/zip',
    checksum: 'sha256:b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567a',
    description: 'Source code and build instructions'
  }
}

// Track download analytics
async function trackDownload(downloadType: string, userAgent: string, ip: string) {
  // In a real implementation, you would send this to your analytics service
  console.log(`Download tracked: ${downloadType} from ${ip} using ${userAgent}`)
  
  // Example: Send to analytics service
  // await fetch('https://analytics.example.com/track', {
  //   method: 'POST',
  //   headers: { 'Content-Type': 'application/json' },
  //   body: JSON.stringify({
  //     event: 'download',
  //     type: downloadType,
  //     timestamp: new Date().toISOString(),
  //     userAgent,
  //     ip
  //   })
  // })
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const type = searchParams.get('type') || 'augment-macos'
    const platform = searchParams.get('platform') || 'macos'
    
    // Validate download type
    if (!DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]) {
      return NextResponse.json(
        { error: 'Invalid download type' },
        { status: 400 }
      )
    }
    
    const config = DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]
    const headersList = headers()
    const userAgent = headersList.get('user-agent') || 'Unknown'
    const ip = headersList.get('x-forwarded-for') || 
              headersList.get('x-real-ip') || 
              'Unknown'
    
    // Track the download
    await trackDownload(type, userAgent, ip)
    
    // For demo purposes, we'll create a small mock file
    // In production, you would serve the actual application file
    const mockFileContent = createMockFile(config)
    
    // Set appropriate headers for file download
    const response = new NextResponse(mockFileContent)
    
    response.headers.set('Content-Type', config.mimeType)
    response.headers.set('Content-Disposition', `attachment; filename="${config.filename}"`)
    response.headers.set('Content-Length', mockFileContent.length.toString())
    response.headers.set('Cache-Control', 'public, max-age=3600')
    response.headers.set('X-Download-Type', type)
    response.headers.set('X-File-Version', config.version)
    response.headers.set('X-File-Checksum', config.checksum)
    
    return response
    
  } catch (error) {
    console.error('Download error:', error)
    return NextResponse.json(
      { error: 'Download failed' },
      { status: 500 }
    )
  }
}

// Create a mock file for demonstration
// In production, you would read the actual application file
function createMockFile(config: typeof DOWNLOAD_CONFIG[keyof typeof DOWNLOAD_CONFIG]): Buffer {
  const mockContent = `
# Augment for macOS - ${config.version}

This is a mock download file for demonstration purposes.
In a production environment, this would be the actual Augment application.

File: ${config.filename}
Version: ${config.version}
Size: ${config.size}
Checksum: ${config.checksum}
Description: ${config.description}

## Installation Instructions

1. Double-click the downloaded file to mount the disk image
2. Drag Augment.app to your Applications folder
3. Launch Augment from Applications
4. Follow the setup wizard to create your first space

## System Requirements

- macOS 11.0 (Big Sur) or later
- 50 MB available disk space
- Intel or Apple Silicon processor

## Support

For help and support, visit: https://augment-app.com/support
Documentation: https://augment-app.com/documentation

---
Generated: ${new Date().toISOString()}
Download ID: ${Math.random().toString(36).substring(2, 15)}
  `.trim()
  
  return Buffer.from(mockContent, 'utf-8')
}

// Handle POST requests for download info
export async function POST(request: NextRequest) {
  try {
    const { type } = await request.json()
    
    if (!DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]) {
      return NextResponse.json(
        { error: 'Invalid download type' },
        { status: 400 }
      )
    }
    
    const config = DOWNLOAD_CONFIG[type as keyof typeof DOWNLOAD_CONFIG]
    
    return NextResponse.json({
      success: true,
      download: {
        ...config,
        downloadUrl: `/api/download?type=${type}`,
        timestamp: new Date().toISOString()
      }
    })
    
  } catch (error) {
    console.error('Download info error:', error)
    return NextResponse.json(
      { error: 'Failed to get download info' },
      { status: 500 }
    )
  }
}
