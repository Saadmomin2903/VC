"use client";

import { useEffect } from "react";
import { usePathname } from "next/navigation";

export function Analytics() {
  const pathname = usePathname();

  useEffect(() => {
    // Google Analytics
    if (typeof window !== "undefined" && window.gtag) {
      window.gtag("config", process.env.NEXT_PUBLIC_GA_ID, {
        page_path: pathname,
      });
    }

    // Simple analytics (you can replace with your preferred analytics service)
    if (typeof window !== "undefined") {
      // Track page views
      console.log("Page view:", pathname);
    }
  }, [pathname]);

  return null;
}

// Extend the Window interface to include gtag
declare global {
  interface Window {
    gtag: (...args: any[]) => void;
  }
}
