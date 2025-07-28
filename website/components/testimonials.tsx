"use client";

import { motion } from "framer-motion";
import { Star, Quote } from "lucide-react";

const testimonials = [
  {
    name: "Alex M.",
    role: "Beta Tester",
    company: "Early Adopter",
    content:
      "The core versioning functionality works well. I like how it creates spaces for different projects. Still in beta but shows promise for file management.",
    rating: 4,
    avatar:
      "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=64&h=64&fit=crop&crop=face",
  },
  {
    name: "Jordan K.",
    role: "Developer",
    company: "Beta Program",
    content:
      "Interesting approach to file versioning outside of Git. The automatic monitoring is useful for documents and design files. Looking forward to future updates.",
    rating: 4,
    avatar:
      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=64&h=64&fit=crop&crop=face",
  },
  {
    name: "Sam T.",
    role: "Content Creator",
    company: "Beta Tester",
    content:
      "Good concept for protecting creative work. The version history feature is helpful. As a beta, it has room for improvement but the foundation is solid.",
    rating: 4,
    avatar:
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=64&h=64&fit=crop&crop=face",
  },
  {
    name: "Casey R.",
    role: "Designer",
    company: "Beta Tester",
    content:
      "The version comparison feature is useful for tracking changes in my design files. Still learning the interface but the core functionality works as expected.",
    rating: 4,
    avatar:
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=64&h=64&fit=crop&crop=face",
  },
  {
    name: "Taylor L.",
    role: "Project Manager",
    company: "Beta Program",
    content:
      "Helpful for keeping track of document versions in our team. The space concept is interesting. Looking forward to seeing how it develops.",
    rating: 4,
    avatar:
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=64&h=64&fit=crop&crop=face",
  },
  {
    name: "Morgan P.",
    role: "Content Producer",
    company: "Early Adopter",
    content:
      "Good for backing up creative work. The automatic versioning saves me from manually copying files. Beta software but stable enough for testing.",
    rating: 4,
    avatar:
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=64&h=64&fit=crop&crop=face",
  },
];

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
              Early feedback from{" "}
              <span className="gradient-text">beta testers</span>
            </h2>
            <p className="mt-4 text-lg text-gray-600 dark:text-gray-300">
              See what early adopters say about their experience with Augment's
              beta version.
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
          <div className="inline-flex items-center space-x-2 rounded-full bg-blue-100 px-4 py-2 text-blue-800 dark:bg-blue-900/20 dark:text-blue-400">
            <Star className="h-4 w-4 fill-current" />
            <span className="text-sm font-medium">
              Early beta feedback from testers
            </span>
          </div>
        </motion.div>
      </div>
    </section>
  );
}
