import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/theme-provider'
import { Navigation } from '@/components/navigation'
import { Footer } from '@/components/footer'
import { Analytics } from '@/components/analytics'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: {
    default: 'Augment - Intelligent File Versioning for macOS',
    template: '%s | Augment'
  },
  description: 'Never lose work again with Augment\'s automatic file versioning system. Intelligent backup and version control for macOS that works seamlessly in the background.',
  keywords: [
    'file versioning',
    'macOS',
    'automatic backup',
    'version control',
    'file management',
    'document versioning',
    'backup software',
    'file recovery',
    'version history',
    'intelligent backup'
  ],
  authors: [{ name: 'Augment Team' }],
  creator: 'Augment Team',
  publisher: 'Augment',
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  metadataBase: new URL('https://augment-app.com'),
  alternates: {
    canonical: '/',
  },
  openGraph: {
    type: 'website',
    locale: 'en_US',
    url: 'https://augment-app.com',
    title: 'Augment - Intelligent File Versioning for macOS',
    description: 'Never lose work again with Augment\'s automatic file versioning system. Intelligent backup and version control for macOS.',
    siteName: 'Augment',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Augment - Intelligent File Versioning for macOS',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Augment - Intelligent File Versioning for macOS',
    description: 'Never lose work again with Augment\'s automatic file versioning system.',
    images: ['/og-image.png'],
    creator: '@augment_app',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  verification: {
    google: 'your-google-verification-code',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
        <link rel="manifest" href="/site.webmanifest" />
        <meta name="theme-color" content="#3b82f6" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="apple-mobile-web-app-title" content="Augment" />
        <meta name="application-name" content="Augment" />
        <meta name="msapplication-TileColor" content="#3b82f6" />
        <meta name="msapplication-config" content="/browserconfig.xml" />
      </head>
      <body className={inter.className}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <div className="flex min-h-screen flex-col">
            <Navigation />
            <main className="flex-1">
              {children}
            </main>
            <Footer />
          </div>
          <Analytics />
        </ThemeProvider>
      </body>
    </html>
  )
}
