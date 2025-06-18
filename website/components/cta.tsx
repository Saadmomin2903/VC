"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { Download, ArrowRight, Shield, Clock, Zap } from "lucide-react";

export function CTA() {
  return (
    <section className="section bg-gradient-to-br from-blue-600 via-purple-600 to-blue-800 text-white">
      <div className="container">
        <div className="mx-auto max-w-4xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl font-bold tracking-tight sm:text-4xl lg:text-5xl">
              Ready to never lose work again?
            </h2>
            <p className="mt-6 text-xl text-blue-100">
              Join thousands of professionals who trust Augment to protect their
              most important files. Download now and get instant peace of mind.
            </p>
          </motion.div>

          {/* Features highlight */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            viewport={{ once: true }}
            className="mt-8 flex flex-wrap justify-center gap-6"
          >
            <div className="flex items-center space-x-2 text-blue-100">
              <Shield className="h-5 w-5" />
              <span>100% Private & Secure</span>
            </div>
            <div className="flex items-center space-x-2 text-blue-100">
              <Clock className="h-5 w-5" />
              <span>Real-time Protection</span>
            </div>
            <div className="flex items-center space-x-2 text-blue-100">
              <Zap className="h-5 w-5" />
              <span>Zero Configuration</span>
            </div>
          </motion.div>

          {/* CTA Buttons */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.4 }}
            viewport={{ once: true }}
            className="mt-10 flex flex-col space-y-4 sm:flex-row sm:justify-center sm:space-x-4 sm:space-y-0"
          >
            <Link
              href="/download"
              className="inline-flex items-center justify-center rounded-lg bg-white px-8 py-4 text-lg font-semibold text-blue-600 transition-all duration-200 hover:bg-blue-50 hover:scale-105 focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-blue-600 group shadow-xl hover:shadow-2xl"
            >
              <Download className="mr-2 h-5 w-5" />
              Download for macOS
              <ArrowRight className="ml-2 h-4 w-4 transition-transform group-hover:translate-x-1" />
            </Link>

            <Link
              href="/documentation"
              className="inline-flex items-center justify-center rounded-lg border-2 border-white/20 px-8 py-4 text-lg font-semibold text-white transition-all duration-200 hover:bg-white/10 hover:border-white/40 focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-blue-600"
            >
              Learn More
            </Link>
          </motion.div>

          {/* Trust indicators */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.6 }}
            viewport={{ once: true }}
            className="mt-12"
          >
            <div className="grid gap-8 sm:grid-cols-3">
              <div className="text-center">
                <div className="text-2xl font-bold">Free</div>
                <div className="text-sm text-blue-100">
                  No subscription required
                </div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold">macOS 11+</div>
                <div className="text-sm text-blue-100">
                  Compatible with all modern Macs
                </div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold">5 min</div>
                <div className="text-sm text-blue-100">Setup time</div>
              </div>
            </div>
          </motion.div>

          {/* Additional info */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.8 }}
            viewport={{ once: true }}
            className="mt-12 text-center"
          >
            <p className="text-blue-100">
              No credit card required • No account signup • Start protecting
              your files in minutes
            </p>
          </motion.div>
        </div>
      </div>

      {/* Background decoration */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-32 h-80 w-80 rounded-full bg-white/10 blur-3xl"></div>
        <div className="absolute -bottom-40 -left-32 h-80 w-80 rounded-full bg-white/10 blur-3xl"></div>
      </div>
    </section>
  );
}
