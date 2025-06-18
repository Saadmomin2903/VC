import type { Metadata } from 'next'
import { QuickStartGuide } from '@/components/documentation/quick-start-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Quick Start Guide - Augment Documentation',
  description: 'Get started with Augment in under 15 minutes. Learn the basics of file versioning and create your first space.',
  openGraph: {
    title: 'Quick Start with Augment File Versioning',
    description: 'Learn the essentials of Augment in just 15 minutes.',
  },
}

export default function QuickStartPage() {
  return (
    <DocumentationLayout>
      <QuickStartGuide />
    </DocumentationLayout>
  )
}
