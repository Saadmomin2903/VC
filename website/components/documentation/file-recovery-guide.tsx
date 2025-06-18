'use client'

import { motion } from 'framer-motion'
import { RotateCcw, Download, Copy, AlertTriangle, CheckCircle, Clock, Shield, Zap } from 'lucide-react'

const recoveryMethods = [
  {
    icon: RotateCcw,
    title: 'In-Place Restoration',
    description: 'Replace the current file with a previous version',
    steps: [
      'Select the file in Augment',
      'Choose the version you want to restore',
      'Click "Restore" button',
      'Confirm the restoration'
    ],
    bestFor: 'When you want to completely revert to an older version',
    warning: 'This will overwrite your current file'
  },
  {
    icon: Copy,
    title: 'Copy to New Location',
    description: 'Save a previous version as a new file',
    steps: [
      'Select the version you want to recover',
      'Click "Copy Version"',
      'Choose a destination folder',
      'Give the copy a new name'
    ],
    bestFor: 'When you want to keep both the current and old versions',
    warning: 'Creates a duplicate file'
  },
  {
    icon: Download,
    title: 'Export Version',
    description: 'Download a previous version to any location',
    steps: [
      'Right-click on the desired version',
      'Select "Export Version"',
      'Choose export location',
      'File is saved with timestamp'
    ],
    bestFor: 'When you need to share or archive a specific version',
    warning: 'Exported file is not tracked by Augment'
  }
]

const recoveryScenarios = [
  {
    icon: AlertTriangle,
    title: 'Accidental Deletion',
    description: 'File was accidentally deleted from the file system',
    solution: 'Use "Restore Deleted File" from the space overview',
    steps: [
      'Open the space where the file was located',
      'Look for files marked as "Deleted"',
      'Select the deleted file',
      'Choose "Restore to Original Location"'
    ]
  },
  {
    icon: Clock,
    title: 'Corrupted File',
    description: 'Current file is corrupted or won\'t open',
    solution: 'Restore the most recent working version',
    steps: [
      'Find the file in Augment',
      'Look for the last version before corruption',
      'Use in-place restoration',
      'Test the restored file'
    ]
  },
  {
    icon: Shield,
    title: 'Unwanted Changes',
    description: 'Need to undo recent modifications',
    solution: 'Compare versions and restore selectively',
    steps: [
      'Use side-by-side comparison',
      'Identify the last good version',
      'Restore that version',
      'Re-apply any wanted changes'
    ]
  }
]

const safetyFeatures = [
  {
    title: 'Backup Before Restore',
    description: 'Augment automatically creates a backup of your current file before any restoration',
    icon: Shield
  },
  {
    title: 'Undo Restoration',
    description: 'You can undo any restoration within 24 hours using the "Undo Last Restore" feature',
    icon: RotateCcw
  },
  {
    title: 'Verification Checks',
    description: 'Augment verifies file integrity before and after restoration to prevent corruption',
    icon: CheckCircle
  },
  {
    title: 'Atomic Operations',
    description: 'All restoration operations are atomic - they either complete fully or not at all',
    icon: Zap
  }
]

export function FileRecoveryGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          File Recovery Guide
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Learn how to recover and restore previous versions of your files safely and efficiently. 
          Augment provides multiple recovery methods to handle any situation.
        </p>
      </motion.div>

      {/* Recovery Methods */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Recovery Methods
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Choose the right recovery method based on your specific needs and situation.
        </p>
        
        <div className="mt-8 space-y-8">
          {recoveryMethods.map((method, index) => {
            const Icon = method.icon
            return (
              <div key={method.title} className="card p-6">
                <div className="flex items-start space-x-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                      {method.title}
                    </h3>
                    <p className="mt-2 text-gray-600 dark:text-gray-300">
                      {method.description}
                    </p>
                    
                    <div className="mt-4 grid gap-6 lg:grid-cols-2">
                      <div>
                        <h4 className="font-medium text-gray-900 dark:text-white mb-2">Steps:</h4>
                        <ol className="space-y-1">
                          {method.steps.map((step, stepIndex) => (
                            <li key={stepIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                              <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold mt-0.5">
                                {stepIndex + 1}
                              </span>
                              <span>{step}</span>
                            </li>
                          ))}
                        </ol>
                      </div>
                      
                      <div>
                        <div className="mb-3">
                          <h4 className="font-medium text-gray-900 dark:text-white mb-1">Best for:</h4>
                          <p className="text-sm text-gray-600 dark:text-gray-300">{method.bestFor}</p>
                        </div>
                        <div className="rounded-lg bg-yellow-50 p-3 dark:bg-yellow-900/10">
                          <div className="flex items-start space-x-2">
                            <AlertTriangle className="h-4 w-4 text-yellow-600 dark:text-yellow-400 mt-0.5" />
                            <p className="text-sm text-yellow-800 dark:text-yellow-200">
                              <strong>Note:</strong> {method.warning}
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Common Recovery Scenarios */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Common Recovery Scenarios
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Here's how to handle the most common file recovery situations.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {recoveryScenarios.map((scenario, index) => {
            const Icon = scenario.icon
            return (
              <div key={scenario.title} className="card p-6">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-red-100 text-red-600 dark:bg-red-900/20 dark:text-red-400">
                    <Icon className="h-4 w-4" />
                  </div>
                  <h3 className="font-semibold text-gray-900 dark:text-white">
                    {scenario.title}
                  </h3>
                </div>
                <p className="text-gray-600 dark:text-gray-300 mb-4">
                  {scenario.description}
                </p>
                <div className="rounded-lg bg-green-50 p-3 dark:bg-green-900/10 mb-4">
                  <p className="text-sm text-green-800 dark:text-green-200">
                    <strong>Solution:</strong> {scenario.solution}
                  </p>
                </div>
                <div>
                  <h4 className="font-medium text-gray-900 dark:text-white mb-2">Steps:</h4>
                  <ol className="space-y-1">
                    {scenario.steps.map((step, stepIndex) => (
                      <li key={stepIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                        <span className="text-primary">•</span>
                        <span>{step}</span>
                      </li>
                    ))}
                  </ol>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Safety Features */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Safety Features
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Augment includes several safety features to protect you during file recovery operations.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2">
          {safetyFeatures.map((feature, index) => {
            const Icon = feature.icon
            return (
              <div key={feature.title} className="card p-6">
                <div className="flex items-start space-x-3">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-green-100 text-green-600 dark:bg-green-900/20 dark:text-green-400">
                    <Icon className="h-4 w-4" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {feature.title}
                    </h3>
                    <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                      {feature.description}
                    </p>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Best Practices */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Recovery Best Practices
        </h2>
        
        <div className="mt-8 card p-6">
          <div className="grid gap-6 sm:grid-cols-2">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Before Recovery</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Always preview the version before restoring</li>
                <li>• Compare with the current version to understand changes</li>
                <li>• Check the timestamp to ensure it's the right version</li>
                <li>• Consider copying instead of in-place restoration</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">After Recovery</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Test the restored file immediately</li>
                <li>• Verify all content is as expected</li>
                <li>• Check file permissions and metadata</li>
                <li>• Create a manual backup if needed</li>
              </ul>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
