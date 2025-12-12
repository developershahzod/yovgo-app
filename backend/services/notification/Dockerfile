FROM python:3.11-slim
WORKDIR /app
RUN apt-get update && apt-get install -y gcc postgresql-client && rm -rf /var/lib/apt/lists/*
COPY shared/requirements.txt /tmp/shared_requirements.txt
RUN pip install --no-cache-dir -r /tmp/shared_requirements.txt
COPY services/notification/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
COPY shared /app/shared
COPY services/notification/main.py /app/
EXPOSE 8006
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8006"]
