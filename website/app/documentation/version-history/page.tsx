import type { Metadata } from 'next'
import { VersionHistoryGuide } from '@/components/documentation/version-history-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Version History - Augment Documentation',
  description: 'Understand how Augment tracks file versions, view version history, and navigate through different versions of your files.',
  openGraph: {
    title: 'File Version History in Augment',
    description: 'Master version tracking and history navigation in Augment.',
  },
}

export default function VersionHistoryPage() {
  return (
    <DocumentationLayout>
      <VersionHistoryGuide />
    </DocumentationLayout>
  )
}
