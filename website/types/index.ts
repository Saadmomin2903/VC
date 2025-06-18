// Common types used throughout the application

export interface NavItem {
  name: string
  href: string
  icon?: React.ComponentType<{ className?: string }>
  description?: string
}

export interface Feature {
  icon: React.ComponentType<{ className?: string }>
  title: string
  description: string
  benefits?: string[]
  color?: string
}

export interface Testimonial {
  name: string
  role: string
  company: string
  content: string
  rating: number
  avatar: string
}

export interface FAQ {
  question: string
  answer: string
  category?: string
}

export interface BlogPost {
  id: string
  title: string
  excerpt: string
  content: string
  author: string
  publishedAt: string
  updatedAt?: string
  tags: string[]
  slug: string
  featured?: boolean
  coverImage?: string
}

export interface DocumentationPage {
  id: string
  title: string
  content: string
  slug: string
  category: string
  order: number
  lastUpdated: string
  tags: string[]
  toc?: TableOfContentsItem[]
}

export interface TableOfContentsItem {
  id: string
  title: string
  level: number
  children?: TableOfContentsItem[]
}

export interface DownloadOption {
  name: string
  description: string
  version: string
  size: string
  downloadUrl: string
  checksum?: string
  releaseNotes?: string
}

export interface SystemRequirement {
  category: string
  minimum: RequirementSpec
  recommended: RequirementSpec
}

export interface RequirementSpec {
  os: string
  processor: string
  memory: string
  storage: string
  network?: string
  additional?: string[]
}

export interface SupportTicket {
  id: string
  subject: string
  description: string
  category: string
  priority: 'low' | 'medium' | 'high' | 'urgent'
  status: 'open' | 'in-progress' | 'resolved' | 'closed'
  createdAt: string
  updatedAt: string
  userEmail: string
  userName: string
}

export interface ContactFormData {
  name: string
  email: string
  subject: string
  message: string
  category: string
  priority?: string
}

export interface SearchResult {
  id: string
  title: string
  excerpt: string
  url: string
  type: 'documentation' | 'blog' | 'faq' | 'feature'
  relevance: number
}

export interface ReleaseNote {
  version: string
  date: string
  type: 'major' | 'minor' | 'patch'
  features: string[]
  improvements: string[]
  bugFixes: string[]
  breaking?: string[]
}

export interface TeamMember {
  name: string
  role: string
  bio: string
  avatar: string
  social?: {
    twitter?: string
    linkedin?: string
    github?: string
  }
}

export interface CompanyValue {
  title: string
  description: string
  icon: React.ComponentType<{ className?: string }>
}

export interface TimelineEvent {
  date: string
  title: string
  description: string
  type: 'milestone' | 'release' | 'achievement'
}

export interface PricingPlan {
  name: string
  description: string
  price: number
  period: 'month' | 'year' | 'lifetime'
  features: string[]
  popular?: boolean
  cta: string
}

export interface Integration {
  name: string
  description: string
  icon: string
  category: string
  status: 'available' | 'coming-soon' | 'beta'
  url?: string
}

export interface Changelog {
  version: string
  date: string
  changes: ChangelogEntry[]
}

export interface ChangelogEntry {
  type: 'added' | 'changed' | 'deprecated' | 'removed' | 'fixed' | 'security'
  description: string
}

export interface MetaData {
  title: string
  description: string
  keywords?: string[]
  author?: string
  image?: string
  url?: string
}

export interface BreadcrumbItem {
  label: string
  href?: string
}

export interface AlertProps {
  type: 'info' | 'success' | 'warning' | 'error'
  title?: string
  message: string
  dismissible?: boolean
  onDismiss?: () => void
}

export interface LoadingState {
  isLoading: boolean
  error?: string | null
  data?: any
}

export interface PaginationProps {
  currentPage: number
  totalPages: number
  onPageChange: (page: number) => void
  showFirstLast?: boolean
  showPrevNext?: boolean
}

export interface FilterOption {
  label: string
  value: string
  count?: number
}

export interface SortOption {
  label: string
  value: string
  direction: 'asc' | 'desc'
}

// API Response types
export interface ApiResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

export interface ApiError {
  code: string
  message: string
  details?: any
}

// Form validation types
export interface ValidationRule {
  required?: boolean
  minLength?: number
  maxLength?: number
  pattern?: RegExp
  custom?: (value: any) => boolean | string
}

export interface FormField {
  name: string
  label: string
  type: 'text' | 'email' | 'password' | 'textarea' | 'select' | 'checkbox' | 'radio'
  placeholder?: string
  options?: { label: string; value: string }[]
  validation?: ValidationRule
  defaultValue?: any
}

export interface FormErrors {
  [key: string]: string
}
