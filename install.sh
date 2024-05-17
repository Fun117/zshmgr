#!/bin/bash

REPO_URL="https://github.com/yourusername/zshmgr"
INSTALL_DIR="${HOME}/.zshmgr"

# Clone necessary files into a temporary directory
TEMP_DIR=$(mktemp -d)
git clone --depth 1 --filter=blob:none --sparse $REPO_URL $TEMP_DIR
cd $TEMP_DIR
git sparse-checkout init --cone
git sparse-checkout set packages .gitignore install.sh packages.json README.md zshmgr.zsh

# Create installation directory if it doesn't exist
mkdir -p $INSTALL_DIR

# Copy necessary files to the installation directory
cp -r packages $INSTALL_DIR/
cp .gitignore install.sh packages.json README.md zshmgr.zsh $INSTALL_DIR/

# Add to PATH
if ! grep -q 'export PATH=$PATH:$HOME/.zshmgr' $HOME/.zshrc; then
  echo 'export PATH=$PATH:$HOME/.zshmgr' >> $HOME/.zshrc
fi

# Clean up
cd ~
rm -rf $TEMP_DIR

echo "zshmgr has been installed successfully."
