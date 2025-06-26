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

// Mock download statistics - in production, this would come from your analytics API
const mockStats = {
  totalDownloads: 12847,
  downloadsToday: 156,
  downloadsThisWeek: 1203,
  downloadsThisMonth: 4891,
  platforms: {
    macos: 12847,
    windows: 0,
    linux: 0,
  },
  countries: [
    { name: "United States", downloads: 4521, percentage: 35.2 },
    { name: "United Kingdom", downloads: 2103, percentage: 16.4 },
    { name: "Germany", downloads: 1876, percentage: 14.6 },
    { name: "Canada", downloads: 1234, percentage: 9.6 },
    { name: "Australia", downloads: 987, percentage: 7.7 },
    { name: "Others", downloads: 2126, percentage: 16.5 },
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
