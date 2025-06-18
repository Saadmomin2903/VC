'use client'

import { motion } from 'framer-motion'
import { Search, Filter, Calendar, FileText, Tag, Zap, Clock, HardDrive } from 'lucide-react'

const searchTypes = [
  {
    icon: Search,
    title: 'Text Search',
    description: 'Search within file names and content',
    examples: [
      'project report',
      'meeting notes',
      'budget 2024',
      'client presentation'
    ]
  },
  {
    icon: Filter,
    title: 'Advanced Filters',
    description: 'Combine multiple criteria for precise results',
    examples: [
      'type:pdf modified:today',
      'size:>10MB space:documents',
      'created:last-week author:john',
      'extension:docx versions:>5'
    ]
  },
  {
    icon: Calendar,
    title: 'Date-based Search',
    description: 'Find files by creation or modification dates',
    examples: [
      'modified:yesterday',
      'created:2024-01-15',
      'between:2024-01-01,2024-01-31',
      'older-than:30-days'
    ]
  }
]

const searchOperators = [
  {
    operator: 'AND',
    description: 'Both terms must be present',
    example: 'project AND report',
    usage: 'Default behavior when multiple terms are used'
  },
  {
    operator: 'OR',
    description: 'Either term can be present',
    example: 'invoice OR receipt',
    usage: 'Use when looking for files with alternative terms'
  },
  {
    operator: 'NOT',
    description: 'Exclude files containing the term',
    example: 'presentation NOT draft',
    usage: 'Filter out unwanted results'
  },
  {
    operator: '"quotes"',
    description: 'Search for exact phrase',
    example: '"quarterly report"',
    usage: 'When you need exact word order'
  },
  {
    operator: '*',
    description: 'Wildcard for partial matches',
    example: 'meet*',
    usage: 'Matches meeting, meetings, etc.'
  }
]

const filterCategories = [
  {
    category: 'File Properties',
    icon: FileText,
    filters: [
      { name: 'type:', description: 'File type (pdf, docx, jpg, etc.)', example: 'type:pdf' },
      { name: 'size:', description: 'File size with operators', example: 'size:>10MB' },
      { name: 'extension:', description: 'File extension', example: 'extension:txt' },
      { name: 'name:', description: 'Filename contains', example: 'name:report' }
    ]
  },
  {
    category: 'Dates & Time',
    icon: Calendar,
    filters: [
      { name: 'modified:', description: 'Last modification date', example: 'modified:today' },
      { name: 'created:', description: 'File creation date', example: 'created:2024-01-15' },
      { name: 'accessed:', description: 'Last access date', example: 'accessed:this-week' },
      { name: 'between:', description: 'Date range', example: 'between:2024-01-01,2024-01-31' }
    ]
  },
  {
    category: 'Version Info',
    icon: Clock,
    filters: [
      { name: 'versions:', description: 'Number of versions', example: 'versions:>10' },
      { name: 'version-date:', description: 'Specific version date', example: 'version-date:yesterday' },
      { name: 'latest:', description: 'Only latest versions', example: 'latest:true' },
      { name: 'has-label:', description: 'Has custom labels', example: 'has-label:important' }
    ]
  },
  {
    category: 'Location & Space',
    icon: HardDrive,
    filters: [
      { name: 'space:', description: 'Within specific space', example: 'space:documents' },
      { name: 'path:', description: 'File path contains', example: 'path:projects/2024' },
      { name: 'folder:', description: 'Direct parent folder', example: 'folder:reports' },
      { name: 'depth:', description: 'Folder depth level', example: 'depth:2' }
    ]
  }
]

const searchTips = [
  {
    icon: Zap,
    title: 'Quick Search Tips',
    tips: [
      'Use keyboard shortcut Cmd+F for instant search',
      'Search is case-insensitive by default',
      'Partial matches are automatically included',
      'Recent searches are saved for quick access'
    ]
  },
  {
    icon: Tag,
    title: 'Advanced Techniques',
    tips: [
      'Combine multiple filters with spaces',
      'Use parentheses to group complex queries',
      'Save frequent searches as bookmarks',
      'Export search results to CSV or PDF'
    ]
  },
  {
    icon: Filter,
    title: 'Performance Tips',
    tips: [
      'More specific queries return faster results',
      'Use date filters to narrow large result sets',
      'Index rebuilds automatically for optimal speed',
      'Search within specific spaces for better performance'
    ]
  }
]

export function SearchGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Search & Filtering Guide
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Master Augment's powerful search capabilities to find any file or version instantly. 
          Learn advanced filtering techniques and search operators for precise results.
        </p>
      </motion.div>

      {/* Search Types */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Types of Search
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Augment offers multiple search methods to help you find exactly what you're looking for.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {searchTypes.map((type, index) => {
            const Icon = type.icon
            return (
              <div key={type.title} className="card p-6">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-5 w-5" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {type.title}
                  </h3>
                </div>
                <p className="text-gray-600 dark:text-gray-300 mb-4">
                  {type.description}
                </p>
                <div>
                  <h4 className="font-medium text-gray-700 dark:text-gray-300 mb-2">Examples:</h4>
                  <ul className="space-y-1">
                    {type.examples.map((example, exampleIndex) => (
                      <li key={exampleIndex} className="text-sm font-mono bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded">
                        {example}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Search Operators */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Search Operators
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Use these operators to create more precise and powerful search queries.
        </p>
        
        <div className="mt-8 card p-6">
          <div className="space-y-4">
            {searchOperators.map((op, index) => (
              <div key={op.operator} className="border-l-4 border-primary pl-4">
                <div className="flex items-center space-x-3 mb-2">
                  <code className="bg-primary/10 text-primary px-2 py-1 rounded font-semibold">
                    {op.operator}
                  </code>
                  <span className="font-medium text-gray-900 dark:text-white">
                    {op.description}
                  </span>
                </div>
                <div className="text-sm text-gray-600 dark:text-gray-300 mb-1">
                  <strong>Example:</strong> <code className="bg-gray-100 dark:bg-gray-800 px-1 rounded">{op.example}</code>
                </div>
                <div className="text-sm text-gray-500 dark:text-gray-400">
                  {op.usage}
                </div>
              </div>
            ))}
          </div>
        </div>
      </motion.div>

      {/* Filter Categories */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Advanced Filters
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Combine these filters to create highly specific search queries.
        </p>
        
        <div className="mt-8 space-y-8">
          {filterCategories.map((category, index) => {
            const Icon = category.icon
            return (
              <div key={category.category} className="card p-6">
                <div className="flex items-center space-x-3 mb-6">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-4 w-4" />
                  </div>
                  <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                    {category.category}
                  </h3>
                </div>
                
                <div className="grid gap-4 sm:grid-cols-2">
                  {category.filters.map((filter, filterIndex) => (
                    <div key={filter.name} className="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
                      <div className="flex items-center space-x-2 mb-2">
                        <code className="bg-blue-100 text-blue-800 dark:bg-blue-900/20 dark:text-blue-300 px-2 py-1 rounded text-sm font-semibold">
                          {filter.name}
                        </code>
                      </div>
                      <p className="text-sm text-gray-600 dark:text-gray-300 mb-2">
                        {filter.description}
                      </p>
                      <div className="text-sm">
                        <span className="text-gray-500 dark:text-gray-400">Example: </span>
                        <code className="bg-gray-100 dark:bg-gray-800 px-1 rounded">
                          {filter.example}
                        </code>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Search Tips */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Search Tips & Best Practices
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Get the most out of Augment's search with these expert tips.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {searchTips.map((tipGroup, index) => {
            const Icon = tipGroup.icon
            return (
              <div key={tipGroup.title} className="card p-6">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-green-100 text-green-600 dark:bg-green-900/20 dark:text-green-400">
                    <Icon className="h-4 w-4" />
                  </div>
                  <h3 className="font-semibold text-gray-900 dark:text-white">
                    {tipGroup.title}
                  </h3>
                </div>
                <ul className="space-y-2">
                  {tipGroup.tips.map((tip, tipIndex) => (
                    <li key={tipIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-300">
                      <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-green-500 flex-shrink-0"></div>
                      <span>{tip}</span>
                    </li>
                  ))}
                </ul>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Complex Query Examples */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 1.0 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Complex Query Examples
        </h2>
        
        <div className="mt-8 card p-6">
          <div className="space-y-6">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                Find large PDF files modified this week
              </h3>
              <code className="block bg-gray-100 dark:bg-gray-800 p-3 rounded text-sm">
                type:pdf AND size:&gt;5MB AND modified:this-week
              </code>
            </div>
            
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                Search for presentations excluding drafts
              </h3>
              <code className="block bg-gray-100 dark:bg-gray-800 p-3 rounded text-sm">
                (presentation OR slideshow) AND NOT draft AND type:pptx
              </code>
            </div>
            
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                Find files with many versions in specific space
              </h3>
              <code className="block bg-gray-100 dark:bg-gray-800 p-3 rounded text-sm">
                space:documents AND versions:&gt;10 AND modified:last-month
              </code>
            </div>
            
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                Search for important files by label and date range
              </h3>
              <code className="block bg-gray-100 dark:bg-gray-800 p-3 rounded text-sm">
                has-label:important AND between:2024-01-01,2024-03-31
              </code>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
