'use client'

import { motion } from 'framer-motion'
import { Target, Heart, Shield, Users } from 'lucide-react'

const missions = [
  {
    icon: Target,
    title: 'Our Mission',
    description: 'To eliminate file loss forever by making intelligent versioning accessible to everyone.',
    details: 'We believe that losing work should never happen. Every creative person deserves the peace of mind that comes with knowing their work is always safe and recoverable.'
  },
  {
    icon: Heart,
    title: 'Our Passion',
    description: 'We are passionate about empowering creators to focus on what they do best.',
    details: 'By removing the fear of losing work, we enable artists, writers, developers, and professionals to take creative risks and push boundaries without worry.'
  },
  {
    icon: Shield,
    title: 'Our Promise',
    description: 'Your files stay private and secure on your own Mac, always.',
    details: 'We never see your files, never store them in the cloud, and never compromise your privacy. Your work belongs to you, and it stays with you.'
  },
  {
    icon: Users,
    title: 'Our Community',
    description: 'Building a community of creators who never have to worry about losing work.',
    details: 'From individual artists to large teams, Augment serves creators worldwide who value their work and want the best protection available.'
  }
]

export function Mission() {
  return (
    <section className="section bg-white dark:bg-gray-900">
      <div className="container">
        <div className="mx-auto max-w-3xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl">
              Our mission is simple
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              We exist to solve one of the most frustrating problems in the digital age: 
              losing important work due to crashes, mistakes, or technical failures.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 lg:grid-cols-2">
          {missions.map((mission, index) => {
            const Icon = mission.icon
            return (
              <motion.div
                key={mission.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="group"
              >
                <div className="card p-8 h-full transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className="flex items-start space-x-4">
                    <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                      <Icon className="h-6 w-6" />
                    </div>
                    <div className="flex-1">
                      <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                        {mission.title}
                      </h3>
                      <p className="mt-2 text-gray-600 dark:text-gray-300 font-medium">
                        {mission.description}
                      </p>
                      <p className="mt-4 text-gray-500 dark:text-gray-400">
                        {mission.details}
                      </p>
                    </div>
                  </div>
                </div>
              </motion.div>
            )
          })}
        </div>

        {/* Quote section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-blue-600 to-purple-600 p-8 text-white text-center">
            <blockquote className="text-2xl font-medium">
              "Technology should protect and empower creativity, not threaten it."
            </blockquote>
            <cite className="mt-4 block text-blue-100">
              — Augment Team Philosophy
            </cite>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
