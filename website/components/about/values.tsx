'use client'

import { motion } from 'framer-motion'
import { Shield, Zap, Heart, Users, Lock, Lightbulb } from 'lucide-react'

const values = [
  {
    icon: Shield,
    title: 'Privacy First',
    description: 'Your files belong to you and stay on your Mac. We never see, store, or access your personal data.',
    color: 'text-blue-600 dark:text-blue-400'
  },
  {
    icon: Zap,
    title: 'Simplicity',
    description: 'Complex problems deserve simple solutions. Augment works invisibly so you can focus on creating.',
    color: 'text-yellow-600 dark:text-yellow-400'
  },
  {
    icon: Heart,
    title: 'User-Centric',
    description: 'Every decision we make is guided by what\'s best for our users and their creative workflows.',
    color: 'text-red-600 dark:text-red-400'
  },
  {
    icon: Users,
    title: 'Inclusive Design',
    description: 'We build for everyone - from individual creators to large teams, beginners to experts.',
    color: 'text-green-600 dark:text-green-400'
  },
  {
    icon: Lock,
    title: 'Reliability',
    description: 'When you trust us with protecting your work, we take that responsibility seriously.',
    color: 'text-purple-600 dark:text-purple-400'
  },
  {
    icon: Lightbulb,
    title: 'Innovation',
    description: 'We continuously improve and innovate to stay ahead of evolving user needs and technology.',
    color: 'text-orange-600 dark:text-orange-400'
  }
]

export function Values() {
  return (
    <section className="section bg-gray-50 dark:bg-gray-800">
      <div className="container">
        <div className="mx-auto max-w-3xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl">
              Our core values
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              These principles guide everything we do, from product development to customer support.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {values.map((value, index) => {
            const Icon = value.icon
            return (
              <motion.div
                key={value.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="group"
              >
                <div className="card p-6 h-full text-center transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className={`mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 ${value.color}`}>
                    <Icon className="h-6 w-6" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {value.title}
                  </h3>
                  <p className="mt-2 text-gray-600 dark:text-gray-300">
                    {value.description}
                  </p>
                </div>
              </motion.div>
            )
          })}
        </div>

        {/* Additional content */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="card p-8">
            <div className="text-center">
              <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                Built with integrity
              </h3>
              <p className="mt-4 text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
                We believe that great software is built on trust. That's why we're transparent 
                about how Augment works, committed to your privacy, and dedicated to providing 
                the best possible experience for protecting your creative work.
              </p>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
