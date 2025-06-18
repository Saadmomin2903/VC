'use client'

import { motion } from 'framer-motion'
import { HardDrive, Settings, BarChart3, Trash2, Zap, AlertTriangle, CheckCircle, Clock } from 'lucide-react'

const storageFeatures = [
  {
    icon: HardDrive,
    title: 'Smart Storage Limits',
    description: 'Set per-space storage limits to control disk usage',
    features: [
      'Configurable limits per space',
      'Automatic enforcement',
      'Warning notifications',
      'Graceful degradation'
    ]
  },
  {
    icon: Trash2,
    title: 'Intelligent Cleanup',
    description: 'Automatic cleanup policies to manage old versions',
    features: [
      'Time-based retention',
      'Size-based cleanup',
      'Importance-aware deletion',
      'Manual override options'
    ]
  },
  {
    icon: Zap,
    title: 'Compression & Deduplication',
    description: 'Advanced techniques to minimize storage usage',
    features: [
      'Automatic file compression',
      'Cross-file deduplication',
      'Delta compression',
      'Metadata optimization'
    ]
  }
]

const cleanupPolicies = [
  {
    name: 'Conservative',
    description: 'Keep more versions for longer periods',
    retention: {
      daily: '30 days',
      weekly: '6 months',
      monthly: '2 years'
    },
    bestFor: 'Critical files, legal documents, important projects'
  },
  {
    name: 'Balanced',
    description: 'Good balance between storage and retention',
    retention: {
      daily: '14 days',
      weekly: '3 months',
      monthly: '1 year'
    },
    bestFor: 'Most general use cases, regular work files'
  },
  {
    name: 'Aggressive',
    description: 'Minimize storage usage with shorter retention',
    retention: {
      daily: '7 days',
      weekly: '1 month',
      monthly: '6 months'
    },
    bestFor: 'Temporary files, drafts, experimental work'
  }
]

const optimizationTips = [
  {
    icon: Settings,
    title: 'Configure File Filters',
    description: 'Exclude unnecessary files from versioning',
    tips: [
      'Skip temporary files (.tmp, .cache)',
      'Exclude large media files if not needed',
      'Filter out build artifacts',
      'Ignore system files and folders'
    ]
  },
  {
    icon: BarChart3,
    title: 'Monitor Usage Patterns',
    description: 'Use analytics to optimize storage allocation',
    tips: [
      'Review space usage reports monthly',
      'Identify spaces with excessive growth',
      'Adjust policies based on usage patterns',
      'Archive old spaces when projects end'
    ]
  },
  {
    icon: Clock,
    title: 'Schedule Regular Maintenance',
    description: 'Perform routine maintenance for optimal performance',
    tips: [
      'Run manual cleanup quarterly',
      'Review and update storage limits',
      'Check for orphaned files',
      'Optimize database indexes'
    ]
  }
]

export function StorageGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Storage Management
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Learn how to efficiently manage storage in Augment. Configure limits, optimize usage, 
          and implement cleanup policies to keep your system running smoothly.
        </p>
      </motion.div>

      {/* Storage Features Overview */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Storage Management Features
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Augment provides comprehensive tools to manage storage efficiently and automatically.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {storageFeatures.map((feature, index) => {
            const Icon = feature.icon
            return (
              <div key={feature.title} className="card p-6">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {feature.title}
                  </h3>
                </div>
                <p className="text-gray-600 dark:text-gray-300 mb-4">
                  {feature.description}
                </p>
                <ul className="space-y-2">
                  {feature.features.map((item, itemIndex) => (
                    <li key={itemIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                      <CheckCircle className="h-4 w-4 text-green-500 mt-0.5 flex-shrink-0" />
                      <span>{item}</span>
                    </li>
                  ))}
                </ul>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Setting Storage Limits */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Setting Storage Limits
        </h2>
        <div className="mt-6 card p-6">
          <p className="text-gray-600 dark:text-gray-300 mb-6">
            Storage limits help you control how much disk space each space can use. When a limit 
            is reached, Augment will automatically clean up old versions according to your cleanup policy.
          </p>
          
          <div className="grid gap-6 sm:grid-cols-2">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Recommended Limits</h3>
              <div className="space-y-3">
                <div className="flex justify-between items-center p-3 rounded-lg bg-gray-50 dark:bg-gray-800">
                  <span className="text-sm font-medium">Documents & Text</span>
                  <span className="text-sm text-primary">1-5 GB</span>
                </div>
                <div className="flex justify-between items-center p-3 rounded-lg bg-gray-50 dark:bg-gray-800">
                  <span className="text-sm font-medium">Images & Graphics</span>
                  <span className="text-sm text-primary">5-20 GB</span>
                </div>
                <div className="flex justify-between items-center p-3 rounded-lg bg-gray-50 dark:bg-gray-800">
                  <span className="text-sm font-medium">Video & Audio</span>
                  <span className="text-sm text-primary">20-100 GB</span>
                </div>
                <div className="flex justify-between items-center p-3 rounded-lg bg-gray-50 dark:bg-gray-800">
                  <span className="text-sm font-medium">Code Projects</span>
                  <span className="text-sm text-primary">2-10 GB</span>
                </div>
              </div>
            </div>
            
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">How to Set Limits</h3>
              <ol className="space-y-2">
                <li className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold mt-0.5">1</span>
                  <span>Open space settings</span>
                </li>
                <li className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold mt-0.5">2</span>
                  <span>Navigate to "Storage" tab</span>
                </li>
                <li className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold mt-0.5">3</span>
                  <span>Set maximum storage limit</span>
                </li>
                <li className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold mt-0.5">4</span>
                  <span>Configure warning threshold</span>
                </li>
              </ol>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Cleanup Policies */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Cleanup Policies
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Choose a cleanup policy that matches your needs for version retention and storage efficiency.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {cleanupPolicies.map((policy, index) => (
            <div key={policy.name} className="card p-6">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                {policy.name}
              </h3>
              <p className="text-gray-600 dark:text-gray-300 mb-4">
                {policy.description}
              </p>
              
              <div className="space-y-3 mb-4">
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Daily versions:</span>
                  <span className="text-sm text-primary">{policy.retention.daily}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Weekly versions:</span>
                  <span className="text-sm text-primary">{policy.retention.weekly}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Monthly versions:</span>
                  <span className="text-sm text-primary">{policy.retention.monthly}</span>
                </div>
              </div>
              
              <div className="pt-4 border-t border-gray-200 dark:border-gray-700">
                <div className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Best for:</div>
                <div className="text-sm text-gray-500 dark:text-gray-400">{policy.bestFor}</div>
              </div>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Optimization Tips */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Storage Optimization Tips
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Follow these best practices to maximize storage efficiency and maintain optimal performance.
        </p>
        
        <div className="mt-8 space-y-8">
          {optimizationTips.map((tip, index) => {
            const Icon = tip.icon
            return (
              <div key={tip.title} className="card p-6">
                <div className="flex items-start space-x-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                      {tip.title}
                    </h3>
                    <p className="mt-2 text-gray-600 dark:text-gray-300">
                      {tip.description}
                    </p>
                    <ul className="mt-4 grid gap-2 sm:grid-cols-2">
                      {tip.tips.map((item, itemIndex) => (
                        <li key={itemIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                          <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-primary flex-shrink-0"></div>
                          <span>{item}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Storage Monitoring */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 1.0 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Monitoring Storage Usage
        </h2>
        
        <div className="mt-8 card p-6">
          <p className="text-gray-600 dark:text-gray-300 mb-6">
            Augment provides detailed analytics to help you understand and optimize your storage usage.
          </p>
          
          <div className="grid gap-6 sm:grid-cols-2">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Available Reports</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Storage usage by space</li>
                <li>• Version count and size trends</li>
                <li>• Cleanup activity logs</li>
                <li>• File type distribution</li>
                <li>• Growth rate analysis</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Alerts & Notifications</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Storage limit warnings (80% threshold)</li>
                <li>• Cleanup completion notifications</li>
                <li>• Unusual growth pattern alerts</li>
                <li>• Low disk space warnings</li>
                <li>• Maintenance reminders</li>
              </ul>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
