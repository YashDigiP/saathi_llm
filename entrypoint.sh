#!/bin/bash
set -e

# ✅ Start Ollama server
echo "📋 Starting Ollama server:"
ollama serve || echo "⚠️ Failed to start server."

ollama pull mistral || echo "⚠️ Failed to pull mistral."

# ✅ Show models available to Ollama
echo "📋 Listing available Ollama models:"
ollama list || echo "⚠️ Failed to list models."
