'use client'

import { motion } from 'framer-motion'
import { Monitor, Cpu, HardDrive, Wifi, Check, X } from 'lucide-react'

const requirements = {
  minimum: [
    { label: 'Operating System', value: 'macOS 11.0 (Big Sur) or later' },
    { label: 'Processor', value: 'Intel Core i5 or Apple M1' },
    { label: 'Memory', value: '4 GB RAM' },
    { label: 'Storage', value: '100 MB available space' },
    { label: 'Network', value: 'Internet connection for initial setup' }
  ],
  recommended: [
    { label: 'Operating System', value: 'macOS 13.0 (Ventura) or later' },
    { label: 'Processor', value: 'Apple M1 Pro/Max/Ultra or Intel Core i7' },
    { label: 'Memory', value: '8 GB RAM or more' },
    { label: 'Storage', value: '1 GB+ available space for versions' },
    { label: 'Network', value: 'Broadband internet connection' }
  ]
}

const compatibility = [
  { device: 'MacBook Air (M1, M2)', supported: true },
  { device: 'MacBook Pro (M1, M2)', supported: true },
  { device: 'iMac (M1)', supported: true },
  { device: 'Mac Studio (M1, M2)', supported: true },
  { device: 'Mac Pro (Intel)', supported: true },
  { device: 'MacBook Pro (Intel)', supported: true },
  { device: 'iMac (Intel)', supported: true },
  { device: 'Mac mini (Intel, M1, M2)', supported: true },
  { device: 'macOS 10.15 or earlier', supported: false }
]

export function SystemRequirements() {
  return (
    <section id="requirements" className="section bg-gray-50 dark:bg-gray-800">
      <div className="container">
        <div className="mx-auto max-w-3xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl">
              System Requirements
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Augment is optimized for modern Macs and works great on both Intel and Apple Silicon processors.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 lg:grid-cols-2">
          {/* Minimum Requirements */}
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            viewport={{ once: true }}
          >
            <div className="card p-6">
              <div className="mb-6 flex items-center space-x-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-100 dark:bg-blue-900/20">
                  <Monitor className="h-5 w-5 text-blue-600 dark:text-blue-400" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                  Minimum Requirements
                </h3>
              </div>
              
              <div className="space-y-4">
                {requirements.minimum.map((req, index) => (
                  <div key={index} className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">{req.label}</span>
                    <span className="font-medium text-gray-900 dark:text-white text-right">
                      {req.value}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </motion.div>

          {/* Recommended Requirements */}
          <motion.div
            initial={{ opacity: 0, x: 20 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, delay: 0.4 }}
            viewport={{ once: true }}
          >
            <div className="card p-6">
              <div className="mb-6 flex items-center space-x-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-green-100 dark:bg-green-900/20">
                  <Cpu className="h-5 w-5 text-green-600 dark:text-green-400" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                  Recommended
                </h3>
              </div>
              
              <div className="space-y-4">
                {requirements.recommended.map((req, index) => (
                  <div key={index} className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">{req.label}</span>
                    <span className="font-medium text-gray-900 dark:text-white text-right">
                      {req.value}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </motion.div>
        </div>

        {/* Device Compatibility */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="card p-6">
            <div className="mb-6 text-center">
              <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                Device Compatibility
              </h3>
              <p className="mt-2 text-gray-600 dark:text-gray-300">
                Check if your Mac is compatible with Augment
              </p>
            </div>
            
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {compatibility.map((item, index) => (
                <div
                  key={index}
                  className={`flex items-center justify-between rounded-lg p-3 ${
                    item.supported
                      ? 'bg-green-50 dark:bg-green-900/10'
                      : 'bg-red-50 dark:bg-red-900/10'
                  }`}
                >
                  <span className="text-sm font-medium text-gray-900 dark:text-white">
                    {item.device}
                  </span>
                  {item.supported ? (
                    <Check className="h-4 w-4 text-green-600 dark:text-green-400" />
                  ) : (
                    <X className="h-4 w-4 text-red-600 dark:text-red-400" />
                  )}
                </div>
              ))}
            </div>
          </div>
        </motion.div>

        {/* Additional Notes */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.8 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-blue-50 p-8 dark:bg-blue-900/10">
            <div className="flex items-start space-x-4">
              <div className="flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 dark:bg-blue-900/20">
                <HardDrive className="h-4 w-4 text-blue-600 dark:text-blue-400" />
              </div>
              <div>
                <h4 className="font-semibold text-gray-900 dark:text-white">
                  Storage Considerations
                </h4>
                <p className="mt-2 text-gray-600 dark:text-gray-300">
                  Augment stores file versions locally on your Mac. The amount of storage needed 
                  depends on how many files you're versioning and how frequently they change. 
                  We recommend having at least 10% of your working files' size available for versions.
                </p>
                <div className="mt-4 text-sm text-gray-500 dark:text-gray-400">
                  <strong>Example:</strong> If you're versioning 1GB of documents, 
                  reserve ~100MB for version storage.
                </div>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
