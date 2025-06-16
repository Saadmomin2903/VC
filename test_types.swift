#!/usr/bin/env swift

import Foundation

// Simple test to verify types are working
print("Testing Augment types...")

// Test URL creation
let testURL = URL(fileURLWithPath: "/Users/test")
print("✅ URL creation works: \(testURL)")

// Test UUID creation
let testUUID = UUID()
print("✅ UUID creation works: \(testUUID)")

// Test Date creation
let testDate = Date()
print("✅ Date creation works: \(testDate)")

print("✅ Basic Swift types are working!")
print("Note: To test Augment-specific types, use Xcode build system.")
