import type { Metadata } from 'next'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'
import { DocumentationHome } from '@/components/documentation/documentation-home'

export const metadata: Metadata = {
  title: 'Documentation - Complete Guide to Augment',
  description: 'Complete documentation for Augment file versioning software. Learn how to get started, use advanced features, and troubleshoot common issues.',
  openGraph: {
    title: 'Augment Documentation - Complete User Guide',
    description: 'Everything you need to know about using Augment for intelligent file versioning on macOS.',
  },
}

export default function DocumentationPage() {
  return (
    <DocumentationLayout>
      <DocumentationHome />
    </DocumentationLayout>
  )
}
