'use client'

import { motion } from 'framer-motion'
import { CheckCircle, FolderPlus, FileText, Clock, Eye, RotateCcw, Settings, ArrowRight, Lightbulb, Target } from 'lucide-react'
import Link from 'next/link'

const essentialSteps = [
  {
    step: 1,
    icon: FolderPlus,
    title: 'Create Your First Space',
    description: 'Start with a small, important folder to get familiar with how Augment works.',
    actions: [
      'Choose a folder with files you edit regularly (like Documents/Projects)',
      'Click "Create New Space" in Augment',
      'Give it a descriptive name like "My Documents"',
      'Watch as Augment begins protecting your files'
    ],
    tip: 'Start small! Choose a folder with 10-50 files rather than your entire Documents folder.'
  },
  {
    step: 2,
    icon: FileText,
    title: 'Make Your First Edit',
    description: 'Edit a file in your protected space to see versioning in action.',
    actions: [
      'Open any text file or document in your space',
      'Make a small change (add a sentence or modify text)',
      'Save the file normally (Cmd+S)',
      'Return to Augment to see the new version appear'
    ],
    tip: 'Try this with a simple text file first - it\'s easier to see the changes.'
  },
  {
    step: 3,
    icon: Clock,
    title: 'Explore Version History',
    description: 'Learn how to view and navigate through your file versions.',
    actions: [
      'Find the file you just edited in Augment',
      'Click on the file to see its version history',
      'Notice the timestamps and version numbers',
      'Try clicking on different versions to preview them'
    ],
    tip: 'Each version is a complete snapshot - you can always go back to any previous state.'
  },
  {
    step: 4,
    icon: Eye,
    title: 'Preview and Compare',
    description: 'Use Augment\'s preview features to understand what changed.',
    actions: [
      'Select two different versions of your file',
      'Use the "Compare" feature to see differences',
      'Try the preview mode to view file contents',
      'Notice how changes are highlighted'
    ],
    tip: 'Comparison works best with text files, but preview works with most file types.'
  },
  {
    step: 5,
    icon: RotateCcw,
    title: 'Practice File Recovery',
    description: 'Try restoring a previous version to build confidence.',
    actions: [
      'Make another edit to your test file and save it',
      'In Augment, select an older version',
      'Click "Restore" to replace the current version',
      'Verify that the file has been restored successfully'
    ],
    tip: 'Don\'t worry - Augment creates a backup before restoring, so you can always undo.'
  },
  {
    step: 6,
    icon: Settings,
    title: 'Adjust Your Settings',
    description: 'Customize Augment to match your workflow and preferences.',
    actions: [
      'Open space settings for your test space',
      'Review storage limits and cleanup policies',
      'Adjust notification preferences',
      'Consider excluding file types you don\'t need versioned'
    ],
    tip: 'The default settings work well for most users, but customization helps optimize performance.'
  }
]

const keyLearnings = [
  {
    icon: Target,
    title: 'Understanding Spaces',
    description: 'Spaces are isolated protection zones. Each space has its own settings, storage limits, and version history.',
    importance: 'Essential'
  },
  {
    icon: Clock,
    title: 'Automatic vs Manual',
    description: 'Augment creates versions automatically when you save, but you can also create manual snapshots for important milestones.',
    importance: 'Important'
  },
  {
    icon: Eye,
    title: 'Non-Destructive',
    description: 'Viewing and previewing versions never changes your files. Only "Restore" actually modifies your current file.',
    importance: 'Critical'
  }
]

const nextSteps = [
  {
    title: 'Create More Spaces',
    description: 'Add protection for other important folders',
    href: '/documentation/spaces',
    time: '10 min'
  },
  {
    title: 'Learn Advanced Search',
    description: 'Master finding any file or version quickly',
    href: '/documentation/search',
    time: '15 min'
  },
  {
    title: 'Optimize Storage',
    description: 'Configure cleanup policies and storage limits',
    href: '/documentation/storage',
    time: '10 min'
  }
]

export function FirstStepsGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          First Steps with Augment
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Now that you have Augment installed, let's walk through the essential first steps to get you 
          comfortable with file versioning. This guide will build your confidence step by step.
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
                Before You Begin
              </h3>
              <p className="mt-2 text-blue-800 dark:text-blue-200">
                Make sure you have Augment installed and running. If you need help with installation, 
                check out our <Link href="/documentation/installation" className="underline">installation guide</Link>.
                This tutorial will take about 20 minutes and uses a hands-on approach.
              </p>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Essential Steps */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Essential First Steps
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Follow these steps in order to build a solid foundation with Augment.
        </p>
        
        <div className="mt-8 space-y-8">
          {essentialSteps.map((step, index) => {
            const Icon = step.icon
            return (
              <div key={step.step} className="card p-6">
                <div className="flex items-start space-x-4">
                  <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-white font-bold text-lg">
                    {step.step}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center space-x-3 mb-3">
                      <Icon className="h-6 w-6 text-primary" />
                      <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                        {step.title}
                      </h3>
                    </div>
                    <p className="text-gray-600 dark:text-gray-300 mb-4">
                      {step.description}
                    </p>
                    
                    <div className="mb-4">
                      <h4 className="font-medium text-gray-900 dark:text-white mb-2">Action Steps:</h4>
                      <ol className="space-y-2">
                        {step.actions.map((action, actionIndex) => (
                          <li key={actionIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                            <span className="flex h-5 w-5 items-center justify-center rounded-full bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 text-xs font-semibold mt-0.5">
                              {actionIndex + 1}
                            </span>
                            <span>{action}</span>
                          </li>
                        ))}
                      </ol>
                    </div>
                    
                    <div className="rounded-lg bg-yellow-50 p-3 dark:bg-yellow-900/10">
                      <div className="flex items-start space-x-2">
                        <Lightbulb className="h-4 w-4 text-yellow-600 dark:text-yellow-400 mt-0.5" />
                        <p className="text-sm text-yellow-800 dark:text-yellow-200">
                          <strong>Tip:</strong> {step.tip}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Key Learnings */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Key Concepts to Remember
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          These fundamental concepts will help you use Augment effectively.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {keyLearnings.map((learning, index) => {
            const Icon = learning.icon
            const importanceColor = learning.importance === 'Critical' 
              ? 'bg-red-100 text-red-600 dark:bg-red-900/20 dark:text-red-400'
              : learning.importance === 'Essential'
              ? 'bg-blue-100 text-blue-600 dark:bg-blue-900/20 dark:text-blue-400'
              : 'bg-green-100 text-green-600 dark:bg-green-900/20 dark:text-green-400'
            
            return (
              <div key={learning.title} className="card p-6">
                <div className="flex items-center justify-between mb-3">
                  <Icon className="h-6 w-6 text-primary" />
                  <span className={`px-2 py-1 rounded text-xs font-medium ${importanceColor}`}>
                    {learning.importance}
                  </span>
                </div>
                <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                  {learning.title}
                </h3>
                <p className="text-sm text-gray-600 dark:text-gray-300">
                  {learning.description}
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
          Ready for More?
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Great job! You now understand the basics of Augment. Here are the logical next steps to expand your knowledge.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {nextSteps.map((step, index) => (
            <Link key={step.title} href={step.href} className="card p-6 block hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-between mb-3">
                <h3 className="font-semibold text-gray-900 dark:text-white">
                  {step.title}
                </h3>
                <span className="text-sm font-medium text-primary bg-primary/10 px-2 py-1 rounded">
                  {step.time}
                </span>
              </div>
              <p className="text-sm text-gray-600 dark:text-gray-300 mb-4">
                {step.description}
              </p>
              <div className="flex items-center text-sm text-primary">
                <span>Continue learning</span>
                <ArrowRight className="ml-1 h-4 w-4" />
              </div>
            </Link>
          ))}
        </div>
      </motion.div>

      {/* Encouragement */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 1.0 }}
        className="mt-16"
      >
        <div className="rounded-2xl bg-green-50 p-8 dark:bg-green-900/10 text-center">
          <CheckCircle className="mx-auto h-12 w-12 text-green-600 dark:text-green-400" />
          <h3 className="mt-4 text-lg font-semibold text-gray-900 dark:text-white">
            You're Off to a Great Start!
          </h3>
          <p className="mt-2 text-gray-600 dark:text-gray-300">
            You now have the foundation to use Augment confidently. Remember, every file save creates a version, 
            and you can always go back to any previous state. Your files are safer than ever!
          </p>
          <div className="mt-6">
            <Link href="/documentation" className="btn-primary">
              Explore More Documentation
            </Link>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
