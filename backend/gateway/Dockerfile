FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy shared requirements
COPY shared/requirements.txt /app/shared_requirements.txt
RUN pip install --no-cache-dir -r /app/shared_requirements.txt

# Copy application
COPY gateway/ /app/
COPY shared /app/shared

# Expose port
EXPOSE 8000

# Run application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
