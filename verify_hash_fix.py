#!/usr/bin/env python3
"""
Verification script to test hash calculation methods and debug version history loading.
"""

import hashlib
import os
import json
from pathlib import Path

def calculate_hash_method1(file_path):
    """Simulate the old calculateHash(for: Data(filePath.path.utf8)) method"""
    path_data = file_path.encode('utf-8')
    hash_obj = hashlib.sha256(path_data)
    return hash_obj.hexdigest()

def calculate_hash_method2(file_path):
    """Simulate the new calculateFilePathHash(filePath:) method"""
    path_data = file_path.encode('utf-8')
    hash_obj = hashlib.sha256(path_data)
    return hash_obj.hexdigest()

def main():
    print("🔍 HASH CALCULATION VERIFICATION")
    print("=" * 50)
    
    # Test file path from the screenshots
    test_file_path = "/Users/saadmomin/Desktop/auto4 copy 3/app_test_1.txt"
    
    print(f"📁 File Path: {test_file_path}")
    print()
    
    # Calculate hashes using both methods
    hash1 = calculate_hash_method1(test_file_path)
    hash2 = calculate_hash_method2(test_file_path)
    
    print(f"🔢 Method 1 (old): {hash1}")
    print(f"🔢 Method 2 (new): {hash2}")
    print(f"✅ Hashes Match: {hash1 == hash2}")
    print()
    
    # Check existing metadata directory structure
    augment_dir = "/Users/saadmomin/Desktop/auto4 copy 3/.augment"
    file_metadata_dir = os.path.join(augment_dir, "file_metadata")
    
    print("📂 EXISTING METADATA STRUCTURE:")
    print("-" * 30)
    
    if os.path.exists(file_metadata_dir):
        for item in os.listdir(file_metadata_dir):
            item_path = os.path.join(file_metadata_dir, item)
            if os.path.isdir(item_path):
                print(f"📁 Hash Directory: {item}")
                print(f"   Full Hash: {item}")
                print(f"   Matches Method 1: {item == hash1}")
                print(f"   Matches Method 2: {item == hash2}")
                
                # List metadata files in this directory
                metadata_files = os.listdir(item_path)
                print(f"   📄 Metadata Files: {len(metadata_files)}")
                
                for metadata_file in metadata_files:
                    if metadata_file.endswith('.json'):
                        metadata_path = os.path.join(item_path, metadata_file)
                        try:
                            with open(metadata_path, 'r') as f:
                                metadata = json.load(f)
                            print(f"      ✅ {metadata_file}: Valid JSON")
                            print(f"         ID: {metadata.get('id', 'N/A')}")
                            print(f"         Timestamp: {metadata.get('timestamp', 'N/A')}")
                            print(f"         Comment: {metadata.get('comment', 'N/A')}")
                        except Exception as e:
                            print(f"      ❌ {metadata_file}: Error - {e}")
                print()
    else:
        print("❌ file_metadata directory not found")
    
    print("🔧 RECOMMENDED ACTIONS:")
    print("-" * 20)
    if hash1 == hash2:
        print("✅ Hash methods are identical - the issue is elsewhere")
        print("🔍 Need to add debugging to Swift code to trace the actual problem")
    else:
        print("❌ Hash methods differ - this confirms the root cause")
        print("🔧 The fix should resolve the issue once properly applied")

if __name__ == "__main__":
    main()
