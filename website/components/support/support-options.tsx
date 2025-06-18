'use client'

import { motion } from 'framer-motion'
import { Book, MessageCircle, Mail, Search, Clock, Users } from 'lucide-react'

const supportOptions = [
  {
    icon: Book,
    title: 'Documentation',
    description: 'Comprehensive guides, tutorials, and reference materials',
    features: [
      'Getting started guide',
      'Feature explanations',
      'Troubleshooting steps',
      'Best practices'
    ],
    cta: 'Browse Docs',
    href: '/documentation',
    responseTime: 'Instant',
    color: 'text-blue-600 dark:text-blue-400'
  },
  {
    icon: Search,
    title: 'Knowledge Base',
    description: 'Searchable articles covering common questions and issues',
    features: [
      'FAQ database',
      'Common solutions',
      'Error explanations',
      'How-to articles'
    ],
    cta: 'Search Articles',
    href: '/documentation/faq',
    responseTime: 'Instant',
    color: 'text-green-600 dark:text-green-400'
  },
  {
    icon: MessageCircle,
    title: 'Community Forum',
    description: 'Connect with other users and get help from the community',
    features: [
      'User discussions',
      'Tips and tricks',
      'Feature requests',
      'Community support'
    ],
    cta: 'Join Forum',
    href: 'https://community.augment-app.com',
    responseTime: '< 24 hours',
    color: 'text-purple-600 dark:text-purple-400'
  },
  {
    icon: Mail,
    title: 'Direct Support',
    description: 'Get personalized help directly from our support team',
    features: [
      'Technical assistance',
      'Bug reports',
      'Feature requests',
      'Account issues'
    ],
    cta: 'Contact Us',
    href: '#contact',
    responseTime: '< 2 hours',
    color: 'text-orange-600 dark:text-orange-400'
  }
]

const stats = [
  {
    icon: Clock,
    label: 'Average Response Time',
    value: '< 2 hours',
    description: 'We respond to most inquiries within 2 hours during business hours'
  },
  {
    icon: Users,
    label: 'Issues Resolved',
    value: '95%',
    description: 'Most issues are resolved on the first contact'
  },
  {
    icon: MessageCircle,
    label: 'Satisfaction Rate',
    value: '4.9/5',
    description: 'Based on user feedback and support ratings'
  }
]

export function SupportOptions() {
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
              Choose your support option
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Multiple ways to get help, from instant self-service to personalized support.
            </p>
          </motion.div>
        </div>

        {/* Support options */}
        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {supportOptions.map((option, index) => {
            const Icon = option.icon
            return (
              <motion.div
                key={option.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="group"
              >
                <div className="card p-6 h-full transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className="text-center">
                    <div className={`mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 ${option.color}`}>
                      <Icon className="h-6 w-6" />
                    </div>
                    
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                      {option.title}
                    </h3>
                    <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                      {option.description}
                    </p>
                    
                    <div className="mt-4 text-xs font-medium text-gray-500 dark:text-gray-400">
                      Response time: {option.responseTime}
                    </div>
                  </div>

                  <ul className="mt-6 space-y-2">
                    {option.features.map((feature, featureIndex) => (
                      <li
                        key={featureIndex}
                        className="flex items-center text-sm text-gray-600 dark:text-gray-300"
                      >
                        <div className="mr-2 h-1.5 w-1.5 rounded-full bg-primary"></div>
                        {feature}
                      </li>
                    ))}
                  </ul>

                  <div className="mt-6">
                    <a
                      href={option.href}
                      className="btn-outline w-full text-center"
                    >
                      {option.cta}
                    </a>
                  </div>
                </div>
              </motion.div>
            )
          })}
        </div>

        {/* Support stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gray-50 p-8 dark:bg-gray-800">
            <div className="text-center mb-8">
              <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                Our support commitment
              </h3>
              <p className="mt-2 text-gray-600 dark:text-gray-300">
                We're dedicated to providing excellent support to all our users.
              </p>
            </div>
            
            <div className="grid gap-8 sm:grid-cols-3">
              {stats.map((stat, index) => {
                const Icon = stat.icon
                return (
                  <div key={index} className="text-center">
                    <div className="mx-auto mb-3 flex h-10 w-10 items-center justify-center rounded-full bg-primary/10 text-primary">
                      <Icon className="h-5 w-5" />
                    </div>
                    <div className="text-2xl font-bold text-gray-900 dark:text-white">
                      {stat.value}
                    </div>
                    <div className="text-sm font-medium text-gray-700 dark:text-gray-300">
                      {stat.label}
                    </div>
                    <div className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                      {stat.description}
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
