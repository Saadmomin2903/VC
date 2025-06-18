'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Download, Users, Globe, TrendingUp, Calendar, Monitor } from 'lucide-react'

// Mock download statistics - in production, this would come from your analytics API
const mockStats = {
  totalDownloads: 12847,
  downloadsToday: 156,
  downloadsThisWeek: 1203,
  downloadsThisMonth: 4891,
  platforms: {
    macos: 12847,
    windows: 0,
    linux: 0
  },
  countries: [
    { name: 'United States', downloads: 4521, percentage: 35.2 },
    { name: 'United Kingdom', downloads: 2103, percentage: 16.4 },
    { name: 'Germany', downloads: 1876, percentage: 14.6 },
    { name: 'Canada', downloads: 1234, percentage: 9.6 },
    { name: 'Australia', downloads: 987, percentage: 7.7 },
    { name: 'Others', downloads: 2126, percentage: 16.5 }
  ],
  recentDownloads: [
    { timestamp: '2 minutes ago', location: 'San Francisco, CA', version: '1.0.0' },
    { timestamp: '5 minutes ago', location: 'London, UK', version: '1.0.0' },
    { timestamp: '8 minutes ago', location: 'Toronto, CA', version: '1.0.0' },
    { timestamp: '12 minutes ago', location: 'Berlin, DE', version: '1.0.0' },
    { timestamp: '15 minutes ago', location: 'Sydney, AU', version: '1.0.0' }
  ]
}

export function DownloadStats() {
  const [stats, setStats] = useState(mockStats)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Simulate loading delay
    const timer = setTimeout(() => {
      setIsLoading(false)
    }, 1000)

    return () => clearTimeout(timer)
  }, [])

  // Simulate real-time updates
  useEffect(() => {
    const interval = setInterval(() => {
      setStats(prevStats => ({
        ...prevStats,
        totalDownloads: prevStats.totalDownloads + Math.floor(Math.random() * 3),
        downloadsToday: prevStats.downloadsToday + Math.floor(Math.random() * 2)
      }))
    }, 30000) // Update every 30 seconds

    return () => clearInterval(interval)
  }, [])

  if (isLoading) {
    return (
      <div className="space-y-6">
        {[...Array(4)].map((_, i) => (
          <div key={i} className="card p-6">
            <div className="animate-pulse">
              <div className="h-4 bg-gray-200 rounded w-1/4 mb-4 dark:bg-gray-700"></div>
              <div className="h-8 bg-gray-200 rounded w-1/2 dark:bg-gray-700"></div>
            </div>
          </div>
        ))}
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Overview Stats */}
      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="card p-6"
        >
          <div className="flex items-center space-x-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-100 text-blue-600 dark:bg-blue-900/20 dark:text-blue-400">
              <Download className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Total Downloads</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {stats.totalDownloads.toLocaleString()}
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.1 }}
          className="card p-6"
        >
          <div className="flex items-center space-x-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-green-100 text-green-600 dark:bg-green-900/20 dark:text-green-400">
              <Calendar className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Today</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {stats.downloadsToday.toLocaleString()}
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="card p-6"
        >
          <div className="flex items-center space-x-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-purple-100 text-purple-600 dark:bg-purple-900/20 dark:text-purple-400">
              <TrendingUp className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">This Week</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {stats.downloadsThisWeek.toLocaleString()}
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.3 }}
          className="card p-6"
        >
          <div className="flex items-center space-x-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-orange-100 text-orange-600 dark:bg-orange-900/20 dark:text-orange-400">
              <Users className="h-5 w-5" />
            </div>
            <div>
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">This Month</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {stats.downloadsThisMonth.toLocaleString()}
              </p>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Platform Distribution */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="card p-6"
      >
        <h3 className="mb-4 text-lg font-semibold text-gray-900 dark:text-white">
          Platform Distribution
        </h3>
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <Monitor className="h-4 w-4 text-gray-600 dark:text-gray-400" />
              <span className="text-sm font-medium text-gray-900 dark:text-white">macOS</span>
            </div>
            <div className="flex items-center space-x-3">
              <div className="h-2 w-32 rounded-full bg-gray-200 dark:bg-gray-700">
                <div className="h-2 w-full rounded-full bg-blue-600"></div>
              </div>
              <span className="text-sm font-medium text-gray-900 dark:text-white">
                {stats.platforms.macos.toLocaleString()}
              </span>
            </div>
          </div>
          <div className="flex items-center justify-between opacity-50">
            <div className="flex items-center space-x-2">
              <Monitor className="h-4 w-4 text-gray-600 dark:text-gray-400" />
              <span className="text-sm font-medium text-gray-900 dark:text-white">Windows</span>
            </div>
            <div className="flex items-center space-x-3">
              <div className="h-2 w-32 rounded-full bg-gray-200 dark:bg-gray-700">
                <div className="h-2 w-0 rounded-full bg-green-600"></div>
              </div>
              <span className="text-sm font-medium text-gray-900 dark:text-white">Coming Soon</span>
            </div>
          </div>
          <div className="flex items-center justify-between opacity-50">
            <div className="flex items-center space-x-2">
              <Monitor className="h-4 w-4 text-gray-600 dark:text-gray-400" />
              <span className="text-sm font-medium text-gray-900 dark:text-white">Linux</span>
            </div>
            <div className="flex items-center space-x-3">
              <div className="h-2 w-32 rounded-full bg-gray-200 dark:bg-gray-700">
                <div className="h-2 w-0 rounded-full bg-purple-600"></div>
              </div>
              <span className="text-sm font-medium text-gray-900 dark:text-white">Coming Soon</span>
            </div>
          </div>
        </div>
      </motion.div>

      {/* Geographic Distribution */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.5 }}
        className="card p-6"
      >
        <h3 className="mb-4 text-lg font-semibold text-gray-900 dark:text-white">
          Downloads by Country
        </h3>
        <div className="space-y-3">
          {stats.countries.map((country, index) => (
            <div key={country.name} className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-900 dark:text-white">
                {country.name}
              </span>
              <div className="flex items-center space-x-3">
                <div className="h-2 w-24 rounded-full bg-gray-200 dark:bg-gray-700">
                  <div 
                    className="h-2 rounded-full bg-primary"
                    style={{ width: `${country.percentage}%` }}
                  ></div>
                </div>
                <span className="text-sm text-gray-600 dark:text-gray-400 w-16 text-right">
                  {country.downloads.toLocaleString()}
                </span>
              </div>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Recent Downloads */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="card p-6"
      >
        <h3 className="mb-4 text-lg font-semibold text-gray-900 dark:text-white">
          Recent Downloads
        </h3>
        <div className="space-y-3">
          {stats.recentDownloads.map((download, index) => (
            <div key={index} className="flex items-center justify-between py-2 border-b border-gray-100 dark:border-gray-700 last:border-0">
              <div>
                <p className="text-sm font-medium text-gray-900 dark:text-white">
                  Augment v{download.version}
                </p>
                <p className="text-xs text-gray-500 dark:text-gray-400">
                  {download.location}
                </p>
              </div>
              <span className="text-xs text-gray-500 dark:text-gray-400">
                {download.timestamp}
              </span>
            </div>
          ))}
        </div>
      </motion.div>
    </div>
  )
}
