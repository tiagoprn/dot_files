#!/usr/bin/env bash
# ============================================================
# compile-whisper-cpp.sh
#
# Build ggml-org/whisper.cpp from source with Vulkan support
# so the Intel Iris Xe iGPU is used instead of the CPU-only
# AUR build.
#
#   * Clones (or updates) the repo into /opt/src/whisper.cpp
#   * Compiles with -DWHISPER_VULKAN=ON
#   * Symlinks the resulting whisper-cli into /usr/bin
#
# Safe to re-run: it pulls latest and rebuilds.
# ============================================================
set -euo pipefail

REPO_DIR="/opt/src/whisper.cpp"
BUILD_DIR="${REPO_DIR}/build"
BIN_SOURCE="${BUILD_DIR}/bin/whisper-cli"
BIN_SYMLINK="/usr/bin/whisper-cli"
REPO_URL="https://github.com/ggml-org/whisper.cpp.git"

MODEL="large-v3-turbo-q8_0"
MODEL_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-${MODEL}.bin"
MODEL_DIR="/opt/src/whisper.models"
MODEL_FILE="${MODEL_DIR}/ggml-${MODEL}.bin"

# ------------------------------------------------------------
# 0. Sanity checks
# ------------------------------------------------------------
for tool in git cmake ninja gcc g++; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "ERROR: required tool '$tool' not found." >&2
        exit 1
    fi
done

if ! command -v glslc >/dev/null 2>&1; then
    echo "ERROR: 'glslc' (shaderc) not found. Vulkan build needs it." >&2
    exit 1
fi

# Make sure /opt/src exists and is writable by us.
if [ ! -d "/opt/src" ]; then
    echo "Creating /opt/src (needs write permission)."
    sudo mkdir -p /opt/src
    sudo chown "$USER":"$USER" /opt/src /opt/src 2>/dev/null || true
fi

# ------------------------------------------------------------
# 1. Clone or update the repository
# ------------------------------------------------------------
if [ ! -d "${REPO_DIR}/.git" ]; then
    echo "== Cloning whisper.cpp into ${REPO_DIR}"
    git clone --depth 1 "$REPO_URL" "$REPO_DIR"
else
    echo "== Updating existing clone in ${REPO_DIR}"
    git -C "$REPO_DIR" pull --ff-only
fi

# ------------------------------------------------------------
# 2. Configure the build with Vulkan enabled
# ------------------------------------------------------------
echo "== Configuring CMake (Vulkan) in ${BUILD_DIR}"
cmake -S "$REPO_DIR" -B "$BUILD_DIR" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DGGML_VULKAN=ON \
    -DWHISPER_BUILD_TESTS=OFF

# ------------------------------------------------------------
# 3. Compile
# ------------------------------------------------------------
echo "== Compiling (timing this)..."
start_time=$(date +%s)
cmake --build "$BUILD_DIR" --config Release
end_time=$(date +%s)
elapsed=$((end_time - start_time))
echo "== Compile finished in ${elapsed} seconds"

if [ ! -f "$BIN_SOURCE" ]; then
    echo "ERROR: build did not produce ${BIN_SOURCE}" >&2
    exit 1
fi

# ------------------------------------------------------------
# 4. Symlink the binary into /usr/bin
# ------------------------------------------------------------
echo "== Linking ${BIN_SYMLINK} -> ${BIN_SOURCE}"
sudo ln -sf "$BIN_SOURCE" "$BIN_SYMLINK"

# ------------------------------------------------------------
# 5. Download the multilingual model (PT-BR + EN)
# ------------------------------------------------------------
echo "== Ensuring model ${MODEL} is available"
mkdir -p "$MODEL_DIR"
if [ ! -f "$MODEL_FILE" ]; then
    echo "   Downloading ${MODEL} ($(command -v wget >/dev/null 2>&1 && echo wget || echo curl))..."
    if command -v wget >/dev/null 2>&1; then
        wget -q --show-progress -O "$MODEL_FILE" "$MODEL_URL"
    else
        curl -L --progress-bar -o "$MODEL_FILE" "$MODEL_URL"
    fi
else
    echo "   Model already present: $MODEL_FILE"
fi

# Sanity: file is not empty/HTML error page
if [ ! -s "$MODEL_FILE" ]; then
    echo "ERROR: model download produced an empty file." >&2
    exit 1
fi

# ------------------------------------------------------------
# 6. Summary
# ------------------------------------------------------------
echo
echo "== Done. Verify with:"
echo "    whisper-cli --help"
echo "    whisper-cli -m ${MODEL_FILE} -f <audio>  (watch for 'ggml_vulkan: Found 1 Vulkan devices')"

echo
echo "== Done. Verify with:"
echo "    whisper-cli --help"
echo "    whisper-cli -m <model> -f <audio>  (watch for 'ggml_vulkan: Found 1 Vulkan devices')"