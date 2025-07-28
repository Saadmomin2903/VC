"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import {
  Download,
  Users,
  Globe,
  TrendingUp,
  Calendar,
  Monitor,
} from "lucide-react";

// Beta download statistics - realistic numbers for a beta application
const mockStats = {
  totalDownloads: 47,
  downloadsToday: 3,
  downloadsThisWeek: 12,
  downloadsThisMonth: 28,
  platforms: {
    macos: 47,
    windows: 0,
    linux: 0,
  },
  countries: [
    { name: "India", downloads: 15, percentage: 31.9 },
    { name: "United States", downloads: 12, percentage: 25.5 },
    { name: "United Kingdom", downloads: 8, percentage: 17.0 },
    { name: "Germany", downloads: 5, percentage: 10.6 },
    { name: "Canada", downloads: 4, percentage: 8.5 },
    { name: "Others", downloads: 3, percentage: 6.4 },
  ],
  recentDownloads: [
    {
      timestamp: "2 minutes ago",
      location: "San Francisco, CA",
      version: "1.0.0",
    },
    { timestamp: "5 minutes ago", location: "London, UK", version: "1.0.0" },
    { timestamp: "8 minutes ago", location: "Toronto, CA", version: "1.0.0" },
    { timestamp: "12 minutes ago", location: "Berlin, DE", version: "1.0.0" },
    { timestamp: "15 minutes ago", location: "Sydney, AU", version: "1.0.0" },
  ],
};

export function DownloadStats({ type = "augment-macos" }: { type?: string }) {
  const [count, setCount] = useState<number | null>(null);

  useEffect(() => {
    let isMounted = true;
    async function fetchCount() {
      try {
        const res = await fetch(`/api/download-count?type=${type}`);
        const data = await res.json();
        if (isMounted) setCount(data.count);
      } catch {
        if (isMounted) setCount(null);
      }
    }
    fetchCount();
    const interval = setInterval(fetchCount, 5000);
    return () => {
      isMounted = false;
      clearInterval(interval);
    };
  }, [type]);

  return (
    <div className="text-center text-sm text-gray-600 dark:text-gray-300 mt-2">
      <span className="font-bold text-lg text-primary">
        {count !== null ? count : "—"}
      </span>{" "}
      downloads
    </div>
  );
}
