"use client";

import { useState, useEffect } from "react";
import { Download, Play, ArrowRight, Clock, Shield, Zap } from "lucide-react";
import { motion } from "framer-motion";
import { SimpleDownloadButton } from "./download-button";

const features = [
  {
    icon: Clock,
    text: "Automatic versioning",
  },
  {
    icon: Shield,
    text: "Never lose work",
  },
  {
    icon: Zap,
    text: "Lightning fast",
  },
];

export function Hero() {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  return (
    <section className="relative overflow-hidden bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-900 dark:to-gray-800">
      {/* Background decoration */}
      <div className="absolute inset-0 -z-10 pointer-events-none">
        <div className="absolute -top-40 -right-32 h-80 w-80 rounded-full bg-gradient-to-br from-blue-400 to-purple-600 opacity-20 blur-3xl"></div>
        <div className="absolute -bottom-40 -left-32 h-80 w-80 rounded-full bg-gradient-to-br from-purple-400 to-pink-600 opacity-20 blur-3xl"></div>
      </div>

      <div className="relative">
        <div className="container">
          <div className="flex min-h-screen items-center">
            <div className="grid gap-12 lg:grid-cols-2 lg:gap-16">
              {/* Content */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: isVisible ? 1 : 0, y: isVisible ? 0 : 20 }}
                transition={{ duration: 0.6 }}
                className="flex flex-col justify-center space-y-8"
              >
                {/* Badge */}
                <motion.div
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{
                    opacity: isVisible ? 1 : 0,
                    scale: isVisible ? 1 : 0.9,
                  }}
                  transition={{ duration: 0.6, delay: 0.1 }}
                  className="inline-flex"
                >
                  <div className="inline-flex items-center rounded-full bg-primary/10 px-4 py-2 text-sm font-medium text-primary">
                    <Zap className="mr-2 h-4 w-4" />
                    Now available for macOS
                  </div>
                </motion.div>

                {/* Headline */}
                <div className="space-y-4">
                  <motion.h1
                    initial={{ opacity: 0, y: 20 }}
                    animate={{
                      opacity: isVisible ? 1 : 0,
                      y: isVisible ? 0 : 20,
                    }}
                    transition={{ duration: 0.6, delay: 0.2 }}
                    className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-5xl lg:text-6xl"
                  >
                    Never lose work <span className="gradient-text">again</span>
                  </motion.h1>

                  <motion.p
                    initial={{ opacity: 0, y: 20 }}
                    animate={{
                      opacity: isVisible ? 1 : 0,
                      y: isVisible ? 0 : 20,
                    }}
                    transition={{ duration: 0.6, delay: 0.3 }}
                    className="text-xl text-gray-600 dark:text-gray-300 sm:text-2xl"
                  >
                    Augment automatically saves every version of your files, so
                    you can focus on creating without worrying about losing your
                    work.
                  </motion.p>
                </div>

                {/* Features */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{
                    opacity: isVisible ? 1 : 0,
                    y: isVisible ? 0 : 20,
                  }}
                  transition={{ duration: 0.6, delay: 0.4 }}
                  className="flex flex-wrap gap-4"
                >
                  {features.map((feature, index) => {
                    const Icon = feature.icon;
                    return (
                      <div
                        key={index}
                        className="flex items-center space-x-2 rounded-lg bg-white/50 px-3 py-2 text-sm font-medium text-gray-700 backdrop-blur-sm dark:bg-gray-800/50 dark:text-gray-300"
                      >
                        <Icon className="h-4 w-4 text-primary" />
                        <span>{feature.text}</span>
                      </div>
                    );
                  })}
                </motion.div>

                {/* CTA Buttons */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{
                    opacity: isVisible ? 1 : 0,
                    y: isVisible ? 0 : 20,
                  }}
                  transition={{ duration: 0.6, delay: 0.5 }}
                  className="flex flex-col space-y-4 sm:flex-row sm:space-x-4 sm:space-y-0 relative z-20"
                  style={{ pointerEvents: "auto" }}
                >
                  <SimpleDownloadButton className="inline-flex items-center justify-center px-8 py-4 text-lg font-semibold text-white bg-gradient-to-r from-blue-600 via-blue-700 to-blue-800 rounded-lg shadow-xl hover:shadow-2xl hover:from-blue-700 hover:via-blue-800 hover:to-blue-900 transform hover:scale-110 transition-all duration-300 ring-2 ring-blue-500/20 hover:ring-blue-500/40 focus:outline-none focus:ring-4 focus:ring-blue-500/50 group cursor-pointer relative z-30">
                    <Download className="mr-3 h-6 w-6" />
                    Download for macOS
                    <ArrowRight className="ml-3 h-5 w-5 transition-transform group-hover:translate-x-2" />
                  </SimpleDownloadButton>

                  <button className="btn-outline btn-lg group relative z-30">
                    <Play className="mr-2 h-5 w-5" />
                    Watch Demo
                  </button>
                </motion.div>

                {/* Download info */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{
                    opacity: isVisible ? 1 : 0,
                    y: isVisible ? 0 : 20,
                  }}
                  transition={{ duration: 0.6, delay: 0.6 }}
                  className="text-sm text-gray-500 dark:text-gray-400"
                >
                  <p>
                    Free download • No account required • macOS 11.0 or later
                  </p>
                </motion.div>

                {/* Trust indicators */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{
                    opacity: isVisible ? 1 : 0,
                    y: isVisible ? 0 : 20,
                  }}
                  transition={{ duration: 0.6, delay: 0.6 }}
                  className="flex items-center space-x-6 text-sm text-gray-500 dark:text-gray-400"
                >
                  <div className="flex items-center space-x-1">
                    <Shield className="h-4 w-4" />
                    <span>100% Private</span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Clock className="h-4 w-4" />
                    <span>Real-time backup</span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Zap className="h-4 w-4" />
                    <span>Zero setup</span>
                  </div>
                </motion.div>
              </motion.div>

              {/* Hero Image/Demo */}
              <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{
                  opacity: isVisible ? 1 : 0,
                  scale: isVisible ? 1 : 0.9,
                }}
                transition={{ duration: 0.8, delay: 0.3 }}
                className="relative"
              >
                <div className="relative mx-auto max-w-lg">
                  {/* Main app window mockup */}
                  <div className="relative rounded-2xl bg-white p-1 shadow-2xl dark:bg-gray-800">
                    <div className="rounded-xl bg-gray-50 p-6 dark:bg-gray-900">
                      {/* Window controls */}
                      <div className="mb-4 flex items-center space-x-2">
                        <div className="h-3 w-3 rounded-full bg-red-400"></div>
                        <div className="h-3 w-3 rounded-full bg-yellow-400"></div>
                        <div className="h-3 w-3 rounded-full bg-green-400"></div>
                      </div>

                      {/* App content mockup */}
                      <div className="space-y-4">
                        <div className="flex items-center justify-between">
                          <h3 className="font-semibold text-gray-900 dark:text-white">
                            My Project.docx
                          </h3>
                          <span className="text-xs text-green-600 dark:text-green-400">
                            ● Auto-saved
                          </span>
                        </div>

                        <div className="space-y-2">
                          <div className="h-2 w-full rounded bg-gray-200 dark:bg-gray-700"></div>
                          <div className="h-2 w-4/5 rounded bg-gray-200 dark:bg-gray-700"></div>
                          <div className="h-2 w-3/4 rounded bg-gray-200 dark:bg-gray-700"></div>
                        </div>

                        <div className="rounded-lg bg-blue-50 p-3 dark:bg-blue-900/20">
                          <div className="flex items-center space-x-2 text-sm">
                            <Clock className="h-4 w-4 text-blue-600 dark:text-blue-400" />
                            <span className="text-blue-800 dark:text-blue-300">
                              Version saved 2 minutes ago
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Floating version indicators */}
                  <motion.div
                    initial={{ opacity: 0, x: 20 }}
                    animate={{
                      opacity: isVisible ? 1 : 0,
                      x: isVisible ? 0 : 20,
                    }}
                    transition={{ duration: 0.6, delay: 0.8 }}
                    className="absolute -right-4 top-1/4 rounded-lg bg-white p-3 shadow-lg dark:bg-gray-800"
                  >
                    <div className="text-xs font-medium text-gray-600 dark:text-gray-400">
                      5 versions saved
                    </div>
                  </motion.div>

                  <motion.div
                    initial={{ opacity: 0, x: -20 }}
                    animate={{
                      opacity: isVisible ? 1 : 0,
                      x: isVisible ? 0 : -20,
                    }}
                    transition={{ duration: 0.6, delay: 1 }}
                    className="absolute -left-4 bottom-1/4 rounded-lg bg-white p-3 shadow-lg dark:bg-gray-800"
                  >
                    <div className="text-xs font-medium text-gray-600 dark:text-gray-400">
                      Real-time sync
                    </div>
                  </motion.div>
                </div>
              </motion.div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
