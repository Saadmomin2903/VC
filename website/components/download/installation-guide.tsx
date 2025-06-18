'use client'

import { motion } from 'framer-motion'
import { Download, FolderOpen, Play, Check, AlertCircle } from 'lucide-react'

const installationSteps = [
  {
    icon: Download,
    title: 'Download Augment',
    description: 'Click the download button above to get the latest version of Augment.',
    details: [
      'The download will start automatically',
      'File size is approximately 15.2 MB',
      'Download typically takes 30-60 seconds'
    ]
  },
  {
    icon: FolderOpen,
    title: 'Open the Installer',
    description: 'Locate the downloaded file in your Downloads folder and double-click to open.',
    details: [
      'Look for "Augment-1.0.0.dmg" in Downloads',
      'Double-click the DMG file to mount it',
      'A new window will open with the installer'
    ]
  },
  {
    icon: Play,
    title: 'Install Augment',
    description: 'Drag Augment to your Applications folder to complete the installation.',
    details: [
      'Drag the Augment icon to Applications',
      'Wait for the copy process to complete',
      'You can now eject the DMG file'
    ]
  },
  {
    icon: Check,
    title: 'Launch & Setup',
    description: 'Open Augment from Applications and follow the onboarding process.',
    details: [
      'Find Augment in your Applications folder',
      'Double-click to launch for the first time',
      'Follow the guided setup process'
    ]
  }
]

const troubleshooting = [
  {
    issue: 'Security Warning',
    solution: 'If you see a security warning, go to System Preferences > Security & Privacy and click "Open Anyway".',
    type: 'common'
  },
  {
    issue: 'Permission Denied',
    solution: 'Make sure you have administrator privileges and try installing again.',
    type: 'common'
  },
  {
    issue: 'App Won\'t Open',
    solution: 'Try right-clicking the app and selecting "Open" from the context menu.',
    type: 'common'
  },
  {
    issue: 'Corrupted Download',
    solution: 'Delete the downloaded file and try downloading again. Check your internet connection.',
    type: 'rare'
  }
]

export function InstallationGuide() {
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
              Installation guide
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Follow these simple steps to install Augment on your Mac. The entire process takes less than 5 minutes.
            </p>
          </motion.div>
        </div>

        {/* Installation steps */}
        <div className="mt-16">
          <div className="relative">
            {/* Connection line */}
            <div className="absolute left-8 top-16 bottom-16 w-0.5 bg-gradient-to-b from-primary to-purple-600 hidden lg:block"></div>
            
            <div className="space-y-12">
              {installationSteps.map((step, index) => {
                const Icon = step.icon
                return (
                  <motion.div
                    key={step.title}
                    initial={{ opacity: 0, x: -20 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.6, delay: index * 0.2 }}
                    viewport={{ once: true }}
                    className="relative"
                  >
                    <div className="flex items-start space-x-8">
                      {/* Step number and icon */}
                      <div className="flex flex-col items-center">
                        <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary text-white shadow-lg">
                          <Icon className="h-8 w-8" />
                        </div>
                        <div className="mt-2 flex h-8 w-8 items-center justify-center rounded-full bg-primary/10 text-sm font-bold text-primary">
                          {index + 1}
                        </div>
                      </div>

                      {/* Content */}
                      <div className="flex-1 pb-8">
                        <div className="card p-6">
                          <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                            {step.title}
                          </h3>
                          <p className="mt-2 text-gray-600 dark:text-gray-300">
                            {step.description}
                          </p>
                          
                          <ul className="mt-4 space-y-2">
                            {step.details.map((detail, detailIndex) => (
                              <li
                                key={detailIndex}
                                className="flex items-center space-x-2 text-sm text-gray-500 dark:text-gray-400"
                              >
                                <div className="h-1.5 w-1.5 rounded-full bg-primary"></div>
                                <span>{detail}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                    </div>
                  </motion.div>
                )
              })}
            </div>
          </div>
        </div>

        {/* Troubleshooting */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="card p-8">
            <div className="flex items-center space-x-3 mb-6">
              <AlertCircle className="h-6 w-6 text-orange-600 dark:text-orange-400" />
              <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                Troubleshooting
              </h3>
            </div>
            
            <div className="grid gap-6 sm:grid-cols-2">
              {troubleshooting.map((item, index) => (
                <div
                  key={index}
                  className="rounded-lg bg-gray-50 p-4 dark:bg-gray-800"
                >
                  <h4 className="font-medium text-gray-900 dark:text-white">
                    {item.issue}
                  </h4>
                  <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                    {item.solution}
                  </p>
                </div>
              ))}
            </div>

            <div className="mt-6 text-center">
              <p className="text-gray-600 dark:text-gray-300">
                Still having issues? 
                <a href="/support" className="ml-1 text-primary hover:text-primary/80">
                  Contact our support team
                </a>
              </p>
            </div>
          </div>
        </motion.div>

        {/* Next steps */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-green-600 to-blue-600 p-8 text-white text-center">
            <Check className="mx-auto h-12 w-12 mb-4" />
            <h3 className="text-2xl font-bold">
              You're all set!
            </h3>
            <p className="mt-4 text-green-100">
              Once installed, Augment will guide you through creating your first space 
              and start protecting your files automatically.
            </p>
            <div className="mt-6">
              <a
                href="/documentation/quick-start"
                className="inline-flex items-center rounded-lg bg-white px-6 py-3 text-green-600 font-semibold hover:bg-green-50 transition-colors"
              >
                View Quick Start Guide
              </a>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
