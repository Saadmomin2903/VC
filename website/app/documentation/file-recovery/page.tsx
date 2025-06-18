import type { Metadata } from 'next'
import { FileRecoveryGuide } from '@/components/documentation/file-recovery-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'File Recovery - Augment Documentation',
  description: 'Learn how to recover and restore previous versions of your files using Augment. Step-by-step recovery procedures and best practices.',
  openGraph: {
    title: 'File Recovery with Augment',
    description: 'Master file recovery and restoration techniques in Augment.',
  },
}

export default function FileRecoveryPage() {
  return (
    <DocumentationLayout>
      <FileRecoveryGuide />
    </DocumentationLayout>
  )
}
