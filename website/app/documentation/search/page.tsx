import type { Metadata } from 'next'
import { SearchGuide } from '@/components/documentation/search-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Search & Filtering - Augment Documentation',
  description: 'Master Augment\'s powerful search and filtering capabilities. Find any file or version quickly with advanced search techniques.',
  openGraph: {
    title: 'Search and Filter Files in Augment',
    description: 'Learn advanced search techniques for finding files and versions in Augment.',
  },
}

export default function SearchPage() {
  return (
    <DocumentationLayout>
      <SearchGuide />
    </DocumentationLayout>
  )
}
