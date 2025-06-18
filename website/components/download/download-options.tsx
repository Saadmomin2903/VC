"use client";

import { motion } from "framer-motion";
import { Download, Shield, Zap, Check, ExternalLink } from "lucide-react";
import { DownloadButton } from "@/components/download-button";

const downloadOptions = [
  {
    name: "Direct Download",
    description: "Download directly from our servers",
    version: "1.0.0",
    size: "15.2 MB",
    checksum: "SHA256: a1b2c3d4...",
    recommended: true,
    features: [
      "Latest stable version",
      "Fastest download",
      "Automatic updates",
      "Full feature set",
    ],
  },
  {
    name: "GitHub Release",
    description: "Download from our GitHub repository",
    version: "1.0.0",
    size: "15.2 MB",
    checksum: "SHA256: a1b2c3d4...",
    recommended: false,
    features: [
      "Open source transparency",
      "Release notes included",
      "Community verified",
      "Multiple download mirrors",
    ],
  },
];

export function DownloadOptions() {
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
              Choose your download
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Multiple download options to suit your preferences and security
              requirements.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 lg:grid-cols-2">
          {downloadOptions.map((option, index) => (
            <motion.div
              key={option.name}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.2 }}
              viewport={{ once: true }}
              className="group relative"
            >
              <div
                className={`card p-8 transition-all duration-300 hover:shadow-lg hover:-translate-y-1 ${
                  option.recommended ? "ring-2 ring-primary" : ""
                }`}
              >
                {option.recommended && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                    <span className="inline-flex items-center rounded-full bg-primary px-3 py-1 text-xs font-medium text-white">
                      Recommended
                    </span>
                  </div>
                )}

                <div className="text-center">
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                    {option.name}
                  </h3>
                  <p className="mt-2 text-gray-600 dark:text-gray-300">
                    {option.description}
                  </p>

                  <div className="mt-6 space-y-2">
                    <div className="text-sm text-gray-500 dark:text-gray-400">
                      Version {option.version} • {option.size}
                    </div>
                    <div className="text-xs text-gray-400 dark:text-gray-500 font-mono">
                      {option.checksum}
                    </div>
                  </div>

                  <DownloadButton
                    type={
                      option.name === "Direct Download"
                        ? "augment-macos"
                        : "augment-github"
                    }
                    variant={option.recommended ? "primary" : "outline"}
                    size="md"
                    showVersion={false}
                    showSize={false}
                    className="w-full mt-6"
                  >
                    Download {option.name}
                  </DownloadButton>

                  {option.name === "GitHub Release" && (
                    <a
                      href="https://github.com/augment-app/augment"
                      target="_blank"
                      rel="noopener noreferrer"
                      className="mt-3 inline-flex items-center text-sm text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
                    >
                      View on GitHub
                      <ExternalLink className="ml-1 h-3 w-3" />
                    </a>
                  )}
                </div>

                <div className="mt-8">
                  <h4 className="text-sm font-semibold text-gray-900 dark:text-white mb-3">
                    What's included:
                  </h4>
                  <ul className="space-y-2">
                    {option.features.map((feature, featureIndex) => (
                      <li
                        key={featureIndex}
                        className="flex items-center text-sm text-gray-600 dark:text-gray-300"
                      >
                        <Check className="mr-2 h-4 w-4 text-green-600 dark:text-green-400 flex-shrink-0" />
                        {feature}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Security notice */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-blue-50 p-8 dark:bg-blue-900/10">
            <div className="flex items-start space-x-4">
              <div className="flex h-8 w-8 items-center justify-center rounded-full bg-blue-100 dark:bg-blue-900/20">
                <Shield className="h-4 w-4 text-blue-600 dark:text-blue-400" />
              </div>
              <div>
                <h4 className="font-semibold text-gray-900 dark:text-white">
                  Security & Verification
                </h4>
                <p className="mt-2 text-gray-600 dark:text-gray-300">
                  All downloads are code-signed and notarized by Apple for your
                  security. You can verify the integrity of your download using
                  the provided SHA256 checksum.
                </p>
                <div className="mt-4 flex flex-wrap gap-4 text-sm text-gray-500 dark:text-gray-400">
                  <div className="flex items-center space-x-1">
                    <Zap className="h-3 w-3" />
                    <span>Apple Notarized</span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Shield className="h-3 w-3" />
                    <span>Code Signed</span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Check className="h-3 w-3" />
                    <span>Virus Scanned</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
