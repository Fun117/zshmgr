#!/bin/bash

# Function to load configuration from config.json and expand ~ to $HOME
function load_config() {
  local config_file="/configs/config.json"
  if [[ -f $config_file ]]; then
    config_content=$(cat $config_file)
    config_install_dir=$(echo $config_content | jq -r '.install_dir' | sed "s|~|$HOME|g")
    config_bin_dir=$(echo $config_content | jq -r '.bin_dir')
    config_command_name=$(echo $config_content | jq -r '.command_name')
  else
    echo "Configuration file not found."
    exit 1
  fi
}

# Load configuration
load_config

INSTALL_DIR=$config_install_dir
BIN_DIR=$config_bin_dir
COMMAND_NAME=$config_command_name

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
