import type { Metadata } from 'next'
import { FeaturesHero } from '@/components/features/features-hero'
import { FeaturesList } from '@/components/features/features-list'
import { FeatureComparison } from '@/components/features/feature-comparison'
import { FeatureDemo } from '@/components/features/feature-demo'
import { CTA } from '@/components/cta'

export const metadata: Metadata = {
  title: 'Features - Comprehensive File Versioning for macOS',
  description: 'Discover all the powerful features that make Augment the best file versioning solution for macOS. Automatic backup, version history, smart search, and more.',
  openGraph: {
    title: 'Augment Features - Complete File Protection for macOS',
    description: 'Explore automatic versioning, intelligent search, easy recovery, and smart storage management features.',
  },
}

export default function FeaturesPage() {
  return (
    <>
      <FeaturesHero />
      <FeaturesList />
      <FeatureDemo />
      <FeatureComparison />
      <CTA />
    </>
  )
}
