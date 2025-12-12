#!/usr/bin/env python3
"""Fix docker-compose.yml to comment out backend service volume mounts"""

with open('docker-compose.yml', 'r') as f:
    lines = f.readlines()

output = []
in_backend_service = False
service_names = ['gateway', 'user_service', 'subscription_service', 'partner_service', 
                 'visit_service', 'payment_service', 'notification_service', 'admin_service']

i = 0
while i < len(lines):
    line = lines[i]
    
    # Check if we're starting a backend service
    for service in service_names:
        if f'  {service}:' in line:
            in_backend_service = True
            break
    
    # Check if we're leaving the service (next service starts)
    if in_backend_service and line.startswith('  ') and ':' in line and 'volumes' not in line and 'command' not in line:
        if not line.strip().startswith('-') and not line.strip().startswith('#'):
            in_backend_service = False
    
    # Comment out volume mounts and reload commands for backend services
    if in_backend_service:
        if '    volumes:' in line:
            output.append('    # volumes:\n')
            i += 1
            # Comment out the next line (the actual volume mount)
            if i < len(lines) and './backend/' in lines[i]:
                output.append('    #   ' + lines[i].lstrip())
                i += 1
                continue
        elif '    command: uvicorn main:app --host 0.0.0.0 --port' in line and '--reload' in line:
            output.append('    # ' + line.lstrip())
            i += 1
            continue
    
    output.append(line)
    i += 1

with open('docker-compose.yml', 'w') as f:
    f.writelines(output)

print("✅ Fixed docker-compose.yml - commented out backend service volume mounts")
