FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl gnupg unzip git net-tools wget python3-pip && \
  rm -rf /var/lib/apt/lists/*

# Install gsutil via Google Cloud SDK
RUN curl -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-sdk


# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set Ollama to listen on all interfaces
ENV OLLAMA_HOST=0.0.0.0

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create ollama user
RUN useradd -m ollama && chown -R ollama:ollama /home/ollama

# Switch to ollama user
USER ollama
WORKDIR /home/ollama

EXPOSE 11434

# Healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:11434 || exit 1

# Start Ollama via custom script
CMD ["/entrypoint.sh"]
