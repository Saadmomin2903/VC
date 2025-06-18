"use client";

import { useState } from "react";
import {
  Search,
  Menu,
  X,
  Book,
  Zap,
  Settings,
  HelpCircle,
  FileText,
} from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { clsx } from "clsx";

const navigation = [
  {
    title: "Getting Started",
    icon: Zap,
    items: [
      { title: "Introduction", href: "/documentation" },
      { title: "Installation", href: "/documentation/installation" },
      { title: "Quick Start", href: "/documentation/quick-start" },
      { title: "First Steps", href: "/documentation/first-steps" },
    ],
  },
  {
    title: "Core Features",
    icon: Book,
    items: [
      { title: "Managing Spaces", href: "/documentation/spaces" },
      { title: "Version History", href: "/documentation/version-history" },
      { title: "File Recovery", href: "/documentation/file-recovery" },
      { title: "Search & Filtering", href: "/documentation/search" },
    ],
  },
  {
    title: "Advanced Topics",
    icon: Settings,
    items: [
      { title: "Storage Management", href: "/documentation/storage" },
      { title: "Troubleshooting", href: "/documentation/troubleshooting" },
    ],
  },
  {
    title: "Support",
    icon: HelpCircle,
    items: [{ title: "FAQ", href: "/documentation/faq" }],
  },
];

interface DocumentationLayoutProps {
  children: React.ReactNode;
}

export function DocumentationLayout({ children }: DocumentationLayoutProps) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const pathname = usePathname();

  return (
    <div className="flex min-h-screen bg-white dark:bg-gray-900 pt-16">
      {/* Sidebar */}
      <div
        className={clsx(
          "fixed inset-y-0 left-0 z-50 w-64 transform bg-white dark:bg-gray-900 border-r border-gray-200 dark:border-gray-800 transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0",
          sidebarOpen ? "translate-x-0" : "-translate-x-full"
        )}
      >
        <div className="flex h-full flex-col pt-16 lg:pt-0">
          {/* Search */}
          <div className="p-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search documentation..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full rounded-lg border border-gray-200 bg-white pl-10 pr-4 py-2 text-sm focus:border-primary focus:outline-none focus:ring-1 focus:ring-primary dark:border-gray-700 dark:bg-gray-800 dark:text-white"
              />
            </div>
          </div>

          {/* Navigation */}
          <nav className="flex-1 overflow-y-auto px-4 pb-4">
            <div className="space-y-6">
              {navigation.map((section) => {
                const Icon = section.icon;
                return (
                  <div key={section.title}>
                    <div className="flex items-center space-x-2 text-sm font-semibold text-gray-900 dark:text-white">
                      <Icon className="h-4 w-4" />
                      <span>{section.title}</span>
                    </div>
                    <ul className="mt-3 space-y-1">
                      {section.items.map((item) => (
                        <li key={item.href}>
                          <Link
                            href={item.href}
                            className={clsx(
                              "block rounded-md px-3 py-2 text-sm transition-colors",
                              pathname === item.href
                                ? "bg-primary text-white"
                                : "text-gray-600 hover:bg-gray-100 hover:text-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-white"
                            )}
                            onClick={() => setSidebarOpen(false)}
                          >
                            {item.title}
                          </Link>
                        </li>
                      ))}
                    </ul>
                  </div>
                );
              })}
            </div>
          </nav>
        </div>
      </div>

      {/* Mobile sidebar overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 z-40 bg-black bg-opacity-50 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Main content */}
      <div className="flex-1 lg:ml-0">
        {/* Mobile header */}
        <div className="sticky top-16 z-30 flex h-14 items-center justify-between border-b border-gray-200 bg-white px-4 dark:border-gray-800 dark:bg-gray-900 lg:hidden">
          <button
            onClick={() => setSidebarOpen(true)}
            className="flex h-8 w-8 items-center justify-center rounded-md text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white"
          >
            <Menu className="h-5 w-5" />
          </button>
          <span className="text-sm font-medium text-gray-900 dark:text-white">
            Documentation
          </span>
          <div className="w-8" />
        </div>

        {/* Content */}
        <main className="flex-1">{children}</main>
      </div>
    </div>
  );
}
