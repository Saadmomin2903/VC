'use client'

import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { CheckCircle, Download, ExternalLink, FileText, Shield, Clock } from 'lucide-react'
import Link from 'next/link'

interface DownloadConfirmationProps {
  isVisible: boolean
  onClose: () => void
  downloadInfo?: {
    filename: string
    version: string
    size: string
    checksum: string
  }
}

export function DownloadConfirmation({ 
  isVisible, 
  onClose, 
  downloadInfo = {
    filename: 'Augment-v1.0.0-macOS.dmg',
    version: '1.0.0',
    size: '15.2 MB',
    checksum: 'sha256:a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456'
  }
}: DownloadConfirmationProps) {
  const [countdown, setCountdown] = useState(5)

  useEffect(() => {
    if (isVisible && countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000)
      return () => clearTimeout(timer)
    } else if (countdown === 0) {
      onClose()
    }
  }, [isVisible, countdown, onClose])

  useEffect(() => {
    if (isVisible) {
      setCountdown(5)
    }
  }, [isVisible])

  return (
    <AnimatePresence>
      {isVisible && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm"
          onClick={onClose}
        >
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.9, y: 20 }}
            className="mx-4 w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl dark:bg-gray-800"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Success Icon */}
            <div className="mb-4 flex justify-center">
              <div className="flex h-16 w-16 items-center justify-center rounded-full bg-green-100 dark:bg-green-900/20">
                <CheckCircle className="h-8 w-8 text-green-600 dark:text-green-400" />
              </div>
            </div>

            {/* Title */}
            <h3 className="mb-2 text-center text-xl font-semibold text-gray-900 dark:text-white">
              Download Started!
            </h3>
            
            <p className="mb-6 text-center text-gray-600 dark:text-gray-300">
              Your download should begin automatically. If it doesn't start, check your browser's download settings.
            </p>

            {/* Download Info */}
            <div className="mb-6 rounded-lg bg-gray-50 p-4 dark:bg-gray-700">
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-gray-600 dark:text-gray-400">File:</span>
                  <span className="font-medium text-gray-900 dark:text-white">{downloadInfo.filename}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600 dark:text-gray-400">Version:</span>
                  <span className="font-medium text-gray-900 dark:text-white">{downloadInfo.version}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600 dark:text-gray-400">Size:</span>
                  <span className="font-medium text-gray-900 dark:text-white">{downloadInfo.size}</span>
                </div>
              </div>
            </div>

            {/* Next Steps */}
            <div className="mb-6">
              <h4 className="mb-3 font-semibold text-gray-900 dark:text-white">Next Steps:</h4>
              <div className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <div className="flex items-start space-x-2">
                  <span className="mt-1 flex h-4 w-4 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold">1</span>
                  <span>Locate the downloaded file in your Downloads folder</span>
                </div>
                <div className="flex items-start space-x-2">
                  <span className="mt-1 flex h-4 w-4 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold">2</span>
                  <span>Double-click to mount the disk image</span>
                </div>
                <div className="flex items-start space-x-2">
                  <span className="mt-1 flex h-4 w-4 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold">3</span>
                  <span>Drag Augment to your Applications folder</span>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="space-y-3">
              <Link
                href="/documentation/installation"
                className="btn-primary w-full justify-center"
              >
                <FileText className="mr-2 h-4 w-4" />
                View Installation Guide
              </Link>
              
              <div className="grid grid-cols-2 gap-3">
                <button
                  onClick={() => {
                    navigator.clipboard.writeText(downloadInfo.checksum)
                  }}
                  className="btn-outline text-sm"
                >
                  <Shield className="mr-1 h-3 w-3" />
                  Copy Checksum
                </button>
                
                <Link
                  href="/support"
                  className="btn-outline text-sm"
                >
                  <ExternalLink className="mr-1 h-3 w-3" />
                  Get Help
                </Link>
              </div>
            </div>

            {/* Auto-close countdown */}
            <div className="mt-4 text-center text-xs text-gray-500 dark:text-gray-400">
              <Clock className="mr-1 inline h-3 w-3" />
              Auto-closing in {countdown} seconds
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
