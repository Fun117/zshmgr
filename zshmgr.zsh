#!/bin/zsh

# File for storing package information.
PACKAGE_FILE="${HOME}/.zshmgr/packages.json"
PACKAGE_DIR="${HOME}/.zshmgr/packages"

# Loading package information
function load_packages() {
    if [[ -f $PACKAGE_FILE ]]; then
        packages=$(cat $PACKAGE_FILE)
    else
        packages="{}"
    fi
}

# Storing package information
function save_packages() {
    echo $packages | jq '.' > $PACKAGE_FILE
}

# Installing packages
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

# Uninstalling packages
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

# List view of installed packages
function list_packages() {
    echo "Listing installed packages..."
    echo $packages | jq 'keys'
}

# main function
function main() {
    local command=$1
    shift
    load_packages
    case "$command" in
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
            echo "Usage: $0 {install|uninstall|update|list} [package_name]"
            ;;
    esac
}

main $@
