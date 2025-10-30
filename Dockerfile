# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

WORKDIR /app

# install required tools for download/build
RUN apt-get update && apt-get install -y curl tar ca-certificates && rm -rf /var/lib/apt/lists/*

# Download Ollama binary and install
RUN curl -L -o ollama.tgz https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tgz \
    && tar -xzf ollama.tgz \
    && mv $(find . -type f -name "ollama*" 2>/dev/null | head -n 1) /usr/local/bin/ollama \
    && chmod +x /usr/local/bin/ollama \
    && rm -rf ollama.tgz

# Copy Modelfile and build a small model named "mini-test"
COPY Modelfile /app/Modelfile
RUN /usr/local/bin/ollama create mini-test -f /app/Modelfile || true

# Expose Ollama port
# Expose Ollama’s default port
EXPOSE 11434

# Start Ollama server (no --host flag)
CMD ["/usr/local/bin/ollama", "serve"]


