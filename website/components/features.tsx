'use client'

import { motion } from 'framer-motion'
import { 
  Clock, 
  Shield, 
  Search, 
  RotateCcw, 
  HardDrive, 
  Bell,
  Zap,
  FileText,
  Settings
} from 'lucide-react'

const features = [
  {
    icon: Clock,
    title: 'Automatic Versioning',
    description: 'Every file change is automatically saved as a new version. No manual intervention required.',
    color: 'text-blue-600 dark:text-blue-400'
  },
  {
    icon: Search,
    title: 'Powerful Search',
    description: 'Find any version of any file instantly with our advanced search and filtering system.',
    color: 'text-green-600 dark:text-green-400'
  },
  {
    icon: RotateCcw,
    title: 'Easy Recovery',
    description: 'Restore previous versions with a single click. Compare versions side by side.',
    color: 'text-purple-600 dark:text-purple-400'
  },
  {
    icon: HardDrive,
    title: 'Smart Storage',
    description: 'Intelligent storage management with automatic cleanup and configurable policies.',
    color: 'text-orange-600 dark:text-orange-400'
  },
  {
    icon: Bell,
    title: 'Smart Notifications',
    description: 'Get notified about storage issues, cleanup activities, and important events.',
    color: 'text-red-600 dark:text-red-400'
  },
  {
    icon: Shield,
    title: 'Error Recovery',
    description: 'Automatic error detection and recovery with user-friendly guidance.',
    color: 'text-indigo-600 dark:text-indigo-400'
  },
  {
    icon: Zap,
    title: 'Lightning Fast',
    description: 'Optimized performance with minimal system impact and instant file access.',
    color: 'text-yellow-600 dark:text-yellow-400'
  },
  {
    icon: FileText,
    title: 'Universal Support',
    description: 'Works with all file types - documents, images, code, and more.',
    color: 'text-teal-600 dark:text-teal-400'
  },
  {
    icon: Settings,
    title: 'Customizable',
    description: 'Configure spaces, storage limits, cleanup policies, and notification preferences.',
    color: 'text-gray-600 dark:text-gray-400'
  }
]

export function Features() {
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
              Everything you need for{' '}
              <span className="gradient-text">intelligent file versioning</span>
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Augment provides a comprehensive suite of features designed to keep your files safe, 
              organized, and easily recoverable.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {features.map((feature, index) => {
            const Icon = feature.icon
            return (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="group relative"
              >
                <div className="card p-6 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className="flex items-start space-x-4">
                    <div className={`flex h-12 w-12 items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 ${feature.color}`}>
                      <Icon className="h-6 w-6" />
                    </div>
                    <div className="flex-1">
                      <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                        {feature.title}
                      </h3>
                      <p className="mt-2 text-gray-600 dark:text-gray-300">
                        {feature.description}
                      </p>
                    </div>
                  </div>
                </div>
              </motion.div>
            )
          })}
        </div>

        {/* Feature highlight */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-blue-600 to-purple-600 p-8 text-white">
            <div className="grid gap-8 lg:grid-cols-2 lg:items-center">
              <div>
                <h3 className="text-2xl font-bold">
                  Zero Configuration Required
                </h3>
                <p className="mt-4 text-blue-100">
                  Augment works out of the box with intelligent defaults. 
                  Simply install, create your first space, and start working. 
                  Advanced users can customize every aspect to their needs.
                </p>
                <div className="mt-6 flex flex-wrap gap-4">
                  <div className="flex items-center space-x-2">
                    <Zap className="h-5 w-5" />
                    <span>Instant setup</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Shield className="h-5 w-5" />
                    <span>Secure by default</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Settings className="h-5 w-5" />
                    <span>Fully customizable</span>
                  </div>
                </div>
              </div>
              <div className="relative">
                <div className="rounded-lg bg-white/10 p-6 backdrop-blur-sm">
                  <div className="space-y-3">
                    <div className="flex items-center justify-between">
                      <span className="text-sm">Setup Progress</span>
                      <span className="text-sm">100%</span>
                    </div>
                    <div className="h-2 rounded-full bg-white/20">
                      <div className="h-2 w-full rounded-full bg-white"></div>
                    </div>
                    <div className="text-sm text-blue-100">
                      ✓ Augment is ready to protect your files
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
