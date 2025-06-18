"use client";

import { useState, useEffect } from "react";
import { Download, CheckCircle, AlertCircle, Loader2 } from "lucide-react";
import {
  useDownload,
  detectPlatform,
  checkCompatibility,
} from "@/lib/download";
import { motion, AnimatePresence } from "framer-motion";
import { DownloadConfirmation } from "./download-confirmation";

interface DownloadButtonProps {
  type?: "augment-macos" | "augment-github";
  variant?: "primary" | "secondary" | "outline";
  size?: "sm" | "md" | "lg";
  showVersion?: boolean;
  showSize?: boolean;
  className?: string;
  children?: React.ReactNode;
}

export function DownloadButton({
  type = "augment-macos",
  variant = "primary",
  size = "md",
  showVersion = true,
  showSize = true,
  className = "",
  children,
}: DownloadButtonProps) {
  const { downloadState, startDownload, resetDownload } = useDownload();
  const [showFeedback, setShowFeedback] = useState(false);
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [isClient, setIsClient] = useState(false);

  // Ensure client-side only rendering for platform detection
  useEffect(() => {
    setIsClient(true);
  }, []);

  const compatibility = isClient ? checkCompatibility() : { compatible: true };
  const platform = isClient ? detectPlatform() : "unknown";

  const handleDownload = async () => {
    try {
      await startDownload(type);
      setShowConfirmation(true);
      setShowFeedback(true);

      // Hide feedback after 3 seconds
      setTimeout(() => {
        setShowFeedback(false);
        resetDownload();
      }, 3000);
    } catch (error) {
      console.error("Download failed:", error);
      setShowFeedback(true);

      // Hide error feedback after 5 seconds
      setTimeout(() => {
        setShowFeedback(false);
        resetDownload();
      }, 5000);
    }
  };

  // Button size classes
  const sizeClasses = {
    sm: "px-3 py-2 text-sm",
    md: "px-6 py-3 text-base",
    lg: "px-8 py-4 text-lg",
  };

  // Button variant classes
  const variantClasses = {
    primary: "btn-primary",
    secondary: "btn-secondary",
    outline: "btn-outline",
  };

  // Show compatibility warning for non-macOS users (only after client-side hydration)
  if (isClient && !compatibility.compatible) {
    return (
      <div className="text-center">
        <button
          disabled
          className={`${variantClasses[variant]} ${sizeClasses[size]} ${className} opacity-50 cursor-not-allowed`}
        >
          <AlertCircle className="mr-2 h-4 w-4" />
          {children || "Download Augment"}
        </button>
        <p className="mt-2 text-sm text-gray-500 dark:text-gray-400">
          {compatibility.reason}
        </p>
        {compatibility.recommendation && (
          <p className="mt-1 text-xs text-gray-400 dark:text-gray-500">
            {compatibility.recommendation}
          </p>
        )}
      </div>
    );
  }

  return (
    <div className="relative">
      <motion.button
        onClick={handleDownload}
        disabled={downloadState.isDownloading}
        className={`${variantClasses[variant]} ${sizeClasses[size]} ${className} relative overflow-hidden transition-all duration-200 hover:scale-105 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 disabled:hover:scale-100 disabled:opacity-75`}
        whileTap={{ scale: 0.98 }}
      >
        {/* Progress bar background */}
        {downloadState.isDownloading && (
          <motion.div
            className="absolute inset-0 bg-white/20"
            initial={{ width: 0 }}
            animate={{ width: `${downloadState.progress}%` }}
            transition={{ duration: 0.5 }}
          />
        )}

        {/* Button content */}
        <div className="relative flex items-center justify-center">
          {downloadState.isDownloading ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : downloadState.success ? (
            <CheckCircle className="mr-2 h-4 w-4" />
          ) : downloadState.error ? (
            <AlertCircle className="mr-2 h-4 w-4" />
          ) : (
            <Download className="mr-2 h-4 w-4" />
          )}

          <span>
            {downloadState.isDownloading
              ? "Downloading..."
              : downloadState.success
              ? "Downloaded!"
              : downloadState.error
              ? "Download Failed"
              : children || "Download Augment"}
          </span>

          {showVersion &&
            !downloadState.isDownloading &&
            !downloadState.success &&
            !downloadState.error && (
              <span className="ml-2 text-sm opacity-75">v1.0</span>
            )}

          {showSize &&
            !downloadState.isDownloading &&
            !downloadState.success &&
            !downloadState.error && (
              <span className="ml-2 text-sm opacity-75">(15.2 MB)</span>
            )}
        </div>
      </motion.button>

      {/* Feedback messages */}
      <AnimatePresence>
        {showFeedback && (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="absolute top-full left-1/2 transform -translate-x-1/2 mt-2 z-10"
          >
            {downloadState.success && (
              <div className="bg-green-100 text-green-800 px-3 py-2 rounded-lg text-sm whitespace-nowrap dark:bg-green-900/20 dark:text-green-400">
                ✓ Download started successfully!
              </div>
            )}

            {downloadState.error && (
              <div className="bg-red-100 text-red-800 px-3 py-2 rounded-lg text-sm whitespace-nowrap dark:bg-red-900/20 dark:text-red-400">
                ✗ {downloadState.error}
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>

      {/* Platform indicator */}
      {isClient && platform === "macos" && (
        <div className="mt-2 text-xs text-gray-500 dark:text-gray-400 text-center">
          Compatible with your Mac ({platform})
        </div>
      )}

      {/* Download Confirmation Modal */}
      <DownloadConfirmation
        isVisible={showConfirmation}
        onClose={() => setShowConfirmation(false)}
        downloadInfo={{
          filename:
            type === "augment-macos"
              ? "Augment-v1.0.0-macOS.dmg"
              : "Augment-v1.0.0-Source.zip",
          version: "1.0.0",
          size: type === "augment-macos" ? "15.2 MB" : "2.8 MB",
          checksum:
            type === "augment-macos"
              ? "sha256:a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456"
              : "sha256:b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567a",
        }}
      />
    </div>
  );
}

// Simplified download button for navigation and other simple use cases
export function SimpleDownloadButton({
  className = "",
  children = "Download",
}: {
  className?: string;
  children?: React.ReactNode;
}) {
  const [isClient, setIsClient] = useState(false);

  // Ensure client-side only rendering for platform detection
  useEffect(() => {
    setIsClient(true);
  }, []);

  const handleDownload = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    try {
      console.log("SimpleDownloadButton: Download button clicked"); // Debug log
      console.log("SimpleDownloadButton: Event target:", e.target); // Debug log
      console.log(
        "SimpleDownloadButton: Event currentTarget:",
        e.currentTarget
      ); // Debug log

      // Simple download trigger without state management
      const downloadUrl = `/api/download?type=augment-macos&platform=macos&timestamp=${Date.now()}`;
      console.log("SimpleDownloadButton: Download URL:", downloadUrl); // Debug log

      const link = document.createElement("a");
      link.href = downloadUrl;
      link.download = "Augment-v1.0.0-macOS.dmg"; // Explicit download attribute
      link.style.display = "none";

      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      console.log("SimpleDownloadButton: Download triggered successfully"); // Debug log
    } catch (error) {
      console.error("SimpleDownloadButton: Download failed:", error);
      // Fallback: open in new tab
      window.open(
        `/api/download?type=augment-macos&platform=macos&timestamp=${Date.now()}`,
        "_blank"
      );
    }
  };

  const compatibility = isClient ? checkCompatibility() : { compatible: true };
  console.log("Compatibility check:", compatibility); // Debug log

  if (isClient && !compatibility.compatible) {
    console.log("Platform not compatible:", compatibility.reason); // Debug log
    return (
      <button
        disabled
        className={`${className} opacity-50 cursor-not-allowed`}
        title={compatibility.reason}
      >
        {children}
      </button>
    );
  }

  return (
    <button
      onClick={handleDownload}
      className={`${className} cursor-pointer relative`}
      type="button"
      style={{ pointerEvents: "auto", zIndex: 10 }}
    >
      {children}
    </button>
  );
}
