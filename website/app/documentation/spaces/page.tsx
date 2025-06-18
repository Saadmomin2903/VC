import type { Metadata } from 'next'
import { SpacesGuide } from '@/components/documentation/spaces-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Managing Spaces - Augment Documentation',
  description: 'Learn how to create, configure, and manage spaces in Augment. Understand space settings, organization, and best practices.',
  openGraph: {
    title: 'Augment Spaces - Organize Your File Versioning',
    description: 'Master space management in Augment for optimal file organization.',
  },
}

export default function SpacesPage() {
  return (
    <DocumentationLayout>
      <SpacesGuide />
    </DocumentationLayout>
  )
}
