#!/bin/bash

# Function to install IntelliJ IDEA
install_intellij() {
    echo "Installing IntelliJ IDEA..."
    # For Linux/Mac
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
        wget https://download.jetbrains.com/idea/ideaIC-2021.2.3.tar.gz -O /tmp/ideaIC.tar.gz
        tar -xzf /tmp/ideaIC.tar.gz -C /opt/
        echo "IntelliJ IDEA installed."
    # For Windows
    elif [[ "$OSTYPE" == "msys"* ]]; then
        curl -L https://download.jetbrains.com/idea/ideaIC-2021.2.3.exe -o /tmp/ideaIC.exe
        start /wait "" /tmp/ideaIC.exe
        echo "IntelliJ IDEA installed."
    fi
}

# Function to install Visual Studio Code
install_vscode() {
    echo "Installing Visual Studio Code..."
    # For Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget -q https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/vscode.deb
        dpkg -i /tmp/vscode.deb
    # For Mac
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        curl -L https://go.microsoft.com/fwlink/?LinkID=620882 -o /tmp/vscode.zip
        unzip /tmp/vscode.zip -d /Applications
    # For Windows
    elif [[ "$OSTYPE" == "msys"* ]]; then
        curl -L https://go.microsoft.com/fwlink/?LinkID=623230 -o /tmp/vscode.exe
        start /wait "" /tmp/vscode.exe
    fi
    echo "Visual Studio Code installed."
}

# Function to install Anypoint Studio
install_anypoint() {
    echo "Installing Anypoint Studio..."
    # Assuming Linux/MacOS for simplicity; adjust for Windows or other OS as needed
    wget https://mule-studio.s3.amazonaws.com/7.8.0-20210423/AnypointStudio-7.8.0-20210423-linux64.tar.gz -O /tmp/anypoint.tar.gz
    tar -xzf /tmp/anypoint.tar.gz -C /opt/
    echo "Anypoint Studio installed."
}

# Main logic to decide which IDE to install based on input argument
ROLE=$1

case $ROLE in
    backend)
        install_intellij
        ;;
    frontend)
        install_vscode
        ;;
    fullstack)
        install_intellij
        install_vscode
        install_anypoint
        ;;
    *)
        echo "Usage: $0 {backend|frontend|fullstack}"
        exit 1
        ;;
esac
