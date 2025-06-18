'use client'

import { motion } from 'framer-motion'
import { MessageCircle, Github, Twitter, Youtube, ExternalLink, Users } from 'lucide-react'

const resources = [
  {
    icon: MessageCircle,
    title: 'Community Forum',
    description: 'Join discussions, share tips, and get help from other Augment users.',
    link: 'https://community.augment-app.com',
    linkText: 'Join Forum',
    stats: '2.5K+ members',
    color: 'text-blue-600 dark:text-blue-400'
  },
  {
    icon: Github,
    title: 'GitHub Repository',
    description: 'View source code, report issues, and contribute to Augment\'s development.',
    link: 'https://github.com/augment-app/augment',
    linkText: 'View on GitHub',
    stats: '500+ stars',
    color: 'text-gray-600 dark:text-gray-400'
  },
  {
    icon: Twitter,
    title: 'Twitter Updates',
    description: 'Follow us for the latest news, updates, and tips about Augment.',
    link: 'https://twitter.com/augment_app',
    linkText: 'Follow @augment_app',
    stats: '1.2K+ followers',
    color: 'text-blue-500 dark:text-blue-400'
  },
  {
    icon: Youtube,
    title: 'Video Tutorials',
    description: 'Watch step-by-step tutorials and feature demonstrations.',
    link: 'https://youtube.com/@augment-app',
    linkText: 'Watch Videos',
    stats: '50+ videos',
    color: 'text-red-600 dark:text-red-400'
  }
]

const communityGuidelines = [
  'Be respectful and helpful to other community members',
  'Search existing topics before posting new questions',
  'Provide clear details when reporting issues or asking for help',
  'Share your tips and tricks to help others',
  'Follow our code of conduct in all interactions'
]

export function CommunityResources() {
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
              Join our community
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              Connect with other Augment users, share experiences, and stay updated with the latest developments.
            </p>
          </motion.div>
        </div>

        {/* Community resources */}
        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {resources.map((resource, index) => {
            const Icon = resource.icon
            return (
              <motion.div
                key={resource.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="group"
              >
                <div className="card p-6 h-full transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                  <div className="text-center">
                    <div className={`mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 ${resource.color}`}>
                      <Icon className="h-6 w-6" />
                    </div>
                    
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                      {resource.title}
                    </h3>
                    <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                      {resource.description}
                    </p>
                    
                    <div className="mt-3 text-xs font-medium text-gray-500 dark:text-gray-400">
                      {resource.stats}
                    </div>
                  </div>

                  <div className="mt-6">
                    <a
                      href={resource.link}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="inline-flex items-center btn-outline w-full justify-center"
                    >
                      {resource.linkText}
                      <ExternalLink className="ml-2 h-3 w-3" />
                    </a>
                  </div>
                </div>
              </motion.div>
            )
          })}
        </div>

        {/* Community guidelines */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="card p-8">
            <div className="flex items-center space-x-3 mb-6">
              <Users className="h-6 w-6 text-primary" />
              <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                Community Guidelines
              </h3>
            </div>
            
            <p className="text-gray-600 dark:text-gray-300 mb-6">
              Our community is built on mutual respect and helpfulness. Please follow these guidelines 
              to ensure a positive experience for everyone.
            </p>
            
            <ul className="space-y-3">
              {communityGuidelines.map((guideline, index) => (
                <li
                  key={index}
                  className="flex items-start space-x-3 text-gray-600 dark:text-gray-300"
                >
                  <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-primary flex-shrink-0"></div>
                  <span>{guideline}</span>
                </li>
              ))}
            </ul>
          </div>
        </motion.div>

        {/* Call to action */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.6 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="rounded-2xl bg-gradient-to-r from-primary to-purple-600 p-8 text-white text-center">
            <MessageCircle className="mx-auto h-12 w-12 mb-4" />
            <h3 className="text-2xl font-bold">
              Ready to join the conversation?
            </h3>
            <p className="mt-4 text-blue-100">
              Connect with thousands of Augment users who are passionate about protecting their creative work.
            </p>
            <div className="mt-6">
              <a
                href="https://community.augment-app.com"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center rounded-lg bg-white px-6 py-3 text-primary font-semibold hover:bg-blue-50 transition-colors"
              >
                Join Community Forum
                <ExternalLink className="ml-2 h-4 w-4" />
              </a>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
