'use client'

import { motion } from 'framer-motion'
import { Github, Twitter, Linkedin, Mail } from 'lucide-react'

const teamMembers = [
  {
    name: 'Alex Chen',
    role: 'Founder & CEO',
    bio: 'Former Apple engineer with 10+ years in macOS development. Passionate about creating tools that empower creativity.',
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face',
    social: {
      twitter: 'https://twitter.com/alexchen',
      linkedin: 'https://linkedin.com/in/alexchen',
      github: 'https://github.com/alexchen'
    }
  },
  {
    name: 'Sarah Kim',
    role: 'Lead Designer',
    bio: 'Design leader focused on creating intuitive experiences. Believes great design should be invisible.',
    avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face',
    social: {
      twitter: 'https://twitter.com/sarahkim',
      linkedin: 'https://linkedin.com/in/sarahkim'
    }
  },
  {
    name: 'Marcus Johnson',
    role: 'Senior Engineer',
    bio: 'Full-stack engineer specializing in performance optimization and system architecture.',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face',
    social: {
      github: 'https://github.com/marcusj',
      linkedin: 'https://linkedin.com/in/marcusj'
    }
  },
  {
    name: 'Emily Rodriguez',
    role: 'Product Manager',
    bio: 'Product strategist with a background in user research and data analysis. Ensures we build what users actually need.',
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face',
    social: {
      twitter: 'https://twitter.com/emilyrodriguez',
      linkedin: 'https://linkedin.com/in/emilyrodriguez'
    }
  }
]

export function Team() {
  return (
    <section className="section bg-gray-50 dark:bg-gray-800">
      <div className="container">
        <div className="mx-auto max-w-3xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl">
              Meet our team
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              The passionate people behind Augment, dedicated to protecting your creative work.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {teamMembers.map((member, index) => (
            <motion.div
              key={member.name}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              viewport={{ once: true }}
              className="group"
            >
              <div className="card p-6 text-center transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                <div className="relative mx-auto mb-4 h-24 w-24">
                  <img
                    src={member.avatar}
                    alt={member.name}
                    className="h-24 w-24 rounded-full object-cover"
                  />
                  <div className="absolute inset-0 rounded-full bg-gradient-to-t from-black/20 to-transparent opacity-0 transition-opacity group-hover:opacity-100"></div>
                </div>
                
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                  {member.name}
                </h3>
                <p className="text-sm font-medium text-primary">
                  {member.role}
                </p>
                <p className="mt-2 text-sm text-gray-600 dark:text-gray-300">
                  {member.bio}
                </p>
                
                {/* Social links */}
                <div className="mt-4 flex justify-center space-x-3">
                  {member.social.twitter && (
                    <a
                      href={member.social.twitter}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-gray-400 hover:text-blue-500 transition-colors"
                    >
                      <Twitter className="h-4 w-4" />
                    </a>
                  )}
                  {member.social.linkedin && (
                    <a
                      href={member.social.linkedin}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-gray-400 hover:text-blue-600 transition-colors"
                    >
                      <Linkedin className="h-4 w-4" />
                    </a>
                  )}
                  {member.social.github && (
                    <a
                      href={member.social.github}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors"
                    >
                      <Github className="h-4 w-4" />
                    </a>
                  )}
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Join us section */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          viewport={{ once: true }}
          className="mt-16"
        >
          <div className="card p-8 text-center">
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
              Want to join our mission?
            </h3>
            <p className="mt-2 text-gray-600 dark:text-gray-300">
              We're always looking for talented people who share our passion for protecting creative work.
            </p>
            <div className="mt-6">
              <a
                href="mailto:careers@augment-app.com"
                className="inline-flex items-center btn-primary"
              >
                <Mail className="mr-2 h-4 w-4" />
                Get in touch
              </a>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
