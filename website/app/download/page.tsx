import type { Metadata } from 'next'
import { DownloadHero } from '@/components/download/download-hero'
import { SystemRequirements } from '@/components/download/system-requirements'
import { InstallationGuide } from '@/components/download/installation-guide'
import { DownloadOptions } from '@/components/download/download-options'
import { FAQ } from '@/components/download/faq'

export const metadata: Metadata = {
  title: 'Download Augment for macOS - Free File Versioning Software',
  description: 'Download Augment for macOS. Free, secure, and powerful file versioning software. Compatible with macOS 11+ and Apple Silicon Macs.',
  openGraph: {
    title: 'Download Augment - Free File Versioning for macOS',
    description: 'Get started with Augment today. Free download, no account required, works on all modern Macs.',
  },
}

export default function DownloadPage() {
  return (
    <>
      <DownloadHero />
      <DownloadOptions />
      <SystemRequirements />
      <InstallationGuide />
      <FAQ />
    </>
  )
}
