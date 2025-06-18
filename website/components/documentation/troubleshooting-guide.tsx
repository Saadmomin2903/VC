'use client'

import { motion } from 'framer-motion'
import { AlertTriangle, HelpCircle, Settings, Zap, Shield, RefreshCw, Terminal, Mail } from 'lucide-react'

const commonIssues = [
  {
    category: 'Installation & Setup',
    icon: Settings,
    issues: [
      {
        problem: 'App won\'t launch after installation',
        symptoms: ['Application crashes on startup', 'No response when double-clicking'],
        solutions: [
          'Right-click Augment and select "Open" to bypass Gatekeeper',
          'Check that you\'re running macOS 11.0 or later',
          'Restart your Mac and try again',
          'Reinstall Augment with admin privileges'
        ]
      },
      {
        problem: 'Permission denied errors',
        symptoms: ['Cannot create spaces', 'Access denied messages'],
        solutions: [
          'Grant Full Disk Access in System Preferences > Security & Privacy',
          'Run Augment as administrator',
          'Check folder permissions for target directories',
          'Restart Augment after granting permissions'
        ]
      }
    ]
  },
  {
    category: 'Performance Issues',
    icon: Zap,
    issues: [
      {
        problem: 'Slow file operations',
        symptoms: ['Long delays when saving files', 'High CPU usage'],
        solutions: [
          'Check available disk space (need 10%+ free)',
          'Reduce version frequency in space settings',
          'Exclude large files from versioning',
          'Run storage cleanup to free up space'
        ]
      },
      {
        problem: 'High memory usage',
        symptoms: ['System slowdown', 'Memory pressure warnings'],
        solutions: [
          'Restart Augment to clear memory cache',
          'Reduce number of active spaces',
          'Close unused applications',
          'Check for memory leaks in Activity Monitor'
        ]
      }
    ]
  },
  {
    category: 'Version Management',
    icon: RefreshCw,
    issues: [
      {
        problem: 'Versions not being created',
        symptoms: ['No new versions appear', 'Version count stays the same'],
        solutions: [
          'Check that the file is within a protected space',
          'Verify space is active and not paused',
          'Ensure file type is not excluded',
          'Check storage limits haven\'t been exceeded'
        ]
      },
      {
        problem: 'Cannot restore previous version',
        symptoms: ['Restore button grayed out', 'Error during restoration'],
        solutions: [
          'Check file permissions on target location',
          'Ensure original file isn\'t open in another app',
          'Verify sufficient disk space for restoration',
          'Try copying version to new location instead'
        ]
      }
    ]
  }
]

const diagnosticSteps = [
  {
    step: 1,
    title: 'Check System Status',
    description: 'Verify basic system requirements and status',
    actions: [
      'Confirm macOS version (11.0+)',
      'Check available disk space',
      'Verify Augment is running',
      'Review system permissions'
    ]
  },
  {
    step: 2,
    title: 'Review Error Messages',
    description: 'Collect and analyze any error messages',
    actions: [
      'Note exact error text',
      'Check Console app for Augment logs',
      'Screenshot error dialogs',
      'Record when errors occur'
    ]
  },
  {
    step: 3,
    title: 'Test Basic Functions',
    description: 'Verify core functionality is working',
    actions: [
      'Try creating a new space',
      'Test file versioning',
      'Attempt version restoration',
      'Check space settings'
    ]
  },
  {
    step: 4,
    title: 'Gather Information',
    description: 'Collect system information for support',
    actions: [
      'Note Augment version number',
      'Record macOS version',
      'List affected spaces/files',
      'Document reproduction steps'
    ]
  }
]

const emergencyProcedures = [
  {
    icon: AlertTriangle,
    title: 'Database Corruption',
    description: 'If Augment\'s database becomes corrupted',
    steps: [
      'Quit Augment immediately',
      'Backup your spaces folder',
      'Run database repair tool',
      'Restore from backup if needed'
    ],
    severity: 'Critical'
  },
  {
    icon: Shield,
    title: 'Data Recovery',
    description: 'If files are accidentally deleted or corrupted',
    steps: [
      'Don\'t panic - versions are still safe',
      'Open Augment and locate the file',
      'Use "Show Deleted Files" option',
      'Restore from most recent good version'
    ],
    severity: 'High'
  },
  {
    icon: HelpCircle,
    title: 'Complete System Failure',
    description: 'If Augment won\'t start at all',
    steps: [
      'Try safe mode startup',
      'Check system logs for errors',
      'Reinstall Augment',
      'Contact support with logs'
    ],
    severity: 'Critical'
  }
]

export function TroubleshootingGuide() {
  return (
    <div className="mx-auto max-w-4xl px-6 py-12">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
      >
        <h1 className="text-4xl font-bold tracking-tight text-gray-900 dark:text-white">
          Troubleshooting Guide
        </h1>
        <p className="mt-4 text-xl text-gray-600 dark:text-gray-300">
          Find solutions to common issues and learn how to diagnose and resolve problems with Augment. 
          Most issues can be resolved quickly with the right approach.
        </p>
      </motion.div>

      {/* Quick Diagnostic */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mt-12"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Quick Diagnostic Steps
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Follow these steps to diagnose most issues systematically.
        </p>
        
        <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {diagnosticSteps.map((step, index) => (
            <div key={step.step} className="card p-6">
              <div className="flex items-center space-x-3 mb-4">
                <div className="flex h-8 w-8 items-center justify-center rounded-full bg-primary text-white font-bold text-sm">
                  {step.step}
                </div>
                <h3 className="font-semibold text-gray-900 dark:text-white">
                  {step.title}
                </h3>
              </div>
              <p className="text-gray-600 dark:text-gray-300 mb-4 text-sm">
                {step.description}
              </p>
              <ul className="space-y-1">
                {step.actions.map((action, actionIndex) => (
                  <li key={actionIndex} className="flex items-start space-x-2 text-sm text-gray-500 dark:text-gray-400">
                    <div className="mt-1.5 h-1.5 w-1.5 rounded-full bg-primary flex-shrink-0"></div>
                    <span>{action}</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Common Issues */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.4 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Common Issues & Solutions
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          Here are the most frequently encountered issues and their solutions.
        </p>
        
        <div className="mt-8 space-y-12">
          {commonIssues.map((category, categoryIndex) => {
            const Icon = category.icon
            return (
              <div key={category.category}>
                <div className="flex items-center space-x-3 mb-6">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/10 text-primary">
                    <Icon className="h-4 w-4" />
                  </div>
                  <h3 className="text-xl font-semibold text-gray-900 dark:text-white">
                    {category.category}
                  </h3>
                </div>
                
                <div className="space-y-6">
                  {category.issues.map((issue, issueIndex) => (
                    <div key={issueIndex} className="card p-6">
                      <h4 className="font-semibold text-gray-900 dark:text-white mb-3">
                        {issue.problem}
                      </h4>
                      
                      <div className="grid gap-6 lg:grid-cols-2">
                        <div>
                          <h5 className="font-medium text-gray-700 dark:text-gray-300 mb-2">Symptoms:</h5>
                          <ul className="space-y-1">
                            {issue.symptoms.map((symptom, symptomIndex) => (
                              <li key={symptomIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-400">
                                <AlertTriangle className="h-4 w-4 text-yellow-500 mt-0.5 flex-shrink-0" />
                                <span>{symptom}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                        
                        <div>
                          <h5 className="font-medium text-gray-700 dark:text-gray-300 mb-2">Solutions:</h5>
                          <ol className="space-y-1">
                            {issue.solutions.map((solution, solutionIndex) => (
                              <li key={solutionIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-400">
                                <span className="flex h-4 w-4 items-center justify-center rounded-full bg-green-100 text-green-600 text-xs font-semibold mt-0.5 dark:bg-green-900/20 dark:text-green-400">
                                  {solutionIndex + 1}
                                </span>
                                <span>{solution}</span>
                              </li>
                            ))}
                          </ol>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Emergency Procedures */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.6 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          Emergency Procedures
        </h2>
        <p className="mt-2 text-gray-600 dark:text-gray-300">
          For critical issues that require immediate attention.
        </p>
        
        <div className="mt-8 grid gap-8 lg:grid-cols-3">
          {emergencyProcedures.map((procedure, index) => {
            const Icon = procedure.icon
            const severityColor = procedure.severity === 'Critical' 
              ? 'bg-red-100 text-red-600 dark:bg-red-900/20 dark:text-red-400'
              : 'bg-yellow-100 text-yellow-600 dark:bg-yellow-900/20 dark:text-yellow-400'
            
            return (
              <div key={procedure.title} className="card p-6">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center space-x-3">
                    <div className={`flex h-8 w-8 items-center justify-center rounded-lg ${severityColor}`}>
                      <Icon className="h-4 w-4" />
                    </div>
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {procedure.title}
                    </h3>
                  </div>
                  <span className={`px-2 py-1 rounded text-xs font-medium ${severityColor}`}>
                    {procedure.severity}
                  </span>
                </div>
                
                <p className="text-gray-600 dark:text-gray-300 mb-4">
                  {procedure.description}
                </p>
                
                <ol className="space-y-2">
                  {procedure.steps.map((step, stepIndex) => (
                    <li key={stepIndex} className="flex items-start space-x-2 text-sm text-gray-600 dark:text-gray-400">
                      <span className="flex h-5 w-5 items-center justify-center rounded-full bg-primary/10 text-primary text-xs font-semibold mt-0.5">
                        {stepIndex + 1}
                      </span>
                      <span>{step}</span>
                    </li>
                  ))}
                </ol>
              </div>
            )
          })}
        </div>
      </motion.div>

      {/* Getting Help */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="mt-16"
      >
        <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
          When to Contact Support
        </h2>
        
        <div className="mt-8 card p-6">
          <p className="text-gray-600 dark:text-gray-300 mb-6">
            If you've tried the solutions above and still need help, our support team is here to assist you.
          </p>
          
          <div className="grid gap-6 sm:grid-cols-2">
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Before Contacting Support</h3>
              <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-300">
                <li>• Try the diagnostic steps above</li>
                <li>• Note your Augment version number</li>
                <li>• Record your macOS version</li>
                <li>• Gather any error messages</li>
                <li>• Document steps to reproduce the issue</li>
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 dark:text-white mb-3">Contact Information</h3>
              <div className="space-y-3">
                <div className="flex items-center space-x-3">
                  <Mail className="h-4 w-4 text-primary" />
                  <span className="text-sm text-gray-600 dark:text-gray-300">support@augment-app.com</span>
                </div>
                <div className="flex items-center space-x-3">
                  <HelpCircle className="h-4 w-4 text-primary" />
                  <span className="text-sm text-gray-600 dark:text-gray-300">Response within 2 hours</span>
                </div>
                <div className="flex items-center space-x-3">
                  <Terminal className="h-4 w-4 text-primary" />
                  <span className="text-sm text-gray-600 dark:text-gray-300">Include system logs when possible</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}
