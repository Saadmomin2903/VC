'use client'

import { motion } from 'framer-motion'
import { Star, Quote } from 'lucide-react'

const testimonials = [
  {
    name: 'Sarah Chen',
    role: 'Graphic Designer',
    company: 'Creative Studio',
    content: 'Augment saved my career. I accidentally deleted a client project and was able to recover everything instantly. The automatic versioning is a lifesaver.',
    rating: 5,
    avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=64&h=64&fit=crop&crop=face'
  },
  {
    name: 'Michael Rodriguez',
    role: 'Software Developer',
    company: 'Tech Startup',
    content: 'As a developer, I thought I had version control covered with Git. But Augment protects all my other files too - docs, designs, everything. It\'s seamless.',
    rating: 5,
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=64&h=64&fit=crop&crop=face'
  },
  {
    name: 'Emily Watson',
    role: 'Writer & Author',
    company: 'Freelance',
    content: 'I\'ve lost manuscripts before to computer crashes. With Augment, I never worry about losing my work again. It just works in the background.',
    rating: 5,
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=64&h=64&fit=crop&crop=face'
  },
  {
    name: 'David Kim',
    role: 'Architect',
    company: 'Design Firm',
    content: 'The version comparison feature is incredible. I can see exactly what changed between iterations of my CAD files. Augment is essential for my workflow.',
    rating: 5,
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=64&h=64&fit=crop&crop=face'
  },
  {
    name: 'Lisa Thompson',
    role: 'Marketing Manager',
    company: 'Fortune 500',
    content: 'Our team collaborates on many documents. Augment helps us track changes and recover from mistakes. It\'s like having a time machine for our files.',
    rating: 5,
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=64&h=64&fit=crop&crop=face'
  },
  {
    name: 'James Wilson',
    role: 'Video Editor',
    company: 'Media Production',
    content: 'Working with large video files, I need reliable backup. Augment\'s smart storage management keeps my versions organized without eating up disk space.',
    rating: 5,
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=64&h=64&fit=crop&crop=face'
  }
]

export function Testimonials() {
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
              Loved by{' '}
              <span className="gradient-text">professionals worldwide</span>
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              See what our users say about how Augment has transformed their workflow and peace of mind.
            </p>
          </motion.div>
        </div>

        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {testimonials.map((testimonial, index) => (
            <motion.div
              key={testimonial.name}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              viewport={{ once: true }}
              className="group"
            >
              <div className="card p-6 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                {/* Quote icon */}
                <div className="mb-4">
                  <Quote className="h-8 w-8 text-primary/20" />
                </div>

                {/* Rating */}
                <div className="mb-4 flex space-x-1">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star
                      key={i}
                      className="h-4 w-4 fill-yellow-400 text-yellow-400"
                    />
                  ))}
                </div>

                {/* Content */}
                <blockquote className="mb-6 text-gray-600 dark:text-gray-300">
                  "{testimonial.content}"
                </blockquote>

                {/* Author */}
                <div className="flex items-center space-x-3">
                  <img
                    src={testimonial.avatar}
                    alt={testimonial.name}
                    className="h-10 w-10 rounded-full object-cover"
                  />
                  <div>
                    <div className="font-semibold text-gray-900 dark:text-white">
                      {testimonial.name}
                    </div>
                    <div className="text-sm text-gray-500 dark:text-gray-400">
                      {testimonial.role} at {testimonial.company}
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Trust indicators */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          viewport={{ once: true }}
          className="mt-16 text-center"
        >
          <div className="inline-flex items-center space-x-2 rounded-full bg-green-100 px-4 py-2 text-green-800 dark:bg-green-900/20 dark:text-green-400">
            <Star className="h-4 w-4 fill-current" />
            <span className="text-sm font-medium">
              4.9/5 average rating from 1,000+ reviews
            </span>
          </div>
        </motion.div>
      </div>
    </section>
  )
}
