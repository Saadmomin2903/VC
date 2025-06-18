import type { Metadata } from 'next'
import { FAQGuide } from '@/components/documentation/faq-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'Frequently Asked Questions - Augment Documentation',
  description: 'Find answers to the most common questions about Augment file versioning software. Get quick solutions to common concerns.',
  openGraph: {
    title: 'Augment FAQ - Common Questions Answered',
    description: 'Quick answers to frequently asked questions about Augment.',
  },
}

export default function FAQPage() {
  return (
    <DocumentationLayout>
      <FAQGuide />
    </DocumentationLayout>
  )
}
