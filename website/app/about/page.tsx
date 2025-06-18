import type { Metadata } from 'next'
import { AboutHero } from '@/components/about/about-hero'
import { Mission } from '@/components/about/mission'
import { Team } from '@/components/about/team'
import { Values } from '@/components/about/values'
import { Timeline } from '@/components/about/timeline'

export const metadata: Metadata = {
  title: 'About Augment - Our Mission to Protect Your Work',
  description: 'Learn about Augment\'s mission to eliminate file loss through intelligent versioning. Meet our team and discover the story behind the software.',
  openGraph: {
    title: 'About Augment - Protecting Your Work, One File at a Time',
    description: 'Discover the story behind Augment and our commitment to making file loss a thing of the past.',
  },
}

export default function AboutPage() {
  return (
    <>
      <AboutHero />
      <Mission />
      <Values />
      <Timeline />
      <Team />
    </>
  )
}
