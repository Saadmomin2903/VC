'use client'

import { motion } from 'framer-motion'
import { 
  Clock, 
  Search, 
  RotateCcw, 
  HardDrive, 
  Bell, 
  Shield,
  Zap,
  FileText,
  Settings,
  Users,
  Lock,
  Smartphone
} from 'lucide-react'

const features = [
  {
    category: 'Core Features',
    items: [
      {
        icon: Clock,
        title: 'Automatic File Versioning',
        description: 'Every file change is automatically saved as a new version without any manual intervention.',
        benefits: [
          'Real-time version creation on file save',
          'Works with all file types and applications',
          'Zero workflow disruption',
          'Intelligent deduplication to save space'
        ]
      },
      {
        icon: Search,
        title: 'Advanced Search & Filtering',
        description: 'Find any version of any file instantly with powerful search capabilities.',
        benefits: [
          'Full-text search across all versions',
          'Filter by date, size, file type',
          'Search within file contents',
          'Visual timeline navigation'
        ]
      },
      {
        icon: RotateCcw,
        title: 'One-Click File Recovery',
        description: 'Restore previous versions with a single click or compare versions side by side.',
        benefits: [
          'Instant version restoration',
          'Side-by-side comparison view',
          'Selective file restoration',
          'Batch recovery operations'
        ]
      }
    ]
  },
  {
    category: 'Smart Management',
    items: [
      {
        icon: HardDrive,
        title: 'Intelligent Storage Management',
        description: 'Smart storage policies automatically manage disk space and cleanup old versions.',
        benefits: [
          'Configurable storage limits per space',
          'Automatic cleanup of old versions',
          'Smart compression and deduplication',
          'Storage usage analytics'
        ]
      },
      {
        icon: Bell,
        title: 'Smart Notifications',
        description: 'Get notified about important events, storage issues, and system status.',
        benefits: [
          'Storage threshold warnings',
          'Cleanup completion notifications',
          'Error recovery alerts',
          'Customizable notification preferences'
        ]
      },
      {
        icon: Shield,
        title: 'Automatic Error Recovery',
        description: 'Intelligent error detection and recovery with user-friendly guidance.',
        benefits: [
          'Automatic error categorization',
          'Multiple recovery strategies per error',
          'Self-healing capabilities',
          'Detailed error reporting'
        ]
      }
    ]
  },
  {
    category: 'User Experience',
    items: [
      {
        icon: Zap,
        title: 'Lightning Fast Performance',
        description: 'Optimized for speed with minimal system impact and instant file access.',
        benefits: [
          'Sub-second file access',
          'Minimal CPU and memory usage',
          'Background processing',
          'Optimized for SSDs and modern Macs'
        ]
      },
      {
        icon: FileText,
        title: 'Universal File Support',
        description: 'Works with all file types - documents, images, code, videos, and more.',
        benefits: [
          'Support for all file formats',
          'Preserves file metadata',
          'Application-agnostic operation',
          'Large file handling'
        ]
      },
      {
        icon: Settings,
        title: 'Highly Customizable',
        description: 'Configure every aspect to match your workflow and preferences.',
        benefits: [
          'Flexible space configuration',
          'Custom storage policies',
          'Personalized notification settings',
          'Advanced user preferences'
        ]
      }
    ]
  },
  {
    category: 'Security & Privacy',
    items: [
      {
        icon: Lock,
        title: '100% Private & Secure',
        description: 'All data stays on your Mac. No cloud storage, no external servers.',
        benefits: [
          'Complete local storage',
          'No data transmission',
          'Encrypted version storage',
          'Privacy by design'
        ]
      },
      {
        icon: Users,
        title: 'Multi-User Support',
        description: 'Works seamlessly in multi-user environments with proper isolation.',
        benefits: [
          'Per-user space isolation',
          'Shared space capabilities',
          'User-specific preferences',
          'Admin management tools'
        ]
      },
      {
        icon: Smartphone,
        title: 'Modern macOS Integration',
        description: 'Built specifically for macOS with native integration and design.',
        benefits: [
          'Native macOS design language',
          'System-level integration',
          'Spotlight search integration',
          'Finder context menus'
        ]
      }
    ]
  }
]

export function FeaturesList() {
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
              Complete feature breakdown
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Every feature is designed to work together seamlessly, providing you with 
              the most comprehensive file protection system available for macOS.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 space-y-16">
          {features.map((category, categoryIndex) => (
            <motion.div
              key={category.category}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: categoryIndex * 0.1 }}
              viewport={{ once: true }}
            >
              <div className="mb-8">
                <h3 className="text-2xl font-bold text-gray-900 dark:text-white">
                  {category.category}
                </h3>
              </div>

              <div className="grid gap-8 lg:grid-cols-2 xl:grid-cols-3">
                {category.items.map((feature, featureIndex) => {
                  const Icon = feature.icon
                  return (
                    <motion.div
                      key={feature.title}
                      initial={{ opacity: 0, y: 20 }}
                      whileInView={{ opacity: 1, y: 0 }}
                      transition={{ duration: 0.6, delay: featureIndex * 0.1 }}
                      viewport={{ once: true }}
                      className="group"
                    >
                      <div className="card p-6 h-full transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                        <div className="flex items-start space-x-4">
                          <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10 text-primary">
                            <Icon className="h-6 w-6" />
                          </div>
                          <div className="flex-1">
                            <h4 className="text-lg font-semibold text-gray-900 dark:text-white">
                              {feature.title}
                            </h4>
                            <p className="mt-2 text-gray-600 dark:text-gray-300">
                              {feature.description}
                            </p>
                            
                            <ul className="mt-4 space-y-2">
                              {feature.benefits.map((benefit, benefitIndex) => (
                                <li
                                  key={benefitIndex}
                                  className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400"
                                >
                                  <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-primary flex-shrink-0"></div>
                                  <span>{benefit}</span>
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
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
