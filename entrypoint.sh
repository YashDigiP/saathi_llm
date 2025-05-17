#!/bin/bash
set -e

echo "📥 Downloading models from GCS..."
if gsutil -m cp -r gs://llm_models_ollama/ollama-models/* /root/.ollama/; then
    echo "✅ GCS model copy successful."
else
    echo "❌ GCS model copy failed!" >&2
    exit 1
fi

# Optional: Show what was copied
echo "📂 Copied model contents:"
ls -lh /root/.ollama/models/
