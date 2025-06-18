'use client'

import { motion } from 'framer-motion'
import { Heart, Users, Shield, Zap } from 'lucide-react'

const stats = [
  { label: 'Files Protected', value: '1M+', icon: Shield },
  { label: 'Active Users', value: '10K+', icon: Users },
  { label: 'Years of Development', value: '3+', icon: Heart },
  { label: 'Zero Data Loss', value: '100%', icon: Zap }
]

export function AboutHero() {
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
                  Making file loss{' '}
                  <span className="gradient-text">a thing of the past</span>
                </h1>
                <p className="mt-6 text-xl text-gray-600 dark:text-gray-300">
                  We believe that losing work should never happen. Augment was born from the 
                  frustration of countless hours lost to crashes, mistakes, and the dreaded 
                  "file not found" error.
                </p>
              </motion.div>

              {/* Stats */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.2 }}
                className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-4"
              >
                {stats.map((stat, index) => {
                  const Icon = stat.icon
                  return (
                    <motion.div
                      key={stat.label}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: 0.1 * index }}
                      className="text-center"
                    >
                      <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-primary/10 text-primary">
                        <Icon className="h-6 w-6" />
                      </div>
                      <div className="text-3xl font-bold text-gray-900 dark:text-white">
                        {stat.value}
                      </div>
                      <div className="mt-1 text-sm text-gray-600 dark:text-gray-300">
                        {stat.label}
                      </div>
                    </motion.div>
                  )
                })}
              </motion.div>

              {/* Quote */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.4 }}
                className="mt-16"
              >
                <blockquote className="text-2xl font-medium text-gray-900 dark:text-white">
                  "Every creative person deserves the peace of mind that comes with 
                  knowing their work is always safe."
                </blockquote>
                <cite className="mt-4 block text-gray-600 dark:text-gray-300">
                  — The Augment Team
                </cite>
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
