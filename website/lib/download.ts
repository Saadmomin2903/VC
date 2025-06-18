import { useState, useCallback } from 'react'

export interface DownloadInfo {
  filename: string
  displayName: string
  version: string
  size: string
  mimeType: string
  checksum: string
  description: string
  downloadUrl: string
  timestamp: string
}

export interface DownloadState {
  isDownloading: boolean
  progress: number
  error: string | null
  success: boolean
}

// Download hook for managing download state
export function useDownload() {
  const [downloadState, setDownloadState] = useState<DownloadState>({
    isDownloading: false,
    progress: 0,
    error: null,
    success: false
  })

  const startDownload = useCallback(async (type: string = 'augment-macos') => {
    try {
      setDownloadState({
        isDownloading: true,
        progress: 0,
        error: null,
        success: false
      })

      // Get download info
      const response = await fetch('/api/download', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ type })
      })

      if (!response.ok) {
        throw new Error('Failed to get download info')
      }

      const { download }: { download: DownloadInfo } = await response.json()

      // Simulate progress for better UX
      setDownloadState(prev => ({ ...prev, progress: 25 }))

      // Create download link and trigger download
      const downloadUrl = `/api/download?type=${type}&platform=macos`
      
      // Create a temporary link element to trigger download
      const link = document.createElement('a')
      link.href = downloadUrl
      link.download = download.filename
      link.style.display = 'none'
      
      document.body.appendChild(link)
      
      // Simulate progress
      setDownloadState(prev => ({ ...prev, progress: 50 }))
      
      // Trigger the download
      link.click()
      
      // Clean up
      document.body.removeChild(link)
      
      // Complete the progress
      setDownloadState(prev => ({ ...prev, progress: 100 }))
      
      // Show success after a brief delay
      setTimeout(() => {
        setDownloadState({
          isDownloading: false,
          progress: 100,
          error: null,
          success: true
        })
      }, 1000)

      return download

    } catch (error) {
      console.error('Download failed:', error)
      setDownloadState({
        isDownloading: false,
        progress: 0,
        error: error instanceof Error ? error.message : 'Download failed',
        success: false
      })
      throw error
    }
  }, [])

  const resetDownload = useCallback(() => {
    setDownloadState({
      isDownloading: false,
      progress: 0,
      error: null,
      success: false
    })
  }, [])

  return {
    downloadState,
    startDownload,
    resetDownload
  }
}

// Utility function for direct downloads (for use in components)
export async function triggerDownload(type: string = 'augment-macos'): Promise<void> {
  try {
    const downloadUrl = `/api/download?type=${type}&platform=macos&timestamp=${Date.now()}`
    
    // Create a temporary link element to trigger download
    const link = document.createElement('a')
    link.href = downloadUrl
    link.style.display = 'none'
    
    // Add to DOM, click, and remove
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    
  } catch (error) {
    console.error('Download trigger failed:', error)
    throw error
  }
}

// Get download information without triggering download
export async function getDownloadInfo(type: string = 'augment-macos'): Promise<DownloadInfo> {
  try {
    const response = await fetch('/api/download', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ type })
    })

    if (!response.ok) {
      throw new Error('Failed to get download info')
    }

    const { download } = await response.json()
    return download

  } catch (error) {
    console.error('Failed to get download info:', error)
    throw error
  }
}

// Detect user's platform for smart download suggestions
export function detectPlatform(): 'macos' | 'windows' | 'linux' | 'unknown' {
  if (typeof window === 'undefined') return 'unknown'
  
  const userAgent = window.navigator.userAgent.toLowerCase()
  
  if (userAgent.includes('mac')) return 'macos'
  if (userAgent.includes('win')) return 'windows'
  if (userAgent.includes('linux')) return 'linux'
  
  return 'unknown'
}

// Check if user's system is compatible
export function checkCompatibility(): {
  compatible: boolean
  reason?: string
  recommendation?: string
} {
  const platform = detectPlatform()
  
  if (platform === 'macos') {
    return { compatible: true }
  }
  
  if (platform === 'windows' || platform === 'linux') {
    return {
      compatible: false,
      reason: 'Augment is currently only available for macOS',
      recommendation: 'We are working on Windows and Linux versions. Sign up for updates to be notified when they become available.'
    }
  }
  
  return {
    compatible: false,
    reason: 'Unable to detect your operating system',
    recommendation: 'Augment requires macOS 11.0 or later. Please visit this page on a Mac to download.'
  }
}
