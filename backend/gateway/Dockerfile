FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    ca-certificates \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install requirements
COPY shared/requirements.txt /tmp/shared_requirements.txt
RUN pip install --no-cache-dir -r /tmp/shared_requirements.txt

COPY gateway/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy shared module
COPY shared /app/shared

# Copy gateway application
COPY gateway/main.py /app/
COPY gateway/routes /app/routes

# Expose port
EXPOSE 8000

# Run application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
