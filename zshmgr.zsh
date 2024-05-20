#!/bin/zsh

VERSION="1.0.0"
HELP_FILE="${HOME}/.zshmgr/help.txt"
PACKAGE_FILE="${HOME}/.zshmgr/packages.json"
PACKAGE_DIR="${HOME}/.zshmgr/packages"
INSTALL_DIR="${HOME}/.zshmgr"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="zshmgr"

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
    echo $packages | jq '.' > $PACKAGE_FILE
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

# Remove zshmgr itself
function remove_zshmgr() {
    echo "Removing zshmgr..."
    rm -rf $INSTALL_DIR
    sudo rm -f $BIN_DIR/$COMMAND_NAME
    echo "zshmgr has been removed."
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
        self-update)
            update_zshmgr
            ;;
        self-remove)
            remove_zshmgr
            ;;
        -h | help)
            show_help
            ;;
        -v)
            show_version
            ;;
        *)
            echo "Unknown command: $command"
            show_help
            ;;
    esac
}

main $@
#!/bin/zsh

VERSION="1.0.0"
HELP_FILE="${HOME}/.zshmgr/help.txt"
PACKAGE_FILE="${HOME}/.zshmgr/packages.json"
PACKAGE_DIR="${HOME}/.zshmgr/packages"
INSTALL_DIR="${HOME}/.zshmgr"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="zshmgr"

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
    echo $packages | jq '.' > $PACKAGE_FILE
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

# Remove zshmgr itself
function remove_zshmgr() {
    echo "Removing zshmgr..."
    rm -rf $INSTALL_DIR
    sudo rm -f $BIN_DIR/$COMMAND_NAME
    echo "zshmgr has been removed."
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
        "mgr -h" | "mgr -help")
            show_help
            ;;
        "mgr -v" | "mgr -version")
            show_version
            ;;
        "mgr -update")
            update_zshmgr
            ;;
        "mgr -remove")
            remove_zshmgr
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
