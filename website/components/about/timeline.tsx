'use client'

import { motion } from 'framer-motion'
import { Calendar, Lightbulb, Code, Users, Rocket, Star } from 'lucide-react'

const timelineEvents = [
  {
    date: '2021',
    title: 'The Problem Identified',
    description: 'After losing weeks of work to a system crash, our founder realized there had to be a better way to protect creative work.',
    icon: Lightbulb,
    type: 'milestone'
  },
  {
    date: 'Early 2022',
    title: 'Development Begins',
    description: 'Started building the first prototype of intelligent file versioning for macOS, focusing on automatic, invisible protection.',
    icon: Code,
    type: 'development'
  },
  {
    date: 'Mid 2022',
    title: 'Core Technology',
    description: 'Developed the core versioning engine with smart deduplication and efficient storage management.',
    icon: Star,
    type: 'milestone'
  },
  {
    date: 'Late 2022',
    title: 'Beta Testing',
    description: 'Launched private beta with select users, gathering feedback and refining the user experience.',
    icon: Users,
    type: 'milestone'
  },
  {
    date: 'Early 2023',
    title: 'Advanced Features',
    description: 'Added powerful search, version comparison, and intelligent error recovery systems.',
    icon: Star,
    type: 'development'
  },
  {
    date: 'Mid 2023',
    title: 'Public Beta',
    description: 'Opened beta to the public, onboarding thousands of users and gathering valuable feedback.',
    icon: Users,
    type: 'milestone'
  },
  {
    date: '2024',
    title: 'Version 1.0 Launch',
    description: 'Official launch of Augment with comprehensive onboarding, help system, and error recovery.',
    icon: Rocket,
    type: 'launch'
  }
]

export function Timeline() {
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
              Our journey
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              From a frustrating problem to a comprehensive solution - the story of how Augment came to be.
            </p>
          </motion.div>
        </div>

        <div className="mt-16">
          <div className="relative">
            {/* Timeline line */}
            <div className="absolute left-8 top-0 bottom-0 w-0.5 bg-gradient-to-b from-primary to-purple-600 hidden lg:block"></div>
            
            <div className="space-y-12">
              {timelineEvents.map((event, index) => {
                const Icon = event.icon
                const isEven = index % 2 === 0
                
                return (
                  <motion.div
                    key={event.date}
                    initial={{ opacity: 0, x: isEven ? -20 : 20 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    transition={{ duration: 0.6, delay: index * 0.1 }}
                    viewport={{ once: true }}
                    className="relative"
                  >
                    <div className={`flex items-center ${isEven ? 'lg:flex-row' : 'lg:flex-row-reverse'}`}>
                      {/* Timeline marker */}
                      <div className="flex flex-col items-center lg:absolute lg:left-6">
                        <div className={`flex h-12 w-12 items-center justify-center rounded-full shadow-lg ${
                          event.type === 'launch' 
                            ? 'bg-gradient-to-r from-primary to-purple-600 text-white'
                            : event.type === 'milestone'
                            ? 'bg-primary text-white'
                            : 'bg-white border-2 border-primary text-primary dark:bg-gray-900'
                        }`}>
                          <Icon className="h-6 w-6" />
                        </div>
                        <div className="mt-2 text-sm font-medium text-gray-500 dark:text-gray-400">
                          {event.date}
                        </div>
                      </div>

                      {/* Content */}
                      <div className={`flex-1 ${isEven ? 'lg:pl-20' : 'lg:pr-20'} mt-8 lg:mt-0`}>
                        <div className={`card p-6 ${isEven ? 'lg:ml-8' : 'lg:mr-8'}`}>
                          <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                            {event.title}
                          </h3>
                          <p className="mt-2 text-gray-600 dark:text-gray-300">
                            {event.description}
                          </p>
                        </div>
                      </div>
                    </div>
                  </motion.div>
                )
              })}
            </div>
          </div>
        </div>

        {/* Future section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-blue-600 to-purple-600 p-8 text-white text-center">
            <Calendar className="mx-auto h-12 w-12 mb-4" />
            <h3 className="text-2xl font-bold">
              The future is bright
            </h3>
            <p className="mt-4 text-blue-100 max-w-2xl mx-auto">
              We're just getting started. Our roadmap includes advanced AI-powered features, 
              team collaboration tools, and expanded platform support - all while maintaining 
              our commitment to privacy and simplicity.
            </p>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
