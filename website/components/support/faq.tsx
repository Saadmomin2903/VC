'use client'

import { motion } from 'framer-motion'
import { useState } from 'react'
import { ChevronDown, ChevronUp, Search } from 'lucide-react'

const faqCategories = [
  {
    name: 'Getting Started',
    faqs: [
      {
        question: 'How do I create my first space?',
        answer: 'After installing Augment, launch the app and follow the onboarding process. You\'ll be guided to select a folder to monitor, which becomes your first space. You can also create additional spaces later from the main interface.'
      },
      {
        question: 'What happens after I create a space?',
        answer: 'Once you create a space, Augment automatically monitors all files in that folder. Every time you save a file, a new version is created and stored safely. You can continue working normally - Augment works invisibly in the background.'
      },
      {
        question: 'How do I access my file versions?',
        answer: 'Right-click any file in a monitored space and select "View Version History" from the context menu. You can also use the Augment app to browse all your spaces and file versions.'
      }
    ]
  },
  {
    name: 'File Management',
    faqs: [
      {
        question: 'Which file types are supported?',
        answer: 'Augment works with all file types - documents, images, videos, code files, and more. There are no restrictions on file formats or sizes.'
      },
      {
        question: 'How many versions are kept?',
        answer: 'By default, Augment keeps all versions until you reach your storage limit. You can configure automatic cleanup policies in preferences to manage older versions.'
      },
      {
        question: 'Can I restore a previous version?',
        answer: 'Yes! Browse the version history for any file and click "Restore" next to the version you want. The file will be restored to that exact state instantly.'
      }
    ]
  },
  {
    name: 'Storage & Performance',
    faqs: [
      {
        question: 'How much storage does Augment use?',
        answer: 'Storage usage depends on your files and how often they change. Augment uses smart deduplication to minimize space usage. You can set storage limits and cleanup policies in preferences.'
      },
      {
        question: 'Does Augment slow down my Mac?',
        answer: 'No, Augment is designed to be lightweight and efficient. It uses minimal CPU and memory, running quietly in the background without affecting your Mac\'s performance.'
      },
      {
        question: 'Can I change storage settings?',
        answer: 'Yes, go to Augment preferences to configure storage limits per space, automatic cleanup policies, and notification preferences.'
      }
    ]
  },
  {
    name: 'Privacy & Security',
    faqs: [
      {
        question: 'Where are my files stored?',
        answer: 'All your files and versions are stored locally on your Mac. Augment never uploads your data to the cloud or external servers. Your privacy is completely protected.'
      },
      {
        question: 'Can others access my versions?',
        answer: 'No, your file versions are stored in a secure location on your Mac with proper permissions. Only you can access them through Augment or by navigating to the storage location.'
      },
      {
        question: 'What happens if I uninstall Augment?',
        answer: 'Your original files remain untouched. Version data is stored separately and can be removed from preferences if desired, or kept for future use if you reinstall Augment.'
      }
    ]
  }
]

export function FAQ() {
  const [openItems, setOpenItems] = useState<string[]>([])
  const [searchQuery, setSearchQuery] = useState('')

  const toggleItem = (id: string) => {
    setOpenItems(prev => 
      prev.includes(id) 
        ? prev.filter(i => i !== id)
        : [...prev, id]
    )
  }

  const filteredCategories = faqCategories.map(category => ({
    ...category,
    faqs: category.faqs.filter(faq => 
      faq.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
      faq.answer.toLowerCase().includes(searchQuery.toLowerCase())
    )
  })).filter(category => category.faqs.length > 0)

  return (
    <section className="section bg-gray-50 dark:bg-gray-800">
      <div className="container">
        <div className="mx-auto max-w-3xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl">
              Frequently asked questions
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Find quick answers to common questions about using Augment.
            </p>
          </motion.div>
        </div>

        {/* Search */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          viewport={{ once: true }}
          className="mt-8 mx-auto max-w-md"
        >
          <div className="relative">
            <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              placeholder="Search FAQs..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full rounded-lg border border-gray-200 bg-white pl-10 pr-4 py-3 text-sm focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary dark:border-gray-700 dark:bg-gray-900 dark:text-white"
            />
          </div>
        </motion.div>

        {/* FAQ Categories */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16 mx-auto max-w-4xl"
        >
          {filteredCategories.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-gray-500 dark:text-gray-400">
                No FAQs found matching your search.
              </p>
            </div>
          ) : (
            <div className="space-y-8">
              {filteredCategories.map((category, categoryIndex) => (
                <div key={category.name}>
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
                    {category.name}
                  </h3>
                  
                  <div className="space-y-3">
                    {category.faqs.map((faq, faqIndex) => {
                      const itemId = `${category.name}-${faqIndex}`
                      return (
                        <motion.div
                          key={itemId}
                          initial={{ opacity: 0, y: 10 }}
                          whileInView={{ opacity: 1, y: 0 }}
                          transition={{ duration: 0.4, delay: faqIndex * 0.05 }}
                          viewport={{ once: true }}
                          className="card overflow-hidden"
                        >
                          <button
                            onClick={() => toggleItem(itemId)}
                            className="w-full px-6 py-4 text-left flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                          >
                            <span className="font-medium text-gray-900 dark:text-white">
                              {faq.question}
                            </span>
                            {openItems.includes(itemId) ? (
                              <ChevronUp className="h-5 w-5 text-gray-500 dark:text-gray-400 flex-shrink-0" />
                            ) : (
                              <ChevronDown className="h-5 w-5 text-gray-500 dark:text-gray-400 flex-shrink-0" />
                            )}
                          </button>
                          
                          {openItems.includes(itemId) && (
                            <motion.div
                              initial={{ height: 0, opacity: 0 }}
                              animate={{ height: 'auto', opacity: 1 }}
                              exit={{ height: 0, opacity: 0 }}
                              transition={{ duration: 0.3 }}
                              className="px-6 pb-4"
                            >
                              <p className="text-gray-600 dark:text-gray-300">
                                {faq.answer}
                              </p>
                            </motion.div>
                          )}
                        </motion.div>
                      )
                    })}
                  </div>
                </div>
              ))}
            </div>
          )}
        </motion.div>
      </div>
    </section>
  )
}
