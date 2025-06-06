#!/bin/bash

# Auto-detects GPU presence and builds the correct Dockerfile (GPU or CPU)

# Dockerfile names
GPU_DOCKERFILE="Dockerfile.gpu"
CPU_DOCKERFILE="Dockerfile.cpu"
IMAGE_NAME="openpose-auto"

echo "🔍 Checking for NVIDIA GPU using nvidia-smi..."

if command -v nvidia-smi &> /dev/null; then
    echo "✅ GPU detected. Building with CUDA support."
    DOCKERFILE=$GPU_DOCKERFILE
else
    echo "⚠️ No GPU found. Falling back to CPU-only build."
    DOCKERFILE=$CPU_DOCKERFILE
fi

if [ ! -f "$DOCKERFILE" ]; then
    echo "❌ Dockerfile '$DOCKERFILE' not found!"
    exit 1
fi

echo "🚧 Building Docker image using '$DOCKERFILE'..."
docker build -f "$DOCKERFILE" -t "$IMAGE_NAME" .

if [ $? -eq 0 ]; then
    echo "✅ Docker image '$IMAGE_NAME' built successfully."
else
    echo "❌ Docker build failed."
    exit 1
fi
