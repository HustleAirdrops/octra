#!/bin/bash
set -e

# Go to home
cd ~

# Install Rust (if not already)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Clone repo (skip if already exists)
if [ ! -d "$HOME/ocs01-test" ]; then
    git clone https://github.com/octra-labs/ocs01-test.git
fi

cd ~/ocs01-test

# Build with cargo
cargo build --release

# Copy contract interface
cp EI/exec_interface.json .

# Copy wallet.json if it exists
if [ -f ~/octra_pre_client/wallet.json ]; then
    cp ~/octra_pre_client/wallet.json .
    echo "✅ wallet.json copied from ~/octra_pre_client/ to ~/ocs01-test/"
elif [ -f /workspaces/octra_pre_client/wallet.json ]; then
    cp /workspaces/octra_pre_client/wallet.json .
    echo "✅ wallet.json copied from /workspaces/octra_pre_client/ to ~/ocs01-test/"
else
    echo "⚠️ wallet.json not found in ~/octra_pre_client/ or /workspaces/octra_pre_client/"
fi


echo "🚀 Setup complete. You are now in ~/ocs01-test/"
cd ~/ocs01-test && ./target/release/ocs01-test
