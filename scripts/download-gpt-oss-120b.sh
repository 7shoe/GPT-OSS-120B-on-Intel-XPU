#!/bin/bash
set -euo pipefail

echo "=== Preparing GPT-OSS-120B GGUF shards ==="

MODEL_DIR="../models"
mkdir -p "$MODEL_DIR"
cd "$MODEL_DIR"

# -------------------------------------------------------------------
# Helper: download if missing or clearly incomplete (< 1 GiB)
# -------------------------------------------------------------------
download_if_needed() {
  local fname="$1"
  local url="$2"
  local min_bytes=$((1024 * 1024 * 1024))  # 1 GiB

  if [[ -f "$fname" ]]; then
    # Get size
    local size_bytes
    size_bytes=$(wc -c < "$fname")
    local size_human
    size_human=$(du -h "$fname" | cut -f1)

    if (( size_bytes < min_bytes )); then
      echo "[WARN] $fname exists but is small (${size_human}, ${size_bytes} bytes) – assuming failed/incomplete download."
      echo "       Deleting and re-downloading..."
      rm -f "$fname"
    else
      echo "[OK]   $fname already present (${size_human}), skipping download."
      return 0
    fi
  fi

  echo "[DL ] Downloading $fname ..."
  wget -O "$fname" "$url"
  local size_human_after
  size_human_after=$(du -h "$fname" | cut -f1)
  echo "[OK]  Finished $fname (${size_human_after})"
}

# -------------------------------------------------------------------
# Q4_K_M shards
# -------------------------------------------------------------------
echo
echo "=== Downloading GPT-OSS-120B Q4_K_M GGUF shards ==="

download_if_needed \
  "gpt-oss-120b-Q4_K_M-00001-of-00002.gguf" \
  "https://huggingface.co/unsloth/gpt-oss-120b-GGUF/resolve/main/Q4_K_M/gpt-oss-120b-Q4_K_M-00001-of-00002.gguf"

download_if_needed \
  "gpt-oss-120b-Q4_K_M-00002-of-00002.gguf" \
  "https://huggingface.co/unsloth/gpt-oss-120b-GGUF/resolve/main/Q4_K_M/gpt-oss-120b-Q4_K_M-00002-of-00002.gguf"

echo "=== Q4_K_M shards present ==="
ls -lh gpt-oss-120b-Q4_K_M-*.gguf || echo "(none?)"

# -------------------------------------------------------------------
# Q3_K_M shards
#  (Note: URLs point to Q3_K_M, not Q4_K_M)
# -------------------------------------------------------------------
echo
echo "=== Downloading GPT-OSS-120B Q3_K_M GGUF shards ==="

download_if_needed \
  "gpt-oss-120b-Q3_K_M-00001-of-00002.gguf" \
  "https://huggingface.co/unsloth/gpt-oss-120b-GGUF/resolve/main/Q3_K_M/gpt-oss-120b-Q3_K_M-00001-of-00002.gguf"

download_if_needed \
  "gpt-oss-120b-Q3_K_M-00002-of-00002.gguf" \
  "https://huggingface.co/unsloth/gpt-oss-120b-GGUF/resolve/main/Q3_K_M/gpt-oss-120b-Q3_K_M-00002-of-00002.gguf"

echo "=== Q3_K_M shards present ==="
ls -lh gpt-oss-120b-Q3_K_M-*.gguf || echo "(none?)"

echo
echo "=== All done ==="

