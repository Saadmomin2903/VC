'use client'

import { motion } from 'framer-motion'
import { Check, X } from 'lucide-react'

const comparisons = [
  {
    category: 'File Protection',
    features: [
      {
        feature: 'Automatic versioning',
        augment: true,
        manual: false,
        cloud: true,
        git: false
      },
      {
        feature: 'Real-time backup',
        augment: true,
        manual: false,
        cloud: true,
        git: false
      },
      {
        feature: 'Works with all file types',
        augment: true,
        manual: true,
        cloud: true,
        git: false
      },
      {
        feature: 'No file size limits',
        augment: true,
        manual: true,
        cloud: false,
        git: false
      }
    ]
  },
  {
    category: 'Ease of Use',
    features: [
      {
        feature: 'Zero configuration',
        augment: true,
        manual: false,
        cloud: false,
        git: false
      },
      {
        feature: 'Works with any app',
        augment: true,
        manual: true,
        cloud: true,
        git: false
      },
      {
        feature: 'One-click recovery',
        augment: true,
        manual: false,
        cloud: true,
        git: false
      },
      {
        feature: 'Visual version history',
        augment: true,
        manual: false,
        cloud: false,
        git: false
      }
    ]
  },
  {
    category: 'Privacy & Security',
    features: [
      {
        feature: 'Local storage only',
        augment: true,
        manual: true,
        cloud: false,
        git: true
      },
      {
        feature: 'No account required',
        augment: true,
        manual: true,
        cloud: false,
        git: true
      },
      {
        feature: 'Encrypted storage',
        augment: true,
        manual: false,
        cloud: true,
        git: false
      },
      {
        feature: 'Offline access',
        augment: true,
        manual: true,
        cloud: false,
        git: true
      }
    ]
  }
]

const solutions = [
  { name: 'Augment', color: 'bg-primary text-white' },
  { name: 'Manual Backup', color: 'bg-gray-100 text-gray-900 dark:bg-gray-800 dark:text-white' },
  { name: 'Cloud Storage', color: 'bg-blue-100 text-blue-900 dark:bg-blue-900/20 dark:text-blue-300' },
  { name: 'Git/Version Control', color: 'bg-green-100 text-green-900 dark:bg-green-900/20 dark:text-green-300' }
]

export function FeatureComparison() {
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
              How Augment compares
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              See how Augment stacks up against other file protection solutions.
            </p>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr>
                  <th className="text-left py-4 px-6 font-semibold text-gray-900 dark:text-white">
                    Feature
                  </th>
                  {solutions.map((solution) => (
                    <th
                      key={solution.name}
                      className={`text-center py-4 px-6 font-semibold rounded-t-lg ${solution.color}`}
                    >
                      {solution.name}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {comparisons.map((category, categoryIndex) => (
                  <React.Fragment key={category.category}>
                    <tr>
                      <td
                        colSpan={5}
                        className="py-4 px-6 font-semibold text-gray-900 dark:text-white bg-gray-50 dark:bg-gray-800"
                      >
                        {category.category}
                      </td>
                    </tr>
                    {category.features.map((feature, featureIndex) => (
                      <motion.tr
                        key={feature.feature}
                        initial={{ opacity: 0, x: -20 }}
                        whileInView={{ opacity: 1, x: 0 }}
                        transition={{ duration: 0.4, delay: featureIndex * 0.1 }}
                        viewport={{ once: true }}
                        className="border-b border-gray-200 dark:border-gray-700"
                      >
                        <td className="py-4 px-6 text-gray-700 dark:text-gray-300">
                          {feature.feature}
                        </td>
                        <td className="py-4 px-6 text-center">
                          {feature.augment ? (
                            <Check className="h-5 w-5 text-green-600 mx-auto" />
                          ) : (
                            <X className="h-5 w-5 text-red-600 mx-auto" />
                          )}
                        </td>
                        <td className="py-4 px-6 text-center">
                          {feature.manual ? (
                            <Check className="h-5 w-5 text-green-600 mx-auto" />
                          ) : (
                            <X className="h-5 w-5 text-red-600 mx-auto" />
                          )}
                        </td>
                        <td className="py-4 px-6 text-center">
                          {feature.cloud ? (
                            <Check className="h-5 w-5 text-green-600 mx-auto" />
                          ) : (
                            <X className="h-5 w-5 text-red-600 mx-auto" />
                          )}
                        </td>
                        <td className="py-4 px-6 text-center">
                          {feature.git ? (
                            <Check className="h-5 w-5 text-green-600 mx-auto" />
                          ) : (
                            <X className="h-5 w-5 text-red-600 mx-auto" />
                          )}
                        </td>
                      </motion.tr>
                    ))}
                  </React.Fragment>
                ))}
              </tbody>
            </table>
          </div>
        </motion.div>

        {/* Summary */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-primary to-purple-600 p-8 text-white">
            <div className="text-center">
              <h3 className="text-2xl font-bold">
                The clear choice for file protection
              </h3>
              <p className="mt-4 text-blue-100">
                Augment combines the best of all worlds: automatic protection, 
                complete privacy, and zero configuration required.
              </p>
              <div className="mt-8 grid gap-6 sm:grid-cols-3">
                <div>
                  <div className="text-3xl font-bold">100%</div>
                  <div className="text-sm text-blue-100">Automatic</div>
                </div>
                <div>
                  <div className="text-3xl font-bold">0</div>
                  <div className="text-sm text-blue-100">Configuration</div>
                </div>
                <div>
                  <div className="text-3xl font-bold">∞</div>
                  <div className="text-sm text-blue-100">File types supported</div>
                </div>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}

// Add React import for Fragment
import React from 'react'
