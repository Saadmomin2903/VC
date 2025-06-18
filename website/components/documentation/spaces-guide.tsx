'use client'

import { motion } from 'framer-motion'
import { FolderPlus, Settings, Users, Shield, HardDrive, Clock, Search, AlertTriangle } from 'lucide-react'

const spaceTypes = [
  {
    icon: FolderPlus,
    title: 'Personal Spaces',
    description: 'Private spaces for your individual work and projects.',
    features: [
      'Complete privacy and isolation',
      'Custom storage limits',
      'Personal cleanup policies',
      'Individual notification settings'
    ],
    bestFor: 'Documents, creative projects, personal files'
  },
  {
    icon: Users,
    title: 'Shared Spaces',
    description: 'Collaborative spaces for team projects and shared folders.',
    features: [
      'Multi-user access control',
      'Shared version history',
      'Collaborative recovery options',
      'Team notification settings'
    ],
    bestFor: 'Team projects, shared documents, collaborative work'
  },
  {
    icon: Shield,
    title: 'Protected Spaces',
    description: 'High-security spaces for sensitive or critical files.',
    features: [
      'Enhanced encryption',
      'Extended version retention',
      'Audit logging',
      'Advanced recovery options'
    ],
    bestFor: 'Financial documents, legal files, critical business data'
  }
]

const spaceSettings = [
  {
    category: 'Storage Management',
    icon: HardDrive,
    settings: [
      {
        name: 'Storage Limit',
        description: 'Maximum disk space this space can use',
        options: ['1 GB', '5 GB', '10 GB', 'Unlimited']
      },
      {
        name: 'Version Retention',
        description: 'How long to keep old versions',
        options: ['7 days', '30 days', '90 days', 'Forever']
      },
      {
        name: 'Cleanup Policy',
        description: 'When to automatically remove old versions',
        options: ['Conservative', 'Balanced', 'Aggressive', 'Manual']
      }
    ]
  },
  {
    category: 'Version Control',
    icon: Clock,
    settings: [
      {
        name: 'Version Frequency',
        description: 'How often to create new versions',
        options: ['Every save', 'Every 5 minutes', 'Every hour', 'Manual']
      },
      {
        name: 'File Types',
        description: 'Which file types to version',
        options: ['All files', 'Documents only', 'Custom filter', 'Exclude list']
      },
      {
        name: 'Size Threshold',
        description: 'Minimum file size to version',
        options: ['All sizes', '1 KB+', '10 KB+', '100 KB+']
      }
    ]
  }
]

export function SpacesGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Managing Spaces
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Spaces are the foundation of Augment's file versioning system. Learn how to create, 
          configure, and organize spaces for optimal file protection.
        </p>
      </motion.div>

      {/* What is a Space */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          What is a Space?
        </h2>
        <div className="mt-6 card p-6">
          <p className="text-gray-600 dark:text-gray-300">
            A <strong>Space</strong> in Augment is a protected folder where all file changes are automatically 
            versioned. Each space has its own settings, storage limits, and version history. You can create 
            multiple spaces for different projects, file types, or collaboration needs.
          </p>
          <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-primary">∞</div>
              <div className="text-sm text-gray-500 dark:text-gray-400">Unlimited spaces</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary">🔒</div>
              <div className="text-sm text-gray-500 dark:text-gray-400">Isolated protection</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary">⚙️</div>
              <div className="text-sm text-gray-500 dark:text-gray-400">Custom settings</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary">📊</div>
              <div className="text-sm text-gray-500 dark:text-gray-400">Individual analytics</div>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Types of Spaces */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Types of Spaces
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Choose the right type of space based on your needs and security requirements.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {spaceTypes.map((type, index) => {
            const Icon = type.icon
            return (
              <div key={type.title} className="card p-6">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {type.title}
                  </h3>
                </div>
                <p className="text-gray-600 dark:text-gray-300 mb-4">
                  {type.description}
                </p>
                <div className="space-y-2 mb-4">
                  {type.features.map((feature, featureIndex) => (
                    <div key={featureIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                      <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-primary flex-shrink-0"></div>
                      <span>{feature}</span>
                    </div>
                  ))}
                </div>
                <div className="pt-4 border-t border-gray-200 dark:border-gray-700">
                  <div className="text-sm font-medium text-gray-700 dark:text-gray-300">Best for:</div>
                  <div className="text-sm text-gray-500 dark:text-gray-400">{type.bestFor}</div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Creating a Space */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Creating a New Space
        </h2>
        <div className="mt-6 card p-6">
          <div className="space-y-4">
            <div className="flex items-start space-x-3">
              <div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary text-white text-sm font-semibold">1</div>
              <div>
                <div className="font-medium text-gray-900 dark:text-white">Choose a Folder</div>
                <div className="text-sm text-gray-600 dark:text-gray-300">Select the folder you want to protect. This can be any folder on your Mac.</div>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary text-white text-sm font-semibold">2</div>
              <div>
                <div className="font-medium text-gray-900 dark:text-white">Name Your Space</div>
                <div className="text-sm text-gray-600 dark:text-gray-300">Give your space a descriptive name that helps you identify its purpose.</div>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary text-white text-sm font-semibold">3</div>
              <div>
                <div className="font-medium text-gray-900 dark:text-white">Configure Settings</div>
                <div className="text-sm text-gray-600 dark:text-gray-300">Set storage limits, retention policies, and other preferences.</div>
              </div>
            </div>
            <div className="flex items-start space-x-3">
              <div className="flex h-6 w-6 items-center justify-center rounded-full bg-primary text-white text-sm font-semibold">4</div>
              <div>
                <div className="font-medium text-gray-900 dark:text-white">Start Protection</div>
                <div className="text-sm text-gray-600 dark:text-gray-300">Click "Create Space" and Augment will begin protecting your files immediately.</div>
              </div>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Space Settings */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Space Settings
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Customize each space to match your specific needs and workflow.
        </p>
        
        <div className="mt-8 space-y-8">
          {spaceSettings.map((category, index) => {
            const Icon = category.icon
            return (
              <div key={category.category} className="card p-6">
                <div className="flex items-center space-x-3 mb-6">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-4 w-4" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {category.category}
                  </h3>
                </div>
                <div className="space-y-4">
                  {category.settings.map((setting, settingIndex) => (
                    <div key={setting.name} className="border-l-2 border-gray-200 dark:border-gray-700 pl-4">
                      <div className="font-medium text-gray-900 dark:text-white">{setting.name}</div>
                      <div className="text-sm text-gray-600 dark:text-gray-300 mb-2">{setting.description}</div>
                      <div className="flex flex-wrap gap-2">
                        {setting.options.map((option, optionIndex) => (
                          <span key={optionIndex} className="inline-flex items-center px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200">
                            {option}
                          </span>
                        ))}
                      </div>
                    </div>
                  ))}
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
        transition={{ duration: 0.6, delay: 1.0 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Best Practices
        </h2>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2">
          <div className="card p-6">
            <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Organization Tips</h3>
            <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
              <li>• Create separate spaces for different projects</li>
              <li>• Use descriptive names that indicate the space's purpose</li>
              <li>• Group related files in the same space</li>
              <li>• Consider creating spaces by file type or importance</li>
            </ul>
          </div>
          
          <div className="card p-6">
            <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Performance Tips</h3>
            <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
              <li>• Set appropriate storage limits to manage disk usage</li>
              <li>• Use conservative cleanup policies for important files</li>
              <li>• Exclude temporary files and caches</li>
              <li>• Monitor space usage regularly</li>
            </ul>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
