FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl gnupg unzip git net-tools \
  google-cloud-sdk \
  && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Create model directory
RUN mkdir -p /root/.ollama/models

# Copy models from GCS during build
COPY download_models.sh /tmp/download_models.sh
RUN chmod +x /tmp/download_models.sh && /tmp/download_models.sh

EXPOSE 11434

CMD ["ollama", "serve"]
