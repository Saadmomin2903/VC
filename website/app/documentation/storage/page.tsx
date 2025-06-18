import type { Metadata } from 'next'
import { StorageGuide } from '@/components/documentation/storage-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Storage Management - Augment Documentation',
  description: 'Learn how to manage storage efficiently in Augment. Configure storage limits, cleanup policies, and optimize disk usage.',
  openGraph: {
    title: 'Storage Management in Augment',
    description: 'Master storage optimization and management in Augment.',
  },
}

export default function StoragePage() {
  return (
    <DocumentationLayout>
      <StorageGuide />
    </DocumentationLayout>
  )
}
