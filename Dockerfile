# Use a stable Debian-based Python image (Bookworm)
FROM python:3.11-slim-bookworm

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Install system dependencies
# - Add prerequisites for adding new APT repositories
# - Add Apache Arrow GPG key and APT repository for Debian Bookworm
# - Install build tools (gcc, g++, make, cmake, python3-dev)
# - Install libarrow-dev from the official Arrow repository
# - Install libgomp1
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && curl -s https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr '[:upper:]' '[:lower:]')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb -o /tmp/apache-arrow-apt-source-latest.deb \
    && apt-get install -y /tmp/apache-arrow-apt-source-latest.deb \
    && rm /tmp/apache-arrow-apt-source-latest.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        make \
        python3-dev \
        libgomp1 \
        cmake \
        libarrow-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the application code
COPY . .

# Install the package in editable mode
RUN pip install --no-cache-dir -e .

# Train the model before running the application
RUN python pipeline/training_pipeline.py

# Expose the port
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]