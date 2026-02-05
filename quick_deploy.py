#!/usr/bin/env python3
"""
YuvGO Quick Deployment Script
Deploys all services to production server
"""

import subprocess
import os
import sys

# Server configuration
SERVER_IP = "207.180.198.10"
SERVER_USER = "root"
SERVER_PASSWORD = "Shaha2001.Shaha2001"
DEPLOY_DIR = "/opt/yuvgo"

# Colors for output
GREEN = '\033[92m'
YELLOW = '\033[93m'
RED = '\033[91m'
NC = '\033[0m'

def print_step(msg):
    print(f"{GREEN}[+]{NC} {msg}")

def print_warning(msg):
    print(f"{YELLOW}[!]{NC} {msg}")

def print_error(msg):
    print(f"{RED}[x]{NC} {msg}")

def run_command(cmd, cwd=None):
    """Run a shell command"""
    try:
        result = subprocess.run(cmd, shell=True, cwd=cwd, capture_output=True, text=True)
        if result.returncode != 0:
            print_error(f"Command failed: {cmd}")
            print(result.stderr)
            return False
        return True
    except Exception as e:
        print_error(f"Error: {e}")
        return False

def main():
    print("=" * 50)
    print("  YuvGO Production Deployment")
    print("=" * 50)
    print()
    
    # Get project root
    project_root = os.path.dirname(os.path.abspath(__file__))
    
    print_step("Step 1: Creating deployment archive...")
    
    # Files to exclude
    excludes = [
        '--exclude=node_modules',
        '--exclude=__pycache__',
        '--exclude=.git',
        '--exclude=*.pyc',
        '--exclude=.DS_Store',
        '--exclude=.env',
        '--exclude=venv',
        '--exclude=*.log',
    ]
    
    # Create tar archive
    tar_cmd = f"tar -czvf deploy.tar.gz {' '.join(excludes)} docker-compose.prod.yml nginx/ backend/ frontend/ landing-page/ .env.production"
    
    if not run_command(tar_cmd, cwd=project_root):
        print_error("Failed to create archive")
        return 1
    
    print_step("Step 2: Archive created successfully!")
    print()
    
    print_warning("To complete deployment, run these commands:")
    print()
    print(f"  1. Upload to server:")
    print(f"     scp deploy.tar.gz {SERVER_USER}@{SERVER_IP}:{DEPLOY_DIR}/")
    print()
    print(f"  2. SSH to server:")
    print(f"     ssh {SERVER_USER}@{SERVER_IP}")
    print()
    print(f"  3. Deploy on server:")
    print(f"     cd {DEPLOY_DIR}")
    print(f"     tar -xzvf deploy.tar.gz")
    print(f"     cp docker-compose.prod.yml docker-compose.yml")
    print(f"     docker-compose up -d --build")
    print()
    print_step("Deployment package ready!")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
