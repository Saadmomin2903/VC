import type { Metadata } from 'next'
import { TroubleshootingGuide } from '@/components/documentation/troubleshooting-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Troubleshooting - Augment Documentation',
  description: 'Solve common issues with Augment. Find solutions to installation problems, performance issues, and error recovery procedures.',
  openGraph: {
    title: 'Troubleshooting Augment Issues',
    description: 'Get help with common Augment problems and error solutions.',
  },
}

export default function TroubleshootingPage() {
  return (
    <DocumentationLayout>
      <TroubleshootingGuide />
    </DocumentationLayout>
  )
}
