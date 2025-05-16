#!/bin/bash
echo "Downloading models from GCS..."
gsutil -m cp -r gs://llm_models_ollama/ollama-models/* /root/.ollama/models/
