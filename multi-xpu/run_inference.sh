#!/bin/bash

# -----------------------------
# Model variant selector
# -----------------------------
MODEL_VARIANT="Q4_K_M"
#MODEL_VARIANT="Q3_K_M"
#MODEL_VARIANT="Q2_K_L"

MODEL_PREFIX="gpt-oss-120b-${MODEL_VARIANT}"
MODEL_DIR="/lus/flare/projects/FoundEpidem/siebenschuh/gpt-oss-120b-intel-max-gpu/models"
MODEL_PATH="${MODEL_DIR}/${MODEL_PREFIX}-00001-of-00002.gguf"

echo "Using MODEL_VARIANT=${MODEL_VARIANT}"
echo "Resolved MODEL_PATH=${MODEL_PATH}"

# -----------------------------
# Inference
# -----------------------------
unset ONEAPI_DEVICE_SELECTOR
export FI_PROVIDER=tcp

mpirun -n 24 python infer_equations_llama_mpi.py \
    --src "/lus/flare/projects/FoundEpidem/siebenschuh/DocDiffuser/data/expressions/gptoss120b_SMALL_input/" \
    --dst "/lus/flare/projects/FoundEpidem/siebenschuh/DocDiffuser/data/expressions/gptoss120b_NEW_SMALL_inferred/" \
    --model "${MODEL_PATH}" \
    --ctx 1024

