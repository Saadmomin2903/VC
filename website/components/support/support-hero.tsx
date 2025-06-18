'use client'

import { motion } from 'framer-motion'
import { HelpCircle, MessageCircle, Book, Mail } from 'lucide-react'

const supportChannels = [
  {
    icon: Book,
    title: 'Documentation',
    description: 'Comprehensive guides and tutorials',
    action: 'Browse Docs'
  },
  {
    icon: HelpCircle,
    title: 'FAQ',
    description: 'Quick answers to common questions',
    action: 'View FAQ'
  },
  {
    icon: MessageCircle,
    title: 'Community',
    description: 'Connect with other users',
    action: 'Join Discussion'
  },
  {
    icon: Mail,
    title: 'Direct Support',
    description: 'Get personalized help',
    action: 'Contact Us'
  }
]

export function SupportHero() {
  return (
    <section className="relative overflow-hidden bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-900 dark:to-gray-800 pt-20">
      {/* Background decoration */}
      <div className="absolute inset-0">
        <div className="absolute -top-40 -right-32 h-80 w-80 rounded-full bg-gradient-to-br from-blue-400 to-purple-600 opacity-20 blur-3xl"></div>
        <div className="absolute -bottom-40 -left-32 h-80 w-80 rounded-full bg-gradient-to-br from-purple-400 to-pink-600 opacity-20 blur-3xl"></div>
      </div>

      <div className="relative">
        <div className="container">
          <div className="py-24">
            <div className="mx-auto max-w-4xl text-center">
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6 }}
              >
                <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-5xl lg:text-6xl">
                  How can we{' '}
                  <span className="gradient-text">help you today?</span>
                </h1>
                <p className="mt-6 text-xl text-gray-600 dark:text-gray-300">
                  Whether you're getting started, need troubleshooting help, or have questions 
                  about features, we're here to support you every step of the way.
                </p>
              </motion.div>

              {/* Support channels */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.2 }}
                className="mt-16 grid gap-6 sm:grid-cols-2 lg:grid-cols-4"
              >
                {supportChannels.map((channel, index) => {
                  const Icon = channel.icon
                  return (
                    <motion.div
                      key={channel.title}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.1 * index }}
                      className="group cursor-pointer"
                    >
                      <div className="card p-6 text-center transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                        <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary/10 text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                          <Icon className="h-6 w-6" />
                        </div>
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                          {channel.title}
                        </h3>
                        <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                          {channel.description}
                        </p>
                        <div className="mt-4 text-sm font-medium text-primary group-hover:text-primary/80">
                          {channel.action}
                        </div>
                      </div>
                    </motion.div>
                  )
                })}
              </motion.div>

              {/* Quick stats */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.4 }}
                className="mt-16 grid gap-8 sm:grid-cols-3"
              >
                <div className="text-center">
                  <div className="text-2xl font-bold text-gray-900 dark:text-white">
                    &lt; 2 hours
                  </div>
                  <div className="text-sm text-gray-600 dark:text-gray-300">
                    Average response time
                  </div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-gray-900 dark:text-white">
                    95%
                  </div>
                  <div className="text-sm text-gray-600 dark:text-gray-300">
                    Issues resolved on first contact
                  </div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-gray-900 dark:text-white">
                    24/7
                  </div>
                  <div className="text-sm text-gray-600 dark:text-gray-300">
                    Community support available
                  </div>
                </div>
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
