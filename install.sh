#!/bin/bash

REPO_URL="https://github.com/Fun117/zshmgr"
BRANCH="alpha-202405202020"

INSTALL_DIR="${HOME}/.zshmgr"
BIN_DIR="/usr/local/bin"
BIN_FILE="zshmgr.zsh"
COMMAND_NAME="zshmgr"

# Function to clean up and exit with error
function cleanup_and_exit {
  echo "Installation failed. Cleaning up..."
  rm -rf $INSTALL_DIR
  rm -rf $TEMP_DIR
  exit 1
}

# Clone necessary files into a temporary directory from the specified branch
TEMP_DIR=$(mktemp -d)
git clone --depth 1 --branch $BRANCH $REPO_URL $TEMP_DIR || cleanup_and_exit
cd $TEMP_DIR || cleanup_and_exit

# Ensure that only the required files are copied
FILES_TO_COPY=("install.sh" "README.md" "zshmgr.zsh")

# Create installation directory if it doesn't exist
mkdir -p $INSTALL_DIR || cleanup_and_exit

# Copy necessary files to the installation directory
for file in "${FILES_TO_COPY[@]}"; do
  cp $file $INSTALL_DIR/ || cleanup_and_exit
done

# Create packages directory in the installation directory
mkdir -p $INSTALL_DIR/packages || cleanup_and_exit

# Set execute permissions for zshmgr.zsh
chmod +x $INSTALL_DIR/$BIN_FILE || cleanup_and_exit

# Copy zshmgr.zsh to /usr/local/bin and create a symlink
sudo cp $INSTALL_DIR/$BIN_FILE $BIN_DIR/$COMMAND_NAME || cleanup_and_exit

# Add to PATH
if ! grep -q 'export PATH=$PATH:$HOME/.zshmgr' $HOME/.zshrc; then
  echo 'export PATH=$PATH:$HOME/.zshmgr' >> $HOME/.zshrc
fi

# Clean up temporary directory
cd ~
rm -rf $TEMP_DIR

# Delete the install script
rm -- "$0"

echo "zshmgr has been installed successfully."
