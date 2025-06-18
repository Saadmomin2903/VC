'use client'

import { motion } from 'framer-motion'
import { useState } from 'react'
import { ChevronDown, ChevronUp } from 'lucide-react'

const faqs = [
  {
    question: 'Is Augment really free?',
    answer: 'Yes, Augment is completely free to download and use. There are no subscription fees, no premium tiers, and no hidden costs. We believe file protection should be accessible to everyone.',
    category: 'pricing'
  },
  {
    question: 'What macOS versions are supported?',
    answer: 'Augment requires macOS 11.0 (Big Sur) or later. It works on both Intel and Apple Silicon Macs, including M1, M2, and newer processors.',
    category: 'compatibility'
  },
  {
    question: 'How much storage space does Augment use?',
    answer: 'The app itself is only 15.2 MB. Version storage depends on your usage, but Augment uses smart deduplication to minimize space usage. You can configure storage limits in preferences.',
    category: 'storage'
  },
  {
    question: 'Is my data safe and private?',
    answer: 'Absolutely. All your files and versions stay on your Mac. Augment never uploads your data to the cloud or external servers. Your privacy is completely protected.',
    category: 'privacy'
  },
  {
    question: 'Can I uninstall Augment easily?',
    answer: 'Yes, simply drag Augment from Applications to Trash. Your version data is stored separately and can be removed from preferences if desired.',
    category: 'installation'
  },
  {
    question: 'Does Augment slow down my Mac?',
    answer: 'No, Augment is designed to be lightweight and efficient. It uses minimal CPU and memory, running quietly in the background without affecting your Mac\'s performance.',
    category: 'performance'
  },
  {
    question: 'What file types does Augment support?',
    answer: 'Augment works with all file types - documents, images, videos, code files, and more. It monitors any file you save within your configured spaces.',
    category: 'compatibility'
  },
  {
    question: 'Can I use Augment with cloud storage services?',
    answer: 'Yes, Augment works alongside Dropbox, iCloud, Google Drive, and other cloud services. It provides an additional layer of local protection for your files.',
    category: 'compatibility'
  }
]

export function FAQ() {
  const [openItems, setOpenItems] = useState<number[]>([])

  const toggleItem = (index: number) => {
    setOpenItems(prev => 
      prev.includes(index) 
        ? prev.filter(i => i !== index)
        : [...prev, index]
    )
  }

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
              Frequently asked questions
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Get answers to common questions about downloading and using Augment.
            </p>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          viewport={{ once: true }}
          className="mt-16 mx-auto max-w-3xl"
        >
          <div className="space-y-4">
            {faqs.map((faq, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 10 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.4, delay: index * 0.05 }}
                viewport={{ once: true }}
                className="card overflow-hidden"
              >
                <button
                  onClick={() => toggleItem(index)}
                  className="w-full px-6 py-4 text-left flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
                >
                  <span className="font-medium text-gray-900 dark:text-white">
                    {faq.question}
                  </span>
                  {openItems.includes(index) ? (
                    <ChevronUp className="h-5 w-5 text-gray-500 dark:text-gray-400 flex-shrink-0" />
                  ) : (
                    <ChevronDown className="h-5 w-5 text-gray-500 dark:text-gray-400 flex-shrink-0" />
                  )}
                </button>
                
                {openItems.includes(index) && (
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
            ))}
          </div>
        </motion.div>

        {/* Additional help */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-blue-50 p-8 text-center dark:bg-blue-900/10">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
              Still have questions?
            </h3>
            <p className="mt-2 text-gray-600 dark:text-gray-300">
              Our comprehensive documentation and support team are here to help.
            </p>
            <div className="mt-6 flex flex-col space-y-3 sm:flex-row sm:justify-center sm:space-x-3 sm:space-y-0">
              <a
                href="/documentation"
                className="btn-outline"
              >
                Browse Documentation
              </a>
              <a
                href="/support"
                className="btn-primary"
              >
                Contact Support
              </a>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
