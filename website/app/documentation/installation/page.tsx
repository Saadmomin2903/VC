import type { Metadata } from 'next'
import { InstallationGuide } from '@/components/documentation/installation-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Installation Guide - Augment Documentation',
  description: 'Step-by-step guide to installing Augment on your Mac. System requirements, download instructions, and setup process.',
  openGraph: {
    title: 'How to Install Augment on macOS',
    description: 'Complete installation guide for Augment file versioning software.',
  },
}

export default function InstallationPage() {
  return (
    <DocumentationLayout>
      <InstallationGuide />
    </DocumentationLayout>
  )
}
