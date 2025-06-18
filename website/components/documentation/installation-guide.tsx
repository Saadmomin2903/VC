'use client'

import { motion } from 'framer-motion'
import { Download, Shield, CheckCircle, AlertTriangle, Monitor, Cpu, HardDrive } from 'lucide-react'

const systemRequirements = [
  {
    icon: Monitor,
    title: 'Operating System',
    requirement: 'macOS 11.0 (Big Sur) or later',
    recommended: 'macOS 13.0 (Ventura) or later'
  },
  {
    icon: Cpu,
    title: 'Processor',
    requirement: 'Intel Core i5 or Apple Silicon (M1/M2/M3)',
    recommended: 'Apple Silicon for best performance'
  },
  {
    icon: HardDrive,
    title: 'Storage',
    requirement: '50 MB for application + space for versions',
    recommended: '1 GB+ free space for optimal operation'
  }
]

const installationSteps = [
  {
    step: 1,
    title: 'Download Augment',
    description: 'Download the latest version of Augment from our website.',
    details: [
      'Visit the download page and click "Download Augment"',
      'The download will start automatically (15.2 MB)',
      'Save the file to your Downloads folder'
    ]
  },
  {
    step: 2,
    title: 'Open the Installer',
    description: 'Locate and open the downloaded installer file.',
    details: [
      'Open Finder and navigate to your Downloads folder',
      'Double-click on "Augment-v1.0.dmg"',
      'The installer window will open automatically'
    ]
  },
  {
    step: 3,
    title: 'Install Augment',
    description: 'Drag Augment to your Applications folder.',
    details: [
      'Drag the Augment icon to the Applications folder',
      'Wait for the copy process to complete',
      'You can now eject the installer disk image'
    ]
  },
  {
    step: 4,
    title: 'Launch Augment',
    description: 'Open Augment and complete the initial setup.',
    details: [
      'Open Applications folder and double-click Augment',
      'Click "Open" when macOS asks for confirmation',
      'Follow the welcome wizard to create your first space'
    ]
  }
]

export function InstallationGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Installation Guide
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Get Augment up and running on your Mac in just a few minutes.
        </p>
      </motion.div>

      {/* System Requirements */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          System Requirements
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Make sure your Mac meets these requirements before installing Augment.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {systemRequirements.map((req, index) => {
            const Icon = req.icon
            return (
              <div key={req.title} className="card p-6">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-4 w-4" />
                  </div>
                  <h3 className="font-semibold text-gray-900 dark:text-white">
                    {req.title}
                  </h3>
                </div>
                <div className="space-y-2">
                  <div>
                    <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Minimum:</span>
                    <p className="text-sm text-gray-600 dark:text-gray-400">{req.requirement}</p>
                  </div>
                  <div>
                    <span className="text-sm font-medium text-gray-700 dark:text-gray-300">Recommended:</span>
                    <p className="text-sm text-gray-600 dark:text-gray-400">{req.recommended}</p>
                  </div>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Installation Steps */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Installation Steps
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Follow these simple steps to install Augment on your Mac.
        </p>
        
        <div className="mt-8 space-y-8">
          {installationSteps.map((step, index) => (
            <div key={step.step} className="card p-6">
              <div className="flex items-start space-x-4">
                <div className="flex h-8 w-8 items-center justify-center rounded-full bg-primary text-white font-semibold text-sm">
                  {step.step}
                </div>
                <div className="flex-1">
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {step.title}
                  </h3>
                  <p className="mt-2 text-gray-600 dark:text-gray-300">
                    {step.description}
                  </p>
                  <ul className="mt-4 space-y-2">
                    {step.details.map((detail, detailIndex) => (
                      <li key={detailIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                        <CheckCircle className="h-4 w-4 text-green-500 mt-0.5 flex-shrink-0" />
                        <span>{detail}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Security Notice */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <div className="rounded-lg bg-blue-50 p-6 dark:bg-blue-900/10">
          <div className="flex items-start space-x-3">
            <Shield className="h-6 w-6 text-blue-600 dark:text-blue-400 mt-0.5" />
            <div>
              <h3 className="font-semibold text-blue-900 dark:text-blue-100">
                Security & Privacy
              </h3>
              <p className="mt-2 text-blue-800 dark:text-blue-200">
                Augment is notarized by Apple and contains no malware. All your data stays on your Mac - 
                we never upload or access your files. The app requires minimal permissions to function.
              </p>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Troubleshooting */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Installation Troubleshooting
        </h2>
        
        <div className="mt-8 space-y-6">
          <div className="card p-6">
            <div className="flex items-start space-x-3">
              <AlertTriangle className="h-5 w-5 text-yellow-500 mt-0.5" />
              <div>
                <h3 className="font-semibold text-gray-900 dark:text-white">
                  "Augment can't be opened because it's from an unidentified developer"
                </h3>
                <p className="mt-2 text-gray-600 dark:text-gray-300">
                  Right-click on Augment in Applications, select "Open", then click "Open" in the dialog. 
                  This only needs to be done once.
                </p>
              </div>
            </div>
          </div>
          
          <div className="card p-6">
            <div className="flex items-start space-x-3">
              <AlertTriangle className="h-5 w-5 text-yellow-500 mt-0.5" />
              <div>
                <h3 className="font-semibold text-gray-900 dark:text-white">
                  Installation fails or app won't launch
                </h3>
                <p className="mt-2 text-gray-600 dark:text-gray-300">
                  Make sure you have admin privileges and sufficient disk space. Try restarting your Mac 
                  and installing again. Contact support if the issue persists.
                </p>
              </div>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
