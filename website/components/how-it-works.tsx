'use client'

import { motion } from 'framer-motion'
import { FolderPlus, FileText, Clock, Search, RotateCcw } from 'lucide-react'

const steps = [
  {
    icon: FolderPlus,
    title: 'Create a Space',
    description: 'Choose a folder you work with regularly. Augment will monitor all files in this space.',
    details: [
      'Select any folder on your Mac',
      'Augment creates a monitoring space',
      'All files are automatically tracked'
    ]
  },
  {
    icon: FileText,
    title: 'Work Normally',
    description: 'Continue working with your files as usual. Augment runs silently in the background.',
    details: [
      'Edit files with any application',
      'Save changes as you normally would',
      'No workflow changes required'
    ]
  },
  {
    icon: Clock,
    title: 'Automatic Versioning',
    description: 'Every time you save a file, Augment automatically creates a new version.',
    details: [
      'Instant version creation on save',
      'Complete file history preserved',
      'Smart deduplication saves space'
    ]
  },
  {
    icon: Search,
    title: 'Find Anything',
    description: 'Use powerful search to find any version of any file, even from months ago.',
    details: [
      'Search by filename or content',
      'Filter by date, size, or type',
      'Preview versions before opening'
    ]
  },
  {
    icon: RotateCcw,
    title: 'Restore Easily',
    description: 'Restore any previous version with a single click. Compare versions side by side.',
    details: [
      'One-click version restoration',
      'Side-by-side comparison view',
      'Selective file restoration'
    ]
  }
]

export function HowItWorks() {
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
              How Augment{' '}
              <span className="gradient-text">protects your work</span>
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Get started in minutes with our simple 5-step process. 
              No complex setup or configuration required.
            </p>
          </motion.div>
        </div>

        <div className="mt-16">
          <div className="relative">
            {/* Connection line */}
            <div className="absolute left-8 top-16 bottom-16 w-0.5 bg-gradient-to-b from-primary to-purple-600 hidden lg:block"></div>
            
            <div className="space-y-12">
              {steps.map((step, index) => {
                const Icon = step.icon
                return (
                  <motion.div
                    key={step.title}
                    initial={{ opacity: 0, x: -20 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.6, delay: index * 0.2 }}
                    viewport={{ once: true }}
                    className="relative"
                  >
                    <div className="flex items-start space-x-8">
                      {/* Step number and icon */}
                      <div className="flex flex-col items-center">
                        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-white shadow-lg">
                          <Icon className="h-8 w-8" />
                        </div>
                        <div className="mt-2 flex h-8 w-8 items-center justify-center rounded-full bg-primary/10 text-sm font-bold text-primary">
                          {index + 1}
                        </div>
                      </div>

                      {/* Content */}
                      <div className="flex-1 pb-8">
                        <div className="card p-6">
                          <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                            {step.title}
                          </h3>
                          <p className="mt-2 text-gray-600 dark:text-gray-300">
                            {step.description}
                          </p>
                          
                          <ul className="mt-4 space-y-2">
                            {step.details.map((detail, detailIndex) => (
                              <li
                                key={detailIndex}
                                className="flex items-center space-x-2 text-sm text-gray-500 dark:text-gray-400"
                              >
                                <div className="h-1.5 w-1.5 rounded-full bg-primary"></div>
                                <span>{detail}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                    </div>
                  </motion.div>
                )
              })}
            </div>
          </div>
        </div>

        {/* Demo section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="card p-8">
            <div className="grid gap-8 lg:grid-cols-2 lg:items-center">
              <div>
                <h3 className="text-2xl font-bold text-gray-900 dark:text-white">
                  See it in action
                </h3>
                <p className="mt-4 text-gray-600 dark:text-gray-300">
                  Watch how Augment seamlessly integrates into your workflow, 
                  providing invisible protection for all your important files.
                </p>
                <div className="mt-6">
                  <button className="btn-primary">
                    <svg className="mr-2 h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clipRule="evenodd" />
                    </svg>
                    Watch Demo Video
                  </button>
                </div>
              </div>
              
              <div className="relative">
                <div className="aspect-video rounded-lg bg-gradient-to-br from-blue-600 to-purple-600 p-1">
                  <div className="flex h-full items-center justify-center rounded-md bg-white dark:bg-gray-900">
                    <div className="text-center">
                      <div className="mx-auto h-16 w-16 rounded-full bg-primary/10 flex items-center justify-center">
                        <svg className="h-8 w-8 text-primary" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clipRule="evenodd" />
                        </svg>
                      </div>
                      <p className="mt-2 text-sm text-gray-500 dark:text-gray-400">
                        Demo Video
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
