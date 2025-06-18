import type { Metadata } from 'next'
import { SupportHero } from '@/components/support/support-hero'
import { SupportOptions } from '@/components/support/support-options'
import { FAQ } from '@/components/support/faq'
import { ContactForm } from '@/components/support/contact-form'
import { CommunityResources } from '@/components/support/community-resources'

export const metadata: Metadata = {
  title: 'Support - Get Help with Augment',
  description: 'Get help with Augment file versioning software. Find answers to common questions, contact support, and access community resources.',
  openGraph: {
    title: 'Augment Support - We\'re Here to Help',
    description: 'Find answers, get support, and connect with the Augment community.',
  },
}

export default function SupportPage() {
  return (
    <>
      <SupportHero />
      <SupportOptions />
      <FAQ />
      <ContactForm />
      <CommunityResources />
    </>
  )
}
