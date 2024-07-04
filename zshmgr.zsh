#!/bin/zsh

# Function to load configuration from config.json and expand ~ to $HOME
function load_config() {
    local config_file="${HOME}/.zshmgr/configs/config.json"
    if [[ -f $config_file ]]; then
        config_content=$(cat $config_file)
        config_version=$(echo $config_content | jq -r '.version')
        config_help_file=$(echo $config_content | jq -r '.help_file' | sed "s|~|$HOME|g")
        config_package_file=$(echo $config_content | jq -r '.package_file' | sed "s|~|$HOME|g")
        config_package_dir=$(echo $config_content | jq -r '.package_dir' | sed "s|~|$HOME|g")
        config_install_dir=$(echo $config_content | jq -r '.install_dir' | sed "s|~|$HOME|g")
        config_command_name=$(echo $config_content | jq -r '.command_name')
    else
        echo "Configuration file not found."
        exit 1
    fi
}

# Load configuration
load_config

VERSION=$config_version
HELP_FILE=$config_help_file
PACKAGE_FILE=$config_package_file
PACKAGE_DIR=$config_package_dir
INSTALL_DIR=$config_install_dir
COMMAND_NAME=$config_command_name

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

# Load package information
function load_packages() {
    if [[ -f $PACKAGE_FILE ]]; then
        packages=$(cat $PACKAGE_FILE)
    else
        packages="{}"
    fi
}

# Save package information
function save_packages() {
    echo $packages | jq '.' >$PACKAGE_FILE
}

# Show help message
function show_help() {
    if [[ -f $HELP_FILE ]]; then
        cat $HELP_FILE
    else
        echo "Help file not found."
    fi
}

# Show version
function show_version() {
    echo "zshmgr version $VERSION"
}

# Update zshmgr itself
function update_zshmgr() {
    echo "Updating zshmgr..."
    local temp_dir=$(mktemp -d)
    git clone --depth 1 --branch main https://github.com/Fun117/zshmgr $temp_dir
    cp $temp_dir/zshmgr.zsh $INSTALL_DIR/zshmgr.zsh
    sudo cp $INSTALL_DIR/zshmgr.zsh $BIN_DIR/zshmgr
    rm -rf $temp_dir
    echo "zshmgr has been updated to the latest version."
}

# Uninstall zshmgr itself
function uninstall_zshmgr() {
    echo "Uninstall zshmgr..."
    rm -rf $INSTALL_DIR
    sudo rm -f $BIN_DIR/$COMMAND_NAME
    echo "zshmgr has been uninstall."
}

# Install packages
function install_package() {
    local package_name=$1
    if [[ -z $package_name ]]; then
        echo "Error: No package name provided."
        return 1
    fi
    if [[ $(echo $packages | jq --arg name $package_name 'has($name)') == "true" ]]; then
        echo "Package $package_name is already installed."
        return 0
    fi
    echo "Installing $package_name..."
    local package_url="https://github.com/$package_name.git"
    git clone $package_url $PACKAGE_DIR/$package_name
    if [[ -f $PACKAGE_DIR/$package_name/install.sh ]]; then
        echo "Running install script for $package_name..."
        chmod +x $PACKAGE_DIR/$package_name/install.sh
        (cd $PACKAGE_DIR/$package_name && ./install.sh)
    fi
    packages=$(echo $packages | jq --arg name $package_name '.[$name] = {}')
    save_packages
    echo "$package_name has been installed."
}

# Uninstall packages
function uninstall_package() {
    local package_name=$1
    if [[ -z $package_name ]]; then
        echo "Error: No package name provided."
        return 1
    fi
    echo "Uninstalling $package_name..."
    if [[ -f $PACKAGE_DIR/$package_name/uninstall.sh ]]; then
        echo "Running uninstall script for $package_name..."
        chmod +x $PACKAGE_DIR/$package_name/uninstall.sh
        (cd $PACKAGE_DIR/$package_name && ./uninstall.sh)
    fi
    rm -rf $PACKAGE_DIR/$package_name
    packages=$(echo $packages | jq --arg name $package_name 'del(.[$name])')
    save_packages
    echo "$package_name has been uninstalled."
}

# Update packages
function update_package() {
    local package_name=$1
    if [[ -z $package_name ]]; then
        echo "Error: No package name provided."
        return 1
    fi
    echo "Updating $package_name..."
    local package_path=$PACKAGE_DIR/$package_name
    if [[ ! -d $package_path ]]; then
        echo "Error: Package $package_name is not installed."
        return 1
    fi
    cd $package_path
    git pull origin main
    if [[ -f install.sh ]]; then
        echo "Running install script for $package_name..."
        chmod +x install.sh
        ./install.sh
    fi
    cd -
    echo "$package_name has been updated."
}

# List installed packages
function list_packages() {
    echo "Listing installed packages..."
    echo $packages | jq 'keys'
}

# Main function
function main() {
    local command=$1
    shift
    load_packages
    case "$command" in
    -help | -h)
        show_help
        ;;
    -version | -v)
        show_version
        ;;
    -update)
        update_zshmgr
        ;;
    -uninstall)
        uninstall_zshmgr
        ;;
    install | i)
        install_package $@
        ;;
    uninstall)
        uninstall_package $@
        ;;
    update)
        update_package $@
        ;;
    list)
        list_packages
        ;;
    *)
        echo "Unknown command: $command"
        show_help
        ;;
    esac
}

main $@
