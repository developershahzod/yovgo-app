#!/usr/bin/env python3
"""Final fix for docker-compose.yml - remove all backend service volume mounts"""

import re

with open('docker-compose.yml', 'r') as f:
    content = f.read()

# List of backend services
backend_services = [
    'user_service',
    'subscription_service', 
    'partner_service',
    'visit_service',
    'payment_service',
    'notification_service',
    'admin_service'
]

# For each service, remove the volumes section
for service in backend_services:
    # Pattern to match the service block and its volumes section
    pattern = rf'(  {service}:.*?)(    volumes:\n      - \./backend/services/{service.replace("_service", "")}:/app\n)'
    replacement = r'\1    # volumes:\n    #   - ./backend/services/' + service.replace('_service', '') + r':/app\n'
    content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    
    # Also comment out the reload command
    pattern = rf'(  {service}:.*?)(    command: uvicorn main:app --host 0\.0\.0\.0 --port \d+ --reload\n)'
    replacement = r'\1    # command: uvicorn main:app --host 0.0.0.0 --port XXXX --reload\n'
    content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('docker-compose.yml', 'w') as f:
    f.write(content)

print("✅ Fixed docker-compose.yml - removed all backend service volume mounts")
