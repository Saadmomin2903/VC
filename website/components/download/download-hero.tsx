"use client";

import { motion } from "framer-motion";
import { Download, Shield, Zap, Check } from "lucide-react";
import { DownloadButton } from "@/components/download-button";

const features = [
  "Free forever - no subscription required",
  "Works on all modern Macs (Intel & Apple Silicon)",
  "No account signup or registration needed",
  "Start protecting files in under 5 minutes",
];

export function DownloadHero() {
  return (
    <section className="relative overflow-hidden bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-900 dark:to-gray-800 pt-20">
      {/* Background decoration */}
      <div className="absolute inset-0">
        <div className="absolute -top-40 -right-32 h-80 w-80 rounded-full bg-gradient-to-br from-blue-400 to-purple-600 opacity-20 blur-3xl"></div>
        <div className="absolute -bottom-40 -left-32 h-80 w-80 rounded-full bg-gradient-to-br from-purple-400 to-pink-600 opacity-20 blur-3xl"></div>
      </div>

      <div className="relative">
        <div className="container">
          <div className="py-24">
            <div className="mx-auto max-w-4xl text-center">
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6 }}
              >
                <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-5xl lg:text-6xl">
                  Download <span className="gradient-text">Augment</span> for
                  macOS
                </h1>
                <p className="mt-6 text-xl text-gray-600 dark:text-gray-300">
                  Get started with intelligent file versioning today. Free
                  download, no account required, and ready to protect your files
                  in minutes.
                </p>
              </motion.div>

              {/* Download button */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.2 }}
                className="mt-10"
              >
                <DownloadButton
                  type="augment-macos"
                  variant="primary"
                  size="lg"
                  showVersion={true}
                  showSize={true}
                  className="shadow-lg"
                >
                  Download Augment
                </DownloadButton>

                <p className="mt-4 text-sm text-gray-500 dark:text-gray-400">
                  Compatible with macOS 11.0 or later • Universal Binary (Intel
                  & Apple Silicon)
                </p>
              </motion.div>

              {/* Features list */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.4 }}
                className="mt-12"
              >
                <div className="grid gap-4 sm:grid-cols-2">
                  {features.map((feature, index) => (
                    <div
                      key={index}
                      className="flex items-center space-x-3 text-left"
                    >
                      <div className="flex h-6 w-6 items-center justify-center rounded-full bg-green-100 dark:bg-green-900/20">
                        <Check className="h-4 w-4 text-green-600 dark:text-green-400" />
                      </div>
                      <span className="text-gray-700 dark:text-gray-300">
                        {feature}
                      </span>
                    </div>
                  ))}
                </div>
              </motion.div>

              {/* Trust indicators */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.6 }}
                className="mt-12 flex flex-wrap justify-center gap-8 text-sm text-gray-500 dark:text-gray-400"
              >
                <div className="flex items-center space-x-2">
                  <Shield className="h-4 w-4" />
                  <span>Notarized by Apple</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Zap className="h-4 w-4" />
                  <span>Instant setup</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Check className="h-4 w-4" />
                  <span>Virus-free guarantee</span>
                </div>
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
