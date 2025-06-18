'use client'

import { motion } from 'framer-motion'
import { Clock, Search, RotateCcw, HardDrive, Bell, Shield } from 'lucide-react'

const highlights = [
  {
    icon: Clock,
    title: 'Automatic Versioning',
    description: 'Every save creates a version'
  },
  {
    icon: Search,
    title: 'Powerful Search',
    description: 'Find any file, any version'
  },
  {
    icon: RotateCcw,
    title: 'Easy Recovery',
    description: 'One-click restoration'
  },
  {
    icon: HardDrive,
    title: 'Smart Storage',
    description: 'Intelligent space management'
  },
  {
    icon: Bell,
    title: 'Smart Notifications',
    description: 'Stay informed automatically'
  },
  {
    icon: Shield,
    title: 'Error Recovery',
    description: 'Automatic problem solving'
  }
]

export function FeaturesHero() {
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
                  Every feature you need for{' '}
                  <span className="gradient-text">intelligent file protection</span>
                </h1>
                <p className="mt-6 text-xl text-gray-600 dark:text-gray-300">
                  Augment provides a comprehensive suite of features designed to keep your files safe, 
                  organized, and easily recoverable. From automatic versioning to smart storage management, 
                  we've got you covered.
                </p>
              </motion.div>

              {/* Feature highlights grid */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.2 }}
                className="mt-16 grid gap-6 sm:grid-cols-2 lg:grid-cols-3"
              >
                {highlights.map((feature, index) => {
                  const Icon = feature.icon
                  return (
                    <motion.div
                      key={feature.title}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.1 * index }}
                      className="group"
                    >
                      <div className="card p-6 text-center transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                        <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-primary">
                          <Icon className="h-6 w-6" />
                        </div>
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                          {feature.title}
                        </h3>
                        <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                          {feature.description}
                        </p>
                      </div>
                    </motion.div>
                  )
                })}
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
