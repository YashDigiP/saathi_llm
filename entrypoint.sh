if [ ! -d "/home/ollama/.ollama/models" ]; then
  echo "⏬ Downloading models from GCS..."
  gsutil cp -r gs://your-bucket/.ollama /home/ollama/
  chown -R ollama:ollama /home/ollama/.ollama
else
  echo "✅ Models already loaded, skipping download."
fi
