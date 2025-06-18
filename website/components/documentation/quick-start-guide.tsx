'use client'

import { motion } from 'framer-motion'
import { Play, FolderPlus, Clock, RotateCcw, Settings, CheckCircle, ArrowRight } from 'lucide-react'
import Link from 'next/link'

const quickSteps = [
  {
    step: 1,
    title: 'Launch Augment',
    description: 'Open Augment from your Applications folder.',
    time: '30 seconds',
    details: [
      'Find Augment in your Applications folder',
      'Double-click to launch the application',
      'The welcome screen will appear automatically'
    ]
  },
  {
    step: 2,
    title: 'Create Your First Space',
    description: 'Set up file versioning for a folder you want to protect.',
    time: '2 minutes',
    details: [
      'Click "Create New Space" on the welcome screen',
      'Choose a folder you want to protect (e.g., Documents)',
      'Give your space a memorable name',
      'Click "Create Space" to start protection'
    ]
  },
  {
    step: 3,
    title: 'Make Some Changes',
    description: 'Edit files in your protected folder to see versioning in action.',
    time: '5 minutes',
    details: [
      'Open any file in your protected folder',
      'Make some changes and save the file',
      'Repeat this process with a few different files',
      'Each save creates a new version automatically'
    ]
  },
  {
    step: 4,
    title: 'View Version History',
    description: 'See all the versions that have been created.',
    time: '2 minutes',
    details: [
      'Return to Augment and select your space',
      'Browse the file list to see version counts',
      'Click on any file to view its version history',
      'Notice the timestamps and file sizes'
    ]
  },
  {
    step: 5,
    title: 'Restore a Previous Version',
    description: 'Practice recovering an older version of a file.',
    time: '3 minutes',
    details: [
      'Select a file with multiple versions',
      'Choose an older version from the history',
      'Click "Restore" to replace the current version',
      'Verify the file has been restored successfully'
    ]
  }
]

const keyFeatures = [
  {
    icon: Clock,
    title: 'Automatic Versioning',
    description: 'Every save creates a version - no manual work required.'
  },
  {
    icon: RotateCcw,
    title: 'Easy Recovery',
    description: 'Restore any previous version with a single click.'
  },
  {
    icon: Settings,
    title: 'Smart Management',
    description: 'Automatic cleanup keeps storage usage under control.'
  }
]

export function QuickStartGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Quick Start Guide
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Get up and running with Augment in under 15 minutes. This guide will walk you through 
          the essential features and help you create your first protected space.
        </p>
      </motion.div>

      {/* Prerequisites */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <div className="rounded-lg bg-blue-50 p-6 dark:bg-blue-900/10">
          <div className="flex items-start space-x-3">
            <CheckCircle className="h-6 w-6 text-blue-600 dark:text-blue-400 mt-0.5" />
            <div>
              <h3 className="font-semibold text-blue-900 dark:text-blue-100">
                Before You Start
              </h3>
              <p className="mt-2 text-blue-800 dark:text-blue-200">
                Make sure you have Augment installed on your Mac. If you haven't installed it yet, 
                check out our <Link href="/documentation/installation" className="underline">installation guide</Link>.
              </p>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Quick Steps */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          5-Step Quick Start
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Follow these steps to get familiar with Augment's core functionality.
        </p>
        
        <div className="mt-8 space-y-8">
          {quickSteps.map((step, index) => (
            <div key={step.step} className="card p-6">
              <div className="flex items-start space-x-4">
                <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-white font-bold">
                  {step.step}
                </div>
                <div className="flex-1">
                  <div className="flex items-center justify-between">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                      {step.title}
                    </h3>
                    <span className="text-sm font-medium text-primary bg-primary/10 px-2 py-1 rounded">
                      {step.time}
                    </span>
                  </div>
                  <p className="mt-2 text-gray-600 dark:text-gray-300">
                    {step.description}
                  </p>
                  <ul className="mt-4 space-y-2">
                    {step.details.map((detail, detailIndex) => (
                      <li key={detailIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                        <ArrowRight className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
                        <span>{detail}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Key Features Overview */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Key Features You Just Learned
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Congratulations! You've now experienced the core features that make Augment powerful.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {keyFeatures.map((feature, index) => {
            const Icon = feature.icon
            return (
              <div key={feature.title} className="card p-6 text-center">
                <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-primary">
                  <Icon className="h-6 w-6" />
                </div>
                <h3 className="font-semibold text-gray-900 dark:text-white">
                  {feature.title}
                </h3>
                <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                  {feature.description}
                </p>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Next Steps */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          What's Next?
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Now that you know the basics, explore these advanced features to get the most out of Augment.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2">
          <Link href="/documentation/spaces" className="card p-6 block hover:shadow-lg transition-shadow">
            <h3 className="font-semibold text-gray-900 dark:text-white">
              Managing Spaces
            </h3>
            <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
              Learn how to create, configure, and manage multiple spaces for different projects.
            </p>
            <div className="mt-4 flex items-center text-sm text-primary">
              <span>Learn more</span>
              <ArrowRight className="ml-1 h-4 w-4" />
            </div>
          </Link>
          
          <Link href="/documentation/storage" className="card p-6 block hover:shadow-lg transition-shadow">
            <h3 className="font-semibold text-gray-900 dark:text-white">
              Storage Management
            </h3>
            <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
              Configure storage limits, cleanup policies, and optimize disk usage.
            </p>
            <div className="mt-4 flex items-center text-sm text-primary">
              <span>Learn more</span>
              <ArrowRight className="ml-1 h-4 w-4" />
            </div>
          </Link>
        </div>
      </motion.div>
    </div>
  )
}
