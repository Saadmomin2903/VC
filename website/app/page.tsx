import { Hero } from '@/components/hero'
import { Features } from '@/components/features'
import { HowItWorks } from '@/components/how-it-works'
import { Testimonials } from '@/components/testimonials'
import { CTA } from '@/components/cta'
import { Stats } from '@/components/stats'
import { Comparison } from '@/components/comparison'

export default function HomePage() {
  return (
    <>
      <Hero />
      <Stats />
      <Features />
      <HowItWorks />
      <Comparison />
      <Testimonials />
      <CTA />
    </>
  )
}
