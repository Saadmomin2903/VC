'use client'

import { motion } from 'framer-motion'
import { Play, Pause, RotateCcw, Search, Clock } from 'lucide-react'
import { useState } from 'react'

export function FeatureDemo() {
  const [activeDemo, setActiveDemo] = useState('versioning')

  const demos = {
    versioning: {
      title: 'Automatic Versioning',
      description: 'Watch how Augment automatically creates versions as you work',
      icon: Clock,
      steps: [
        'Open a document in any application',
        'Make changes and save the file',
        'Augment automatically creates a new version',
        'Continue working with complete peace of mind'
      ]
    },
    search: {
      title: 'Powerful Search',
      description: 'Find any version of any file instantly',
      icon: Search,
      steps: [
        'Open Augment search interface',
        'Type filename or search within content',
        'Filter by date, size, or file type',
        'Preview and open the exact version you need'
      ]
    },
    recovery: {
      title: 'File Recovery',
      description: 'Restore previous versions with one click',
      icon: RotateCcw,
      steps: [
        'Browse version history for any file',
        'Compare versions side by side',
        'Select the version you want to restore',
        'Click restore - your file is back instantly'
      ]
    }
  }

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
              See Augment in action
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Experience how Augment seamlessly integrates into your workflow to provide 
              invisible protection for all your important files.
            </p>
          </motion.div>
        </div>

        <div className="mt-16">
          {/* Demo selector */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            viewport={{ once: true }}
            className="flex justify-center"
          >
            <div className="inline-flex rounded-lg bg-white p-1 shadow-sm dark:bg-gray-900">
              {Object.entries(demos).map(([key, demo]) => {
                const Icon = demo.icon
                return (
                  <button
                    key={key}
                    onClick={() => setActiveDemo(key)}
                    className={`flex items-center space-x-2 rounded-md px-4 py-2 text-sm font-medium transition-colors ${
                      activeDemo === key
                        ? 'bg-primary text-white'
                        : 'text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white'
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    <span>{demo.title}</span>
                  </button>
                )
              })}
            </div>
          </motion.div>

          {/* Demo content */}
          <motion.div
            key={activeDemo}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="mt-12"
          >
            <div className="grid gap-12 lg:grid-cols-2 lg:items-center">
              {/* Demo description */}
              <div>
                <h3 className="text-2xl font-bold text-gray-900 dark:text-white">
                  {demos[activeDemo as keyof typeof demos].title}
                </h3>
                <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
                  {demos[activeDemo as keyof typeof demos].description}
                </p>
                
                <div className="mt-8 space-y-4">
                  {demos[activeDemo as keyof typeof demos].steps.map((step, index) => (
                    <div key={index} className="flex items-start space-x-3">
                      <div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary text-xs font-bold text-white">
                        {index + 1}
                      </div>
                      <span className="text-gray-700 dark:text-gray-300">{step}</span>
                    </div>
                  ))}
                </div>

                <div className="mt-8">
                  <button className="btn-primary">
                    <Play className="mr-2 h-4 w-4" />
                    Watch Full Demo
                  </button>
                </div>
              </div>

              {/* Demo visualization */}
              <div className="relative">
                <div className="aspect-video rounded-lg bg-gradient-to-br from-blue-600 to-purple-600 p-1">
                  <div className="flex h-full items-center justify-center rounded-md bg-white dark:bg-gray-900">
                    {/* Mock interface based on active demo */}
                    {activeDemo === 'versioning' && (
                      <div className="w-full max-w-sm space-y-4 p-6">
                        <div className="flex items-center justify-between">
                          <span className="text-sm font-medium text-gray-900 dark:text-white">
                            Document.docx
                          </span>
                          <span className="text-xs text-green-600 dark:text-green-400">
                            ● Auto-saved
                          </span>
                        </div>
                        <div className="space-y-2">
                          <div className="h-2 w-full rounded bg-gray-200 dark:bg-gray-700"></div>
                          <div className="h-2 w-4/5 rounded bg-gray-200 dark:bg-gray-700"></div>
                          <div className="h-2 w-3/4 rounded bg-gray-200 dark:bg-gray-700"></div>
                        </div>
                        <div className="rounded bg-blue-50 p-2 dark:bg-blue-900/20">
                          <div className="flex items-center space-x-2 text-xs">
                            <Clock className="h-3 w-3 text-blue-600 dark:text-blue-400" />
                            <span className="text-blue-800 dark:text-blue-300">
                              Version 5 saved
                            </span>
                          </div>
                        </div>
                      </div>
                    )}

                    {activeDemo === 'search' && (
                      <div className="w-full max-w-sm space-y-4 p-6">
                        <div className="relative">
                          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
                          <input
                            type="text"
                            placeholder="Search files..."
                            className="w-full rounded border border-gray-200 bg-white pl-10 pr-4 py-2 text-sm dark:border-gray-700 dark:bg-gray-800"
                            defaultValue="project report"
                          />
                        </div>
                        <div className="space-y-2">
                          {[1, 2, 3].map((i) => (
                            <div key={i} className="flex items-center space-x-3 rounded bg-gray-50 p-2 dark:bg-gray-800">
                              <div className="h-8 w-8 rounded bg-blue-100 dark:bg-blue-900/20"></div>
                              <div className="flex-1">
                                <div className="text-xs font-medium text-gray-900 dark:text-white">
                                  Project Report v{i}.docx
                                </div>
                                <div className="text-xs text-gray-500 dark:text-gray-400">
                                  2 days ago
                                </div>
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {activeDemo === 'recovery' && (
                      <div className="w-full max-w-sm space-y-4 p-6">
                        <div className="text-center">
                          <h4 className="text-sm font-medium text-gray-900 dark:text-white">
                            Version History
                          </h4>
                        </div>
                        <div className="space-y-2">
                          {[
                            { version: 'Current', time: 'Now', active: false },
                            { version: 'Version 4', time: '2 hours ago', active: true },
                            { version: 'Version 3', time: '1 day ago', active: false },
                            { version: 'Version 2', time: '3 days ago', active: false }
                          ].map((item, i) => (
                            <div
                              key={i}
                              className={`flex items-center justify-between rounded p-2 ${
                                item.active
                                  ? 'bg-blue-50 dark:bg-blue-900/20'
                                  : 'bg-gray-50 dark:bg-gray-800'
                              }`}
                            >
                              <span className="text-xs font-medium text-gray-900 dark:text-white">
                                {item.version}
                              </span>
                              <span className="text-xs text-gray-500 dark:text-gray-400">
                                {item.time}
                              </span>
                            </div>
                          ))}
                        </div>
                        <button className="w-full rounded bg-primary px-3 py-2 text-xs font-medium text-white">
                          <RotateCcw className="mr-1 h-3 w-3" />
                          Restore Version 4
                        </button>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  )
}
