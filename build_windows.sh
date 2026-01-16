#!/bin/bash
set -e

# Check if mingw-w64 linker is installed (required for x86_64-pc-windows-gnu)
if ! command -v x86_64-w64-mingw32-gcc &> /dev/null; then
    echo "Warning: x86_64-w64-mingw32-gcc not found. You may need to install 'mingw-w64' package."
    echo "On Ubuntu/Debian: sudo apt-get install mingw-w64"
    echo "On Fedora: sudo dnf install mingw64-gcc"
    echo "On Arch: sudo pacman -S mingw-w64-gcc"
    echo "Continuing anyway..."
fi

echo "Installing Windows target..."
rustup target add x86_64-pc-windows-gnu

echo "Building for Windows (x86_64-pc-windows-gnu)..."
cargo build --target x86_64-pc-windows-gnu --release

echo "Build complete."
echo "Binary located at: target/x86_64-pc-windows-gnu/release/sunflower-luma.exe"
