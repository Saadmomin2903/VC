"use client";

import { useState, useEffect } from "react";
import { Download, CheckCircle, AlertCircle } from "lucide-react";

export default function TestDownloadPage() {
  const [downloadStatus, setDownloadStatus] = useState<string>("");
  const [browserInfo, setBrowserInfo] = useState({
    userAgent: "N/A",
    platform: "N/A",
    currentUrl: "N/A",
  });
  const [isMounted, setIsMounted] = useState(false);

  useEffect(() => {
    setIsMounted(true);
    setBrowserInfo({
      userAgent: window.navigator.userAgent,
      platform: window.navigator.platform,
      currentUrl: window.location.href,
    });
  }, []);

  const testDownload = async (type: string) => {
    try {
      setDownloadStatus(`Testing ${type} download...`);

      const downloadUrl = `/api/download?type=${type}&platform=macos&timestamp=${Date.now()}`;
      console.log("Testing download URL:", downloadUrl);

      // Test the API endpoint first
      const response = await fetch("/api/download", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ type }),
      });

      if (!response.ok) {
        throw new Error(`API test failed: ${response.status}`);
      }

      const data = await response.json();
      console.log("API response:", data);

      // Now trigger the actual download
      const link = document.createElement("a");
      link.href = downloadUrl;
      link.download = data.download.filename;
      link.style.display = "none";

      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      setDownloadStatus(`✅ ${type} download triggered successfully!`);
    } catch (error) {
      console.error("Download test failed:", error);
      setDownloadStatus(`❌ ${type} download failed: ${error}`);
    }
  };

  const directDownload = (type: string) => {
    try {
      setDownloadStatus(`Direct download ${type}...`);

      const downloadUrl = `/api/download?type=${type}&platform=macos&timestamp=${Date.now()}`;
      window.open(downloadUrl, "_blank");

      setDownloadStatus(`✅ ${type} direct download opened!`);
    } catch (error) {
      console.error("Direct download failed:", error);
      setDownloadStatus(`❌ ${type} direct download failed: ${error}`);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 py-12">
      <div className="mx-auto max-w-4xl px-6">
        <div className="card p-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">
            Download Functionality Test
          </h1>

          <div className="space-y-6">
            {/* Status Display */}
            {downloadStatus && (
              <div className="p-4 rounded-lg bg-blue-50 dark:bg-blue-900/10">
                <p className="text-blue-800 dark:text-blue-200">
                  {downloadStatus}
                </p>
              </div>
            )}

            {/* Test Buttons */}
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-4">
                <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
                  Programmatic Download Tests
                </h2>

                <button
                  onClick={() => testDownload("augment-macos")}
                  className="btn-primary w-full"
                >
                  <Download className="mr-2 h-4 w-4" />
                  Test macOS Download
                </button>

                <button
                  onClick={() => testDownload("augment-github")}
                  className="btn-secondary w-full"
                >
                  <Download className="mr-2 h-4 w-4" />
                  Test Source Download
                </button>
              </div>

              <div className="space-y-4">
                <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
                  Direct Download Tests
                </h2>

                <button
                  onClick={() => directDownload("augment-macos")}
                  className="btn-outline w-full"
                >
                  <Download className="mr-2 h-4 w-4" />
                  Direct macOS Download
                </button>

                <button
                  onClick={() => directDownload("augment-github")}
                  className="btn-outline w-full"
                >
                  <Download className="mr-2 h-4 w-4" />
                  Direct Source Download
                </button>
              </div>
            </div>

            {/* API Test Links */}
            <div className="space-y-4">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
                Direct API Links
              </h2>

              <div className="space-y-2">
                <a
                  href="/api/download?type=augment-macos"
                  target="_blank"
                  className="block p-3 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                >
                  <code className="text-sm">
                    /api/download?type=augment-macos
                  </code>
                </a>

                <a
                  href="/api/download?type=augment-github"
                  target="_blank"
                  className="block p-3 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
                >
                  <code className="text-sm">
                    /api/download?type=augment-github
                  </code>
                </a>
              </div>
            </div>

            {/* Browser Info */}
            <div className="space-y-4">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
                Browser Information
              </h2>

              <div className="p-4 rounded-lg bg-gray-100 dark:bg-gray-800">
                <div className="space-y-2 text-sm">
                  <div>
                    <strong>User Agent:</strong>{" "}
                    {isMounted ? browserInfo.userAgent : "Loading..."}
                  </div>
                  <div>
                    <strong>Platform:</strong>{" "}
                    {isMounted ? browserInfo.platform : "Loading..."}
                  </div>
                  <div>
                    <strong>Current URL:</strong>{" "}
                    {isMounted ? browserInfo.currentUrl : "Loading..."}
                  </div>
                </div>
              </div>
            </div>

            {/* Instructions */}
            <div className="space-y-4">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
                Testing Instructions
              </h2>

              <div className="p-4 rounded-lg bg-yellow-50 dark:bg-yellow-900/10">
                <ul className="space-y-2 text-sm text-yellow-800 dark:text-yellow-200">
                  <li>
                    • Open browser developer tools (F12) to see console logs
                  </li>
                  <li>• Check the Network tab to see download requests</li>
                  <li>• Check your Downloads folder for downloaded files</li>
                  <li>• Try both programmatic and direct download methods</li>
                  <li>
                    • Test the direct API links to verify endpoint functionality
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
