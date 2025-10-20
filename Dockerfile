# Use a lightweight Python image
FROM python:slim

# Set environment variables to prevent Python from writing .pyc files & Ensure Python output is not buffered
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Install system dependencies required for building ML packages
# build-essential, gcc, g++, make: C/C++ compiler toolchain for packages like statsmodels
# python3-dev: Python header files needed for compiling C extensions
# cmake: Build tool required by pyarrow
# libarrow-dev: C++ source libraries required by pyarrow
# libgomp1: Dependency for libraries like LightGBM/XGBoost
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# Expose the port that Flask will run on
EXPOSE 5000

# Command to run the app
CMD ["python", "app.py"]