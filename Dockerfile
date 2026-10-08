# ==========================================
# STAGE 1: Build the Vite + React Frontend
# ==========================================
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

COPY frontend/cloud_media_storage/package*.json ./
RUN npm install

COPY frontend/cloud_media_storage/ ./
RUN npm run build 

# ==========================================
# STAGE 2: Build the Django Backend
# ==========================================
# FIX: Changed from 3.11 to 3.12 to support Django 6.1+
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install development libraries needed for image processing & DB drivers
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libwebp-dev \
    libtiff-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

COPY backend/cloud_storage/requirements.txt /app/

# Upgrade pip first to ensure modern wheels install smoothly
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir whitenoise
RUN pip install --no-cache-dir whitenoise gunicorn

COPY backend/cloud_storage/ /app/

# Copy React build files from Vite's "dist" folder into Django's static directory
RUN mkdir -p /app/static
COPY --from=frontend-builder /app/frontend/dist /app/static/

RUN python manage.py collectstatic --no-input

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && gunicorn cloud_storage.wsgi:application --bind 0.0.0.0:8000"]
