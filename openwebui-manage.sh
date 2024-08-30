#!/bin/bash

# Function to display usage information
display_help() {
    echo "Usage: $0 [option]"
    echo
    echo "Options:"
    echo "  install          Install OpenWebUI, Ollama, and models specified in the config file"
    echo "  update           Update the OpenWebUI Docker container to the latest version"
    echo "  download-models  Download models specified in the config file"
    echo "  help             Display this help message"
    echo "  quit             Exit the script"
    echo
    echo "Examples:"
    echo "  $0 install"
    echo "  $0 update"
    echo "  $0 download-models"
    echo
    echo "Ensure the 'models_to_install.conf' file is updated with the models you want to install or download."
}

# Function to check if a service is running on a specified port
check_port() {
    local port=$1
    while ! nc -z localhost "$port"; do
        echo "Waiting for service on port $port..."
        sleep 1
    done
    echo "Service is up on port $port!"
}

# Function to install models from the config file
install_models() {
    config_file="models_to_install.conf"
    if [[ ! -f "$config_file" ]]; then
        echo "Config file $config_file not found. Exiting."
        exit 1
    fi

    while IFS= read -r model || [[ -n "$model" ]]; do
        echo "Installing $model model..."
        if ! ollama pull "$model"; then
            echo "Failed to install $model model. Exiting."
            exit 1
        fi
    done < "$config_file"
}

# Function to install OpenWebUI
install_openwebui() {
    echo "Installing Ollama..."
    if ! curl -fsSL https://ollama.com/install.sh | sh; then
        echo "Failed to install Ollama. Exiting."
        exit 1
    fi

    # Check if Ollama service is running on port 11434
    echo "Checking if Ollama service is up..."
    check_port 11434

    echo "Installing models..."
    install_models

    echo "Installing OpenWebUI..."
    if ! sudo docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main; then
        echo "Failed to install OpenWebUI. Exiting."
        exit 1
    fi

    # Check if OpenWebUI service is running on port 8080
    echo "Checking if OpenWebUI service is up..."
    check_port 8080

    echo "OpenWebUI is live! You can access it at http://localhost:8080"
}

# Function to update OpenWebUI
update_openwebui() {
    echo "Updating OpenWebUI..."

    if ! sudo docker pull ghcr.io/open-webui/open-webui:main; then
        echo "Failed to pull the latest OpenWebUI image. Exiting."
        exit 1
    fi

    if ! sudo docker stop open-webui; then
        echo "Failed to stop the OpenWebUI container. Exiting."
        exit 1
    fi

    if ! sudo docker rm open-webui; then
        echo "Failed to remove the OpenWebUI container. Exiting."
        exit 1
    fi

    if ! sudo docker run -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main; then
        echo "Failed to restart OpenWebUI with the new image. Exiting."
        exit 1
    fi

    echo "OpenWebUI has been updated and is live! You can access it at http://localhost:8080"
}

# Function to download models
download_models() {
    echo "Please update the 'models_to_install.conf' file with the models you want to install."
    read -p "Press Enter when ready to download models..."
    install_models
    echo "All models from 'models_to_install.conf' have been downloaded."
}

# Main script logic
if [[ $# -gt 0 ]]; then
    case $1 in
        install)
            install_openwebui
            ;;
        update)
            update_openwebui
            ;;
        download-models)
            download_models
            ;;
        help)
            display_help
            ;;
        *)
            echo "Invalid option: $1"
            display_help
            ;;
    esac
else
    echo "Do you want to install, update OpenWebUI, or download models?"
    select choice in "Install" "Update" "Download Models" "Help" "Quit"; do
        case $choice in
            Install)
                install_openwebui
                break
                ;;
            Update)
                update_openwebui
                break
                ;;
            "Download Models")
                download_models
                break
                ;;
            Help)
                display_help
                ;;
            Quit)
                echo "Exiting."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please select Install, Update, Download Models, Help, or Quit."
                ;;
        esac
    done
fi
