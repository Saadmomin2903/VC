'use client'

import { motion } from 'framer-motion'
import { useState } from 'react'
import { ChevronDown, ChevronUp, HelpCircle, Shield, Zap, HardDrive, Clock, Users } from 'lucide-react'

const faqCategories = [
  {
    category: 'General Questions',
    icon: HelpCircle,
    questions: [
      {
        question: 'What is Augment and how does it work?',
        answer: 'Augment is an intelligent file versioning system for macOS that automatically saves every version of your files. When you save a file in a protected space, Augment creates a complete snapshot that you can restore later. It works silently in the background without disrupting your workflow.'
      },
      {
        question: 'How is Augment different from Time Machine or cloud backup?',
        answer: 'Unlike Time Machine which backs up your entire system periodically, Augment focuses specifically on file versioning with instant, per-save granularity. Unlike cloud backup, all data stays on your Mac for complete privacy. Augment provides immediate access to any version without waiting for downloads or system restores.'
      },
      {
        question: 'Do I need an internet connection to use Augment?',
        answer: 'No, Augment works completely offline. All versioning, storage, and recovery happens locally on your Mac. You never need an internet connection to access your file versions or use any of Augment\'s features.'
      },
      {
        question: 'Can I use Augment alongside other backup solutions?',
        answer: 'Yes, Augment complements other backup solutions perfectly. You can continue using Time Machine, cloud storage, or any other backup system. Augment focuses on immediate file versioning while other solutions handle broader backup needs.'
      }
    ]
  },
  {
    category: 'Privacy & Security',
    icon: Shield,
    questions: [
      {
        question: 'Is my data private and secure?',
        answer: 'Absolutely. All your data stays on your Mac - Augment never uploads, transmits, or accesses your files remotely. Version data is stored locally with encryption, and only you have access to your file versions. We have no servers that store your data.'
      },
      {
        question: 'What permissions does Augment need?',
        answer: 'Augment needs Full Disk Access to monitor and version files in your protected spaces. This permission is granted through System Preferences > Security & Privacy. We only access files within spaces you explicitly create and never scan or access other areas of your system.'
      },
      {
        question: 'Can other users on my Mac see my file versions?',
        answer: 'No, file versions are isolated per user account. Each user\'s spaces and versions are completely separate and private. Even administrators cannot access another user\'s Augment data without their explicit permission.'
      }
    ]
  },
  {
    category: 'Performance & Storage',
    icon: HardDrive,
    questions: [
      {
        question: 'How much storage space does Augment use?',
        answer: 'Storage usage depends on your files and settings. Augment uses intelligent compression and deduplication to minimize space usage. You can set storage limits per space and configure cleanup policies. Typically, versioning adds 20-50% to your original file storage needs.'
      },
      {
        question: 'Will Augment slow down my Mac?',
        answer: 'No, Augment is designed for minimal performance impact. Versioning happens in the background using efficient algorithms. Most users notice no difference in their Mac\'s performance. You can adjust settings if you experience any issues on older hardware.'
      },
      {
        question: 'How do I manage storage if I\'m running out of space?',
        answer: 'Augment provides several tools: set storage limits per space, configure automatic cleanup policies, manually delete old versions, and exclude large files from versioning. The storage management interface shows detailed usage analytics to help you optimize.'
      },
      {
        question: 'What happens when I reach my storage limit?',
        answer: 'When a space reaches its storage limit, Augment automatically cleans up the oldest versions according to your cleanup policy. Recent versions are always preserved. You\'ll receive notifications before limits are reached so you can adjust settings if needed.'
      }
    ]
  }
]

export function FAQGuide() {
  const [openItems, setOpenItems] = useState<Record<string, boolean>>({})

  const toggleItem = (categoryIndex: number, questionIndex: number) => {
    const key = `${categoryIndex}-${questionIndex}`
    setOpenItems(prev => ({
      ...prev,
      [key]: !prev[key]
    }))
  }

  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Frequently Asked Questions
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Find quick answers to the most common questions about Augment. 
          Can't find what you're looking for? Contact our support team.
        </p>
      </motion.div>

      {/* FAQ Categories */}
      <div className="mt-12 space-y-12">
        {faqCategories.map((category, categoryIndex) => {
          const Icon = category.icon
          return (
            <motion.div
              key={category.category}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: categoryIndex * 0.1 }}
            >
              <div className="flex items-center space-x-3 mb-8">
                <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                  <Icon className="h-4 w-4" />
                </div>
                <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
                  {category.category}
                </h2>
              </div>

              <div className="space-y-4">
                {category.questions.map((faq, questionIndex) => {
                  const isOpen = openItems[`${categoryIndex}-${questionIndex}`]
                  return (
                    <div key={questionIndex} className="card overflow-hidden">
                      <button
                        onClick={() => toggleItem(categoryIndex, questionIndex)}
                        className="w-full px-6 py-4 text-left flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
                      >
                        <h3 className="font-semibold text-gray-900 dark:text-white pr-4">
                          {faq.question}
                        </h3>
                        {isOpen ? (
                          <ChevronUp className="h-5 w-5 text-gray-500 flex-shrink-0" />
                        ) : (
                          <ChevronDown className="h-5 w-5 text-gray-500 flex-shrink-0" />
                        )}
                      </button>
                      
                      {isOpen && (
                        <motion.div
                          initial={{ opacity: 0, height: 0 }}
                          animate={{ opacity: 1, height: 'auto' }}
                          exit={{ opacity: 0, height: 0 }}
                          transition={{ duration: 0.3 }}
                          className="px-6 pb-4"
                        >
                          <div className="pt-2 border-t border-gray-200 dark:border-gray-700">
                            <p className="text-gray-600 dark:text-gray-300 leading-relaxed">
                              {faq.answer}
                            </p>
                          </div>
                        </motion.div>
                      )}
                    </div>
                  )
                })}
              </div>
            </motion.div>
          )
        })}
      </div>

      {/* Still Need Help */}
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
              Still need help?
            </h3>
            <p className="mt-2 text-gray-600 dark:text-gray-300">
              Can't find the answer you're looking for? Our support team is here to help.
            </p>
            <div className="mt-6 flex flex-col space-y-3 sm:flex-row sm:justify-center sm:space-x-3 sm:space-y-0">
              <a
                href="/support"
                className="btn-primary"
              >
                Contact Support
              </a>
              <a
                href="/documentation"
                className="btn-outline"
              >
                Browse Documentation
              </a>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
