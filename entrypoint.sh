#!/bin/bash
set -e

export MODEL_DIR=/home/ollama/.ollama

echo "📥 Downloading models from GCS..."

mkdir -p "$MODEL_DIR"

if gsutil -m cp -r gs://llm_models_ollama/ollama-models/* "$MODEL_DIR/"; then
    echo "✅ GCS model copy successful."
else
    echo "❌ GCS model copy failed!" >&2
    exit 1
fi

# Fix permissions
chown -R ollama:ollama "$MODEL_DIR"

# Show contents
echo "📂 Copied model contents:"
ls -lh "$MODEL_DIR"/models || echo "⚠️ No models directory found!"
