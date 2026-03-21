#!/usr/bin/env bash

set -e  # exit on error

echo "Starting setup..."

# --- Check if Docker is installed ---
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

echo "Docker is installed"

# --- Check if Docker daemon is running ---
if ! docker info &> /dev/null; then
    echo "Docker daemon is not running."
    echo "Please start Docker and try again."
    exit 1
fi

echo "Docker daemon is running"

# --- Make scripts executable ---
echo "Setting execute permissions..."
chmod +x run_soundcloud_downloader.sh


# --- Create useful directories (if needed) ---
echo "Creating directories..."
mkdir -p logs
mkdir -p tracks
mkdir -p archive

# --- Build Docker image ---
IMAGE_NAME="scdl"

echo "Building Docker image: $IMAGE_NAME"
docker build -t $IMAGE_NAME .

echo "Docker image built successfully"

# --- Final message ---
echo ""
echo "Setup complete!"
echo "You can now run: ./run_soundcloud_downloader.sh (from terminal or cron job)"
