#!/bin/bash

# Professional Initialization Script with Dependency Checks and Ansible Integration

# Configuration Paths
ANSIBLE_PLAYBOOK_DIR="$(pwd)/ansible/playbooks"
ANSIBLE_INVENTORY="$(pwd)/ansible/inventory/dev.ini"
CONFIG_FILE="$(pwd)/config.yml"

# Utility Functions
log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

show_help() {
    echo "Development Environment Initialization Script"
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -h, --help    Display this help message and exit."
    echo "  -u, --usage   Display usage information."
}

show_usage() {
    echo "Run this script to initialize your development environment based on your role:"
    echo "./dev_starter"
}

detect_os() {
    case "$(uname -s)" in
        Linux*)     OS="Linux";;
        Darwin*)    OS="MacOS";;
        CYGWIN*|MINGW*) OS="Windows";;
        *)          log "Unsupported OS"; exit 1;;
    esac
    log "Detected OS: $OS"
}

install_dependencies() {
    log "Checking and installing dependencies..."
    check_and_install_yq
    # Check for Ansible and install if not found
    if ! command -v ansible > /dev/null; then
        log "Ansible not found. Attempting to install..."
        if [ "$OS" == "Linux" ]; then
            sudo apt update && sudo apt install -y software-properties-common
            sudo add-apt-repository --yes --update ppa:ansible/ansible
            sudo apt install -y ansible
        elif [ "$OS" == "MacOS" ]; then
            brew install ansible
        else
            log "Automatic installation of Ansible not supported on this OS."
            exit 1
        fi
    fi

    # Check for yq and install if not found
    if ! command -v yq > /dev/null; then
        log "'yq' not found. Attempting to install..."
        if [ "$OS" == "Linux" ]; then
            sudo apt install -y yq
        elif [ "$OS" == "MacOS" ]; then
            brew install yq
        else
            log "Automatic installation of 'yq' not supported on this OS."
            exit 1
        fi
    fi
}

prompt_for_role() {
    echo "Select your developer role:"
    select ROLE in "backend" "frontend" "fullstack" "exit"; do
        case $ROLE in
            backend | frontend | fullstack ) break;;
            exit ) log "Exiting setup."; exit 0;;
            * ) log "Invalid selection. Please try again.";;
        esac
    done
}

run_ansible_playbook() {
    local playbook_path="$ANSIBLE_PLAYBOOK_DIR/setup-$ROLE.yml"
    if [ ! -f "$playbook_path" ]; then
        log "Playbook for $ROLE does not exist."
        exit 1
    fi

    log "Running Ansible playbook for $ROLE role."
    ansible-playbook -i "$ANSIBLE_INVENTORY" "$playbook_path" --ask-become-pass
    if [ $? -ne 0 ]; then
        log "Ansible playbook execution failed."
        exit 1
    fi
}

# Function to check for yq and install it if not found
check_and_install_yq() {
    if ! command -v yq &> /dev/null; then
        echo "'yq' is not installed. Attempting to install 'yq'..."

        # Determine the OS and install yq using the appropriate package manager
        case "$(uname -s)" in
            Linux*)
                # Attempt to install yq using snap
                echo "Trying to install yq using snap..."
                sudo snap install yq
                ;;
            Darwin*)
                # Assume Homebrew is installed on macOS
                if command -v brew &> /dev/null; then
                    brew install yq
                else
                    echo "Homebrew is required to install 'yq' on macOS. Please install Homebrew and try again."
                    exit 1
                fi
                ;;
            *)
                echo "Unsupported OS for automatic 'yq' installation. Please install 'yq' manually."
                exit 1
                ;;
        esac
    fi

    # Verify if yq is successfully installed
    if ! command -v yq &> /dev/null; then
        echo "Failed to install 'yq'. Please install it manually."
        exit 1
    fi
}

# Function to parse config.yml
get_version() {
    yq e ".versions.$1" "$CONFIG_FILE"
}

get_var_value() {
    yq e ".$1" "$CONFIG_FILE"
}

# function to handle IDE installation based on user input
install_ide() {
    echo "Select IDEs to install (enter the numbers separated by spaces):"
    options=("IntelliJ IDEA" "Visual Studio Code" "Anypoint Studio" "Done")
    
    select opt in "${options[@]}"; do
        case $opt in
            "IntelliJ IDEA")
                echo "IntelliJ IDEA will be installed."
                [[ $(get_var_value INSTALL_INTELLIJ) ]] && install_intellij
                ;;
            "Visual Studio Code")
                echo "Visual Studio Code will be installed."
                [[ $(get_var_value INSTALL_VSCODE) ]] && install_vscode
                ;;
            "Anypoint Studio")
                echo "Anypoint Studio will be installed."
                [[ $(get_var_value INSTALL_ANYPOINT) ]] && install_anypoint
                ;;
            "Done")
                echo "Installation completed."
                ;;
            *)
                echo "Invalid option $REPLY"
                ;;
        esac
        # Check if the user selected "Done" option to exit the loop
        [[ $opt == "Done" ]] && break
    done
}

# Installation for IntelliJ IDEA
install_intellij() {
    echo "Installing IntelliJ IDEA..."
    # Define IntelliJ IDEA download URL
    IDEA_URL=$(get_var_value IDEA_URL)
    # For Linux and macOS
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
        curl -L $IDEA_URL -o /tmp/ideaIC.tar.gz
        sudo tar -xzf /tmp/ideaIC.tar.gz -C $(get_var_value INSTALL_DIR)
        echo "IntelliJ IDEA installed at $(get_var_value INSTALL_DIR)/idea-IC-*"
    else
        echo "Unsupported OS for IntelliJ IDEA installation."
    fi
}

# Installation for Visual Studio Code
install_vscode() {
    echo "Installing Visual Studio Code..."
    # For Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        VSCODE_URL=$(get_var_value VSCODE_URL)
        curl -L $VSCODE_URL -o /tmp/vscode.deb
        sudo dpkg -i /tmp/vscode.deb || sudo apt-get install -f -y
        echo "Visual Studio Code installed."
    # For macOS
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_URL=$(get_var_value VSCODE_URL)
        curl -L $VSCODE_URL -o /tmp/vscode.zip
        unzip /tmp/vscode.zip -d /Applications
        echo "Visual Studio Code installed at /Applications/Visual Studio Code.app"
    else
        echo "Unsupported OS for Visual Studio Code installation."
    fi
}

# Installation for Anypoint Studio
install_anypoint() {
    echo "Installing Anypoint Studio..."
    # Define Anypoint Studio download URL
    ANYPOINT_URL=$(get_var_value ANYPOINT_URL)
    # For Linux and macOS (Note: macOS installation might require additional steps or adjustments)
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
        curl -L $ANYPOINT_URL -o /tmp/anypoint.tar.gz
        sudo tar -xzf /tmp/anypoint.tar.gz -C $(get_var_value INSTALL_DIR)/
        echo "Anypoint Studio installed at $(get_var_value INSTALL_DIR)/AnypointStudio"
    else
        echo "Unsupported OS for Anypoint Studio installation."
    fi
}

# Main Execution
main() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -h|--help) show_help; exit 0 ;;
            -u|--usage) show_usage; exit 0 ;;
            *) log "Unknown option: $1"; show_help; exit 1 ;;
        esac
        shift
    done

    log "Initializing development environment setup..."
    detect_os
    install_dependencies
    prompt_for_role
    install_ide
    run_ansible_playbook

    log "Setup completed successfully."
}

main "$@"
