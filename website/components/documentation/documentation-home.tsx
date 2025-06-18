'use client'

import { motion } from 'framer-motion'
import Link from 'next/link'
import { ArrowRight, Zap, Book, Settings, HelpCircle, FileText, Clock, Search, RotateCcw } from 'lucide-react'

const quickStart = [
  {
    icon: Zap,
    title: 'Installation',
    description: 'Download and install Augment on your Mac',
    href: '/documentation/installation',
    time: '2 min'
  },
  {
    icon: Book,
    title: 'Create Your First Space',
    description: 'Set up file versioning for a folder',
    href: '/documentation/spaces',
    time: '3 min'
  },
  {
    icon: Clock,
    title: 'Understanding Versions',
    description: 'Learn how automatic versioning works',
    href: '/documentation/version-history',
    time: '5 min'
  },
  {
    icon: RotateCcw,
    title: 'Recover Files',
    description: 'Restore previous versions of your files',
    href: '/documentation/file-recovery',
    time: '3 min'
  }
]

const features = [
  {
    icon: Clock,
    title: 'Automatic Versioning',
    description: 'Learn how Augment automatically saves every version of your files',
    href: '/documentation/version-history'
  },
  {
    icon: Search,
    title: 'Search & Filter',
    description: 'Find any version of any file with powerful search capabilities',
    href: '/documentation/search'
  },
  {
    icon: Settings,
    title: 'Storage Management',
    description: 'Configure storage limits and automatic cleanup policies',
    href: '/documentation/storage'
  },
  {
    icon: HelpCircle,
    title: 'Troubleshooting',
    description: 'Solutions to common issues and error recovery',
    href: '/documentation/troubleshooting'
  }
]

const sections = [
  {
    icon: Zap,
    title: 'Getting Started',
    description: 'New to Augment? Start here to learn the basics.',
    href: '/documentation/quick-start',
    items: ['Installation', 'Quick Start', 'First Steps']
  },
  {
    icon: Book,
    title: 'Core Features',
    description: 'Master the essential features of Augment.',
    href: '/documentation/spaces',
    items: ['Creating Spaces', 'Version History', 'File Recovery']
  },
  {
    icon: Settings,
    title: 'Advanced Features',
    description: 'Explore advanced capabilities and customization.',
    href: '/documentation/storage',
    items: ['Storage Management', 'Notifications', 'Preferences']
  },
  {
    icon: HelpCircle,
    title: 'Help & Support',
    description: 'Get help when you need it most.',
    href: '/documentation/troubleshooting',
    items: ['Troubleshooting', 'FAQ', 'Contact Support']
  }
]

export function DocumentationHome() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="text-center"
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-5xl">
          Augment Documentation
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Everything you need to know about using Augment for intelligent file versioning.
        </p>
      </motion.div>

      {/* Quick Start */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Quick Start Guide
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Get up and running with Augment in under 15 minutes.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {quickStart.map((item, index) => {
            const Icon = item.icon
            return (
              <Link
                key={item.title}
                href={item.href}
                className="group block"
              >
                <div className="card p-6 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className="flex items-center space-x-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                      <Icon className="h-4 w-4" />
                    </div>
                    <span className="text-sm font-medium text-gray-500 dark:text-gray-400">
                      {item.time}
                    </span>
                  </div>
                  <h3 className="mt-4 font-semibold text-gray-900 dark:text-white group-hover:text-primary">
                    {item.title}
                  </h3>
                  <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                    {item.description}
                  </p>
                  <div className="mt-4 flex items-center text-sm text-primary">
                    <span>Get started</span>
                    <ArrowRight className="ml-1 h-4 w-4 transition-transform group-hover:translate-x-1" />
                  </div>
                </div>
              </Link>
            )
          })}
        </div>
      </motion.div>

      {/* Popular Topics */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Popular Topics
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Most frequently accessed documentation sections.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2">
          {features.map((feature, index) => {
            const Icon = feature.icon
            return (
              <Link
                key={feature.title}
                href={feature.href}
                className="group block"
              >
                <div className="card p-6 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className="flex items-start space-x-4">
                    <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                      <Icon className="h-5 w-5" />
                    </div>
                    <div className="flex-1">
                      <h3 className="font-semibold text-gray-900 dark:text-white group-hover:text-primary">
                        {feature.title}
                      </h3>
                      <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                        {feature.description}
                      </p>
                    </div>
                    <ArrowRight className="h-4 w-4 text-gray-400 transition-all group-hover:text-primary group-hover:translate-x-1" />
                  </div>
                </div>
              </Link>
            )
          })}
        </div>
      </motion.div>

      {/* All Sections */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Browse All Documentation
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Explore all available documentation sections.
        </p>
        
        <div className="mt-8 grid gap-8 sm:grid-cols-2">
          {sections.map((section, index) => {
            const Icon = section.icon
            return (
              <div key={section.title} className="card p-6">
                <div className="flex items-start space-x-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {section.title}
                    </h3>
                    <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                      {section.description}
                    </p>
                    
                    <ul className="mt-4 space-y-1">
                      {section.items.map((item) => (
                        <li key={item} className="text-sm text-gray-500 dark:text-gray-400">
                          • {item}
                        </li>
                      ))}
                    </ul>
                    
                    <Link
                      href={section.href}
                      className="mt-4 inline-flex items-center text-sm text-primary hover:text-primary/80"
                    >
                      <span>Explore section</span>
                      <ArrowRight className="ml-1 h-4 w-4" />
                    </Link>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Help Section */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <div className="rounded-2xl bg-blue-50 p-8 dark:bg-blue-900/10">
          <div className="text-center">
            <HelpCircle className="mx-auto h-12 w-12 text-blue-600 dark:text-blue-400" />
            <h3 className="mt-4 text-lg font-semibold text-gray-900 dark:text-white">
              Need more help?
            </h3>
            <p className="mt-2 text-gray-600 dark:text-gray-300">
              Can't find what you're looking for? Our support team is here to help.
            </p>
            <div className="mt-6 flex flex-col space-y-3 sm:flex-row sm:justify-center sm:space-x-3 sm:space-y-0">
              <Link
                href="/documentation/faq"
                className="btn-outline"
              >
                View FAQ
              </Link>
              <Link
                href="/support"
                className="btn-primary"
              >
                Contact Support
              </Link>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
