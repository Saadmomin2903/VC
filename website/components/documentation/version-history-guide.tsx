'use client'

import { motion } from 'framer-motion'
import { Clock, Eye, RotateCcw, GitBranch, FileText, Calendar, Search, Filter } from 'lucide-react'

const versionTypes = [
  {
    icon: Clock,
    title: 'Automatic Versions',
    description: 'Created every time you save a file',
    color: 'text-blue-600 dark:text-blue-400',
    bgColor: 'bg-blue-100 dark:bg-blue-900/20'
  },
  {
    icon: GitBranch,
    title: 'Manual Snapshots',
    description: 'Created when you manually create a checkpoint',
    color: 'text-green-600 dark:text-green-400',
    bgColor: 'bg-green-100 dark:bg-green-900/20'
  },
  {
    icon: Calendar,
    title: 'Scheduled Versions',
    description: 'Created at regular intervals (hourly, daily)',
    color: 'text-purple-600 dark:text-purple-400',
    bgColor: 'bg-purple-100 dark:bg-purple-900/20'
  }
]

const viewingOptions = [
  {
    icon: Eye,
    title: 'Preview Mode',
    description: 'View file contents without opening the original application',
    features: [
      'Quick preview of text files',
      'Image thumbnails and previews',
      'Document structure view',
      'Metadata information'
    ]
  },
  {
    icon: FileText,
    title: 'Side-by-Side Comparison',
    description: 'Compare two versions to see exactly what changed',
    features: [
      'Highlighted differences',
      'Line-by-line comparison',
      'Visual diff for images',
      'Change statistics'
    ]
  },
  {
    icon: Search,
    title: 'Version Search',
    description: 'Find specific versions based on content or metadata',
    features: [
      'Search within version content',
      'Filter by date range',
      'Filter by file size',
      'Search by modification type'
    ]
  }
]

const navigationTips = [
  {
    title: 'Timeline View',
    description: 'Use the timeline slider to quickly jump between versions',
    tip: 'Drag the timeline handle or click on specific points to navigate'
  },
  {
    title: 'Keyboard Shortcuts',
    description: 'Navigate versions quickly with keyboard shortcuts',
    tip: 'Use ← → arrow keys to move between versions, Space to preview'
  },
  {
    title: 'Version Labels',
    description: 'Add custom labels to important versions for easy identification',
    tip: 'Right-click any version and select "Add Label" to mark it'
  },
  {
    title: 'Bulk Operations',
    description: 'Select multiple versions for batch operations',
    tip: 'Hold Cmd while clicking to select multiple versions'
  }
]

export function VersionHistoryGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Understanding Version History
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Learn how Augment tracks and organizes file versions, and master the tools for 
          navigating through your file's complete history.
        </p>
      </motion.div>

      {/* How Versioning Works */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          How Versioning Works
        </h2>
        <div className="mt-6 card p-6">
          <p className="text-gray-600 dark:text-gray-300 mb-6">
            Augment automatically creates a new version every time you save a file. Each version 
            is a complete snapshot of your file at that moment in time, allowing you to go back 
            to any previous state without losing your current work.
          </p>
          
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {versionTypes.map((type, index) => {
              const Icon = type.icon
              return (
                <div key={type.title} className="text-center">
                  <div className={`mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-lg ${type.bgColor}`}>
                    <Icon className={`h-6 w-6 ${type.color}`} />
                  </div>
                  <h3 className="font-semibold text-gray-900 dark:text-white">
                    {type.title}
                  </h3>
                  <p className="mt-1 text-sm text-gray-600 dark:text-gray-300">
                    {type.description}
                  </p>
                </div>
              )
            })}
          </div>
        </div>
      </motion.div>

      {/* Viewing Versions */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Viewing and Comparing Versions
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Augment provides multiple ways to view and compare different versions of your files.
        </p>
        
        <div className="mt-8 space-y-8">
          {viewingOptions.map((option, index) => {
            const Icon = option.icon
            return (
              <div key={option.title} className="card p-6">
                <div className="flex items-start space-x-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                      {option.title}
                    </h3>
                    <p className="mt-2 text-gray-600 dark:text-gray-300">
                      {option.description}
                    </p>
                    <div className="mt-4 grid gap-2 sm:grid-cols-2">
                      {option.features.map((feature, featureIndex) => (
                        <div key={featureIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                          <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-primary flex-shrink-0"></div>
                          <span>{feature}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Version Information */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Version Information
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Each version contains detailed metadata to help you understand what changed and when.
        </p>
        
        <div className="mt-8 card p-6">
          <div className="grid gap-6 sm:grid-cols-2">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Basic Information</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• <strong>Timestamp:</strong> Exact date and time of creation</li>
                <li>• <strong>File Size:</strong> Size of the file at that version</li>
                <li>• <strong>Application:</strong> Which app was used to modify the file</li>
                <li>• <strong>User:</strong> Who made the changes (in multi-user environments)</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Advanced Metadata</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• <strong>Change Type:</strong> What kind of modification was made</li>
                <li>• <strong>File Hash:</strong> Unique identifier for the version</li>
                <li>• <strong>Compression:</strong> Storage optimization information</li>
                <li>• <strong>Labels:</strong> Custom tags you've added</li>
              </ul>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Navigation Tips */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Navigation Tips & Tricks
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Master these techniques to efficiently navigate through your version history.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2">
          {navigationTips.map((tip, index) => (
            <div key={tip.title} className="card p-6">
              <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                {tip.title}
              </h3>
              <p className="text-gray-600 dark:text-gray-300 mb-3">
                {tip.description}
              </p>
              <div className="rounded-lg bg-blue-50 p-3 dark:bg-blue-900/10">
                <p className="text-sm text-blue-800 dark:text-blue-200">
                  <strong>Tip:</strong> {tip.tip}
                </p>
              </div>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Version Limits */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 1.0 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Version Limits and Cleanup
        </h2>
        
        <div className="mt-8 card p-6">
          <p className="text-gray-600 dark:text-gray-300 mb-6">
            To manage storage space efficiently, Augment automatically cleans up old versions 
            based on your space settings. You can configure these policies to match your needs.
          </p>
          
          <div className="grid gap-6 sm:grid-cols-2">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Default Cleanup Policy</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Keep all versions from the last 7 days</li>
                <li>• Keep daily snapshots for the last 30 days</li>
                <li>• Keep weekly snapshots for the last 90 days</li>
                <li>• Keep monthly snapshots beyond that</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Protected Versions</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Manually labeled versions are never deleted</li>
                <li>• Versions marked as "important" are preserved</li>
                <li>• Recent versions (last 24 hours) are always kept</li>
                <li>• You can manually protect any version</li>
              </ul>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
