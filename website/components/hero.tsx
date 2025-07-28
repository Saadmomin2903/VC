"use client";

import { useState, useEffect } from "react";
import { Download, Play, ArrowRight, Clock, Shield, Zap } from "lucide-react";
import { motion } from "framer-motion";
import { SimpleDownloadButton } from "./download-button";
import { VideoModal } from "./video-modal";

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
  const [showVideoModal, setShowVideoModal] = useState(false);

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
                    Beta available for macOS
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
                    Augment automatically saves every version of your files in
                    organized "spaces", so you can focus on creating without
                    worrying about losing your work. Currently in beta for early
                    adopters.
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

                  <button
                    onClick={() => setShowVideoModal(true)}
                    className="btn-outline btn-lg group relative z-30"
                  >
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
                    Free beta download • No account required • macOS 11.0 or
                    later
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
                  {/* Main app window mockup with video preview */}
                  <button
                    onClick={() => setShowVideoModal(true)}
                    className="group relative w-full rounded-2xl bg-white p-1 shadow-2xl dark:bg-gray-800 hover:shadow-3xl transition-all duration-300 hover:scale-105"
                  >
                    <div className="rounded-xl bg-gray-50 p-6 dark:bg-gray-900 relative overflow-hidden">
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

                      {/* Play Button Overlay */}
                      <div className="absolute inset-0 flex items-center justify-center bg-black/0 group-hover:bg-black/10 transition-all duration-300 rounded-xl">
                        <div className="bg-white/90 backdrop-blur-sm rounded-full p-3 group-hover:bg-white group-hover:scale-110 transition-all duration-300 shadow-lg opacity-80 group-hover:opacity-100">
                          <svg
                            className="h-6 w-6 text-blue-600 ml-0.5"
                            fill="currentColor"
                            viewBox="0 0 20 20"
                          >
                            <path
                              fillRule="evenodd"
                              d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z"
                              clipRule="evenodd"
                            />
                          </svg>
                        </div>
                      </div>

                      {/* Video Label */}
                      <div className="absolute top-2 right-2 bg-blue-600/90 text-white text-xs px-2 py-1 rounded font-medium opacity-80 group-hover:opacity-100 transition-opacity">
                        Watch Demo
                      </div>
                    </div>
                  </button>

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

      {/* Video Preview Section */}
      <div className="relative -mt-20 pb-20">
        <div className="mx-auto max-w-7xl px-6 lg:px-8">
          <motion.div
            initial={{ opacity: 0, y: 50 }}
            animate={{
              opacity: isVisible ? 1 : 0,
              y: isVisible ? 0 : 50,
            }}
            transition={{ duration: 0.8, delay: 0.6 }}
            className="mx-auto max-w-4xl"
          >
            <div className="text-center mb-8">
              <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                See Augment in Action
              </h3>
              <p className="text-gray-600 dark:text-gray-300">
                Watch how Augment automatically protects your files in real-time
              </p>
            </div>

            <button
              onClick={() => setShowVideoModal(true)}
              className="group relative w-full aspect-video rounded-2xl overflow-hidden bg-gradient-to-br from-blue-600 to-purple-600 p-2 hover:scale-[1.02] transition-all duration-500 shadow-2xl hover:shadow-3xl"
            >
              {/* Video Thumbnail */}
              <div className="relative h-full w-full rounded-xl overflow-hidden bg-gradient-to-br from-gray-900 via-blue-900 to-purple-900">
                {/* Simulated Desktop Environment */}
                <div className="absolute inset-0 p-6">
                  {/* macOS Desktop Background */}
                  <div className="h-full w-full rounded-lg bg-gradient-to-br from-blue-500 to-purple-600 relative overflow-hidden">
                    {/* Desktop Icons */}
                    <div className="absolute top-4 left-4 space-y-4">
                      <div className="flex flex-col items-center space-y-1">
                        <div className="w-12 h-12 bg-white/20 rounded-lg flex items-center justify-center">
                          <svg
                            className="w-8 h-8 text-white"
                            fill="currentColor"
                            viewBox="0 0 20 20"
                          >
                            <path
                              fillRule="evenodd"
                              d="M4 4a2 2 0 012-2h8a2 2 0 012 2v12a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm2 0h8v12H6V4z"
                              clipRule="evenodd"
                            />
                          </svg>
                        </div>
                        <span className="text-white text-xs">
                          Document.docx
                        </span>
                      </div>
                    </div>

                    {/* Augment App Window */}
                    <div className="absolute bottom-6 right-6 w-64 h-40 bg-white/95 backdrop-blur-sm rounded-lg shadow-lg border border-white/20">
                      <div className="flex items-center justify-between p-2 border-b border-gray-200">
                        <div className="flex space-x-1">
                          <div className="w-2 h-2 rounded-full bg-red-400"></div>
                          <div className="w-2 h-2 rounded-full bg-yellow-400"></div>
                          <div className="w-2 h-2 rounded-full bg-green-400"></div>
                        </div>
                        <div className="text-gray-700 text-xs font-medium">
                          Augment
                        </div>
                        <div className="w-6"></div>
                      </div>
                      <div className="p-3 space-y-2">
                        <div className="flex items-center space-x-2">
                          <div className="w-6 h-6 rounded bg-blue-500/20"></div>
                          <div className="flex-1">
                            <div className="h-1.5 bg-gray-300 rounded w-full mb-1"></div>
                            <div className="h-1 bg-gray-200 rounded w-2/3"></div>
                          </div>
                        </div>
                        <div className="flex items-center space-x-2">
                          <div className="w-6 h-6 rounded bg-green-500/20"></div>
                          <div className="flex-1">
                            <div className="h-1.5 bg-gray-300 rounded w-4/5 mb-1"></div>
                            <div className="h-1 bg-gray-200 rounded w-1/2"></div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Large Play Button */}
                <div className="absolute inset-0 flex items-center justify-center bg-black/20 group-hover:bg-black/30 transition-all duration-300">
                  <div className="bg-white/95 backdrop-blur-sm rounded-full p-6 group-hover:bg-white group-hover:scale-110 transition-all duration-300 shadow-2xl">
                    <svg
                      className="h-12 w-12 text-blue-600 ml-1"
                      fill="currentColor"
                      viewBox="0 0 20 20"
                    >
                      <path
                        fillRule="evenodd"
                        d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z"
                        clipRule="evenodd"
                      />
                    </svg>
                  </div>
                </div>

                {/* Video Info Badges */}
                <div className="absolute bottom-4 left-4 flex space-x-2">
                  <div className="bg-black/70 text-white text-sm px-3 py-1 rounded-full font-medium">
                    Demo Video
                  </div>
                  <div className="bg-black/70 text-white text-sm px-3 py-1 rounded-full">
                    2:30
                  </div>
                </div>

                <div className="absolute top-4 right-4 bg-green-500/90 text-white text-xs px-2 py-1 rounded-full font-medium">
                  ● LIVE
                </div>
              </div>
            </button>
          </motion.div>
        </div>
      </div>

      <VideoModal
        isOpen={showVideoModal}
        onClose={() => setShowVideoModal(false)}
        videoUrl="https://8qsgkc8xxtebfxp0.public.blob.vercel-storage.com/clideo_editor_b3335a34428e4ba8baabce102107257d.mp4"
        title="Augment Demo Video"
      />
    </section>
  );
}
