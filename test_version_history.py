#!/usr/bin/env python3

import os
import json
import tempfile
import shutil
from datetime import datetime
import uuid

def test_version_history_structure():
    """Test the version history data structure and identify potential issues."""
    
    print("🔍 Testing Version History Structure...")
    
    # Create a temporary test space
    temp_dir = tempfile.mkdtemp(prefix="augment_test_")
    test_space = os.path.join(temp_dir, "TestSpace")
    os.makedirs(test_space, exist_ok=True)
    
    print(f"📁 Created test space: {test_space}")
    
    try:
        # Simulate the .augment directory structure
        augment_dir = os.path.join(test_space, ".augment")
        os.makedirs(augment_dir, exist_ok=True)
        
        # Create subdirectories
        subdirs = ["versions", "file_versions", "file_metadata", "snapshots"]
        for subdir in subdirs:
            os.makedirs(os.path.join(augment_dir, subdir), exist_ok=True)
        
        print("✅ Created .augment directory structure")
        
        # Create test files
        test_file1 = os.path.join(test_space, "test1.txt")
        test_file2 = os.path.join(test_space, "test2.txt")
        
        with open(test_file1, 'w') as f:
            f.write("This is test file 1")
        with open(test_file2, 'w') as f:
            f.write("This is test file 2")
        
        print("✅ Created test files")
        
        # Simulate version metadata creation
        file_metadata_dir = os.path.join(augment_dir, "file_metadata")
        
        # Create file path hashes (simulating the hash function)
        import hashlib
        
        def calculate_file_path_hash(file_path):
            return hashlib.sha256(file_path.encode()).hexdigest()[:16]
        
        # Create metadata for test1.txt
        file1_hash = calculate_file_path_hash(test_file1)
        file1_metadata_dir = os.path.join(file_metadata_dir, file1_hash)
        os.makedirs(file1_metadata_dir, exist_ok=True)
        
        # Create some version metadata files
        for i in range(3):
            version_id = str(uuid.uuid4())
            version_metadata = {
                "id": version_id,
                "filePath": test_file1,
                "timestamp": datetime.now().isoformat() + "Z",
                "size": 19,
                "comment": f"Version {i+1}",
                "contentHash": f"hash_{i+1}",
                "storagePath": os.path.join(augment_dir, "file_versions", file1_hash, f"{version_id}.data")
            }
            
            metadata_file = os.path.join(file1_metadata_dir, f"{version_id}.json")
            with open(metadata_file, 'w') as f:
                json.dump(version_metadata, f, indent=2)
            
            # Create the actual version data file
            version_storage_dir = os.path.join(augment_dir, "file_versions", file1_hash)
            os.makedirs(version_storage_dir, exist_ok=True)
            version_data_file = os.path.join(version_storage_dir, f"{version_id}.data")
            with open(version_data_file, 'w') as f:
                f.write(f"This is test file 1 - version {i+1}")
        
        print(f"✅ Created 3 versions for test1.txt in {file1_metadata_dir}")
        
        # Create metadata for test2.txt (but no versions)
        file2_hash = calculate_file_path_hash(test_file2)
        file2_metadata_dir = os.path.join(file_metadata_dir, file2_hash)
        os.makedirs(file2_metadata_dir, exist_ok=True)
        
        print(f"✅ Created metadata directory for test2.txt (no versions): {file2_metadata_dir}")
        
        # Now test the structure
        print("\n🔍 Analyzing structure:")
        
        # Check .augment directory
        augment_contents = os.listdir(augment_dir)
        print(f"   .augment contents: {augment_contents}")
        
        # Check file_metadata directory
        metadata_contents = os.listdir(file_metadata_dir)
        print(f"   file_metadata contents: {metadata_contents}")
        
        # Check each file's metadata
        for file_hash in metadata_contents:
            file_hash_dir = os.path.join(file_metadata_dir, file_hash)
            if os.path.isdir(file_hash_dir):
                versions = os.listdir(file_hash_dir)
                print(f"   {file_hash} has {len(versions)} version files: {versions}")
                
                # Read and validate each version file
                for version_file in versions:
                    if version_file.endswith('.json'):
                        version_path = os.path.join(file_hash_dir, version_file)
                        try:
                            with open(version_path, 'r') as f:
                                version_data = json.load(f)
                            print(f"     ✅ {version_file}: Valid JSON")
                            print(f"        Comment: {version_data.get('comment', 'No comment')}")
                            print(f"        Storage path: {version_data.get('storagePath', 'No path')}")
                            
                            # Check if storage file exists
                            storage_path = version_data.get('storagePath')
                            if storage_path and os.path.exists(storage_path):
                                print(f"        ✅ Storage file exists")
                            else:
                                print(f"        ❌ Storage file missing: {storage_path}")
                                
                        except json.JSONDecodeError as e:
                            print(f"     ❌ {version_file}: Invalid JSON - {e}")
                        except Exception as e:
                            print(f"     ❌ {version_file}: Error - {e}")
        
        # Test the version loading logic (simulate what VersionControl.getVersions does)
        print("\n🔍 Simulating version loading:")
        
        def simulate_load_file_versions(file_path):
            file_hash = calculate_file_path_hash(file_path)
            file_metadata_dir_path = os.path.join(file_metadata_dir, file_hash)
            
            if not os.path.exists(file_metadata_dir_path):
                print(f"   No metadata directory for {os.path.basename(file_path)}")
                return []
            
            versions = []
            try:
                metadata_files = os.listdir(file_metadata_dir_path)
                for file in metadata_files:
                    if file.endswith('.json'):
                        file_path_full = os.path.join(file_metadata_dir_path, file)
                        try:
                            with open(file_path_full, 'r') as f:
                                version_data = json.load(f)
                            versions.append(version_data)
                        except Exception as e:
                            print(f"   Error loading {file}: {e}")
                
                # Sort by timestamp (newest first)
                versions.sort(key=lambda x: x.get('timestamp', ''), reverse=True)
                return versions
                
            except Exception as e:
                print(f"   Error reading metadata directory: {e}")
                return []
        
        # Test loading versions for both files
        test1_versions = simulate_load_file_versions(test_file1)
        test2_versions = simulate_load_file_versions(test_file2)
        
        print(f"   test1.txt: Found {len(test1_versions)} versions")
        for i, version in enumerate(test1_versions):
            print(f"     Version {i+1}: {version.get('comment', 'No comment')}")
        
        print(f"   test2.txt: Found {len(test2_versions)} versions")
        for i, version in enumerate(test2_versions):
            print(f"     Version {i+1}: {version.get('comment', 'No comment')}")
        
        # Identify potential issues
        print("\n🚨 Potential Issues Analysis:")
        
        issues = []
        
        # Check if any files have no versions
        if len(test2_versions) == 0:
            issues.append("Files with no versions will show empty version history")
        
        # Check for missing storage files
        for version in test1_versions:
            storage_path = version.get('storagePath')
            if storage_path and not os.path.exists(storage_path):
                issues.append(f"Missing storage file: {storage_path}")
        
        # Check for invalid JSON
        # (already checked above)
        
        if issues:
            for issue in issues:
                print(f"   ❌ {issue}")
        else:
            print("   ✅ No obvious issues found in test data")
        
        print(f"\n📊 Summary:")
        print(f"   - Test space created: {test_space}")
        print(f"   - Files created: 2")
        print(f"   - Versions created: {len(test1_versions)} for test1.txt, {len(test2_versions)} for test2.txt")
        print(f"   - Issues found: {len(issues)}")
        
    finally:
        # Cleanup
        print(f"\n🧹 Cleaning up: {temp_dir}")
        shutil.rmtree(temp_dir)

if __name__ == "__main__":
    test_version_history_structure()
