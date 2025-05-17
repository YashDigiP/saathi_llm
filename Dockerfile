# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl gnupg unzip git net-tools \
  && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set environment variable so Ollama listens on all interfaces
ENV OLLAMA_HOST=0.0.0.0

# Create ollama user and give appropriate ownership
RUN useradd -m ollama && chown -R ollama:ollama /home/ollama

# Set environment variables
ENV PATH="/usr/local/bin:${PATH}"
ENV PYTHONUNBUFFERED=1

# Switch to ollama user
USER ollama
WORKDIR /home/ollama

# Expose Ollama port
EXPOSE 11434

# Healthcheck (optional, helps Cloud Run verify container health)
HEALTHCHECK --interval=30s --timeout=30s --retries=3 \
  CMD netstat -an | grep 11434 || exit 1

# CMD ["/entrypoint.sh"]

# Run ollama serve and pull the mistral model after a short wait
CMD ["sh", "-c", "ollama serve & sleep 5"]
