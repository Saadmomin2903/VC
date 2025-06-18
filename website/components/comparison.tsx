'use client'

import { motion } from 'framer-motion'
import { X, Check } from 'lucide-react'

const comparisons = [
  {
    feature: 'File versioning',
    before: 'Manual file naming (final_v2_FINAL.doc)',
    after: 'Automatic version tracking',
    beforeIcon: X,
    afterIcon: Check
  },
  {
    feature: 'Lost work recovery',
    before: 'Lost work from crashes or mistakes',
    after: 'Complete version history always available',
    beforeIcon: X,
    afterIcon: Check
  },
  {
    feature: 'Version comparison',
    before: 'No way to compare versions',
    after: 'Side-by-side version comparison',
    beforeIcon: X,
    afterIcon: Check
  },
  {
    feature: 'File organization',
    before: 'Cluttered folders with duplicates',
    after: 'Clean, organized workspace',
    beforeIcon: X,
    afterIcon: Check
  },
  {
    feature: 'Storage management',
    before: 'Manual cleanup of old files',
    after: 'Intelligent automatic cleanup',
    beforeIcon: X,
    afterIcon: Check
  },
  {
    feature: 'Search capabilities',
    before: 'Difficult to find old versions',
    after: 'Instant search across all versions',
    beforeIcon: X,
    afterIcon: Check
  }
]

export function Comparison() {
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
              Before vs. After{' '}
              <span className="gradient-text">Augment</span>
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              See how Augment transforms your file management workflow from chaotic to organized.
            </p>
          </motion.div>
        </div>

        <div className="mt-16">
          <div className="grid gap-8 lg:grid-cols-2">
            {/* Before column */}
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.6, delay: 0.2 }}
              viewport={{ once: true }}
            >
              <div className="card p-6">
                <div className="mb-6 text-center">
                  <div className="inline-flex items-center rounded-full bg-red-100 px-4 py-2 text-red-800 dark:bg-red-900/20 dark:text-red-400">
                    <X className="mr-2 h-5 w-5" />
                    Before Augment
                  </div>
                </div>
                
                <div className="space-y-4">
                  {comparisons.map((item, index) => (
                    <motion.div
                      key={`before-${index}`}
                      initial={{ opacity: 0, y: 10 }}
                      whileInView={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.4, delay: index * 0.1 }}
                      viewport={{ once: true }}
                      className="flex items-start space-x-3 rounded-lg bg-red-50 p-4 dark:bg-red-900/10"
                    >
                      <X className="mt-0.5 h-5 w-5 flex-shrink-0 text-red-600 dark:text-red-400" />
                      <div>
                        <h4 className="font-medium text-gray-900 dark:text-white">
                          {item.feature}
                        </h4>
                        <p className="text-sm text-gray-600 dark:text-gray-300">
                          {item.before}
                        </p>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </div>
            </motion.div>

            {/* After column */}
            <motion.div
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.6, delay: 0.4 }}
              viewport={{ once: true }}
            >
              <div className="card p-6">
                <div className="mb-6 text-center">
                  <div className="inline-flex items-center rounded-full bg-green-100 px-4 py-2 text-green-800 dark:bg-green-900/20 dark:text-green-400">
                    <Check className="mr-2 h-5 w-5" />
                    With Augment
                  </div>
                </div>
                
                <div className="space-y-4">
                  {comparisons.map((item, index) => (
                    <motion.div
                      key={`after-${index}`}
                      initial={{ opacity: 0, y: 10 }}
                      whileInView={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.4, delay: index * 0.1 + 0.2 }}
                      viewport={{ once: true }}
                      className="flex items-start space-x-3 rounded-lg bg-green-50 p-4 dark:bg-green-900/10"
                    >
                      <Check className="mt-0.5 h-5 w-5 flex-shrink-0 text-green-600 dark:text-green-400" />
                      <div>
                        <h4 className="font-medium text-gray-900 dark:text-white">
                          {item.feature}
                        </h4>
                        <p className="text-sm text-gray-600 dark:text-gray-300">
                          {item.after}
                        </p>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </div>
            </motion.div>
          </div>
        </div>

        {/* Stats section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-green-600 to-blue-600 p-8 text-white">
            <div className="text-center">
              <h3 className="text-2xl font-bold">
                The difference is clear
              </h3>
              <p className="mt-2 text-green-100">
                Join thousands of users who have transformed their workflow with Augment
              </p>
            </div>
            
            <div className="mt-8 grid gap-8 sm:grid-cols-3">
              <div className="text-center">
                <div className="text-3xl font-bold">100%</div>
                <div className="text-sm text-green-100">Work protected</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold">0</div>
                <div className="text-sm text-green-100">Setup time</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold">∞</div>
                <div className="text-sm text-green-100">Version history</div>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
