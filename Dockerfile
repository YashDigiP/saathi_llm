# Use Ubuntu as base
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl gnupg unzip git net-tools wget \
  && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set environment variable for Ollama
ENV OLLAMA_HOST=0.0.0.0

# Create ollama user and set permissions
RUN useradd -m ollama && chown -R ollama:ollama /home/ollama

# Install Google Cloud SDK (for gsutil)
RUN apt-get update && apt-get install -y lsb-release \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
  | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
  && apt-get update && apt-get install -y google-cloud-sdk

# Copy model from GCS bucket to Ollama path
# Replace these with your actual bucket path and model name
RUN mkdir -p /root/.ollama/models && \
  gsutil cp gs://llm_models_ollama/models/ .bin /root/.ollama/models/

# Expose Ollama's default port
EXPOSE 11434

# Set user
USER ollama
WORKDIR /home/ollama

# Healthcheck for Cloud Run
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:11434 || exit 1

# Start Ollama
CMD ["ollama", "serve"]
