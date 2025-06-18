import type { Metadata } from 'next'
import { FirstStepsGuide } from '@/components/documentation/first-steps-guide'
import { DocumentationLayout } from '@/components/documentation/documentation-layout'

export const metadata: Metadata = {
  title: 'First Steps - Augment Documentation',
  description: 'Essential first steps after installing Augment. Learn the fundamentals and build confidence with file versioning.',
  openGraph: {
    title: 'First Steps with Augment File Versioning',
    description: 'Master the basics and get comfortable with Augment file versioning.',
  },
}

export default function FirstStepsPage() {
  return (
    <DocumentationLayout>
      <FirstStepsGuide />
    </DocumentationLayout>
  )
}
