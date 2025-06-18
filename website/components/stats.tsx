'use client'

import { motion } from 'framer-motion'
import { Users, FileText, Clock, Shield } from 'lucide-react'

const stats = [
  {
    icon: Users,
    value: '10,000+',
    label: 'Active Users',
    description: 'Professionals trust Augment'
  },
  {
    icon: FileText,
    value: '1M+',
    label: 'Files Protected',
    description: 'Versions safely stored'
  },
  {
    icon: Clock,
    value: '99.9%',
    label: 'Uptime',
    description: 'Reliable protection'
  },
  {
    icon: Shield,
    value: '0',
    label: 'Data Breaches',
    description: 'Your files stay private'
  }
]

export function Stats() {
  return (
    <section className="section-sm bg-primary text-white">
      <div className="container">
        <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {stats.map((stat, index) => {
            const Icon = stat.icon
            return (
              <motion.div
                key={stat.label}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="text-center"
              >
                <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-white/10">
                  <Icon className="h-6 w-6" />
                </div>
                <div className="text-3xl font-bold">{stat.value}</div>
                <div className="mt-1 text-lg font-medium">{stat.label}</div>
                <div className="mt-1 text-sm text-blue-100">{stat.description}</div>
              </motion.div>
            )
          })}
        </div>
      </div>
    </section>
  )
}
