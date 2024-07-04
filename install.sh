#!/bin/bash

REPO_URL="https://github.com/Fun117/zshmgr"
BRANCH="0.0.1-beta"

INSTALL_DIR="${HOME}/.zshmgr"
BIN_FILE="zshmgr.zsh"
COMMAND_NAME="zshmgr"

# Function to clean up and exit with error
function cleanup_and_exit {
  echo "Installation failed. Cleaning up..."
  rm -rf $INSTALL_DIR
  rm -rf $TEMP_DIR
  exit 1
}

# Detect OS
OS=$(uname -s)

case $OS in
Linux* | Darwin*)
  BIN_DIR="/usr/local/bin"
  ;;
MINGW* | MSYS* | CYGWIN*)
  BIN_DIR="/usr/bin"
  ;;
*)
  echo "Unsupported OS: $OS"
  exit 1
  ;;
esac

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
  cp -r $file $INSTALL_DIR/ || cleanup_and_exit
done

# Copy configs folder to the installation directory
cp -r configs $INSTALL_DIR/ || cleanup_and_exit

# Create packages directory in the installation directory
mkdir -p $INSTALL_DIR/packages || cleanup_and_exit

# Set execute permissions for zshmgr.zsh
chmod +x $INSTALL_DIR/$BIN_FILE || cleanup_and_exit

# Copy zshmgr.zsh to BIN_DIR and create a symlink
sudo cp $INSTALL_DIR/$BIN_FILE $BIN_DIR/$COMMAND_NAME || cleanup_and_exit

# Add to PATH if not already present
if ! grep -q 'export PATH=$PATH:$HOME/.zshmgr' $HOME/.zshrc; then
  echo 'export PATH=$PATH:$HOME/.zshmgr' >>$HOME/.zshrc
fi

# Clean up temporary directory
cd ~
rm -rf $TEMP_DIR

# Delete the install script
rm -- "$0"

echo "zshmgr has been installed successfully."
