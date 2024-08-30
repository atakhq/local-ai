# local-ai
Shell script to install/update OpenWeb UI, and install models from ollama.

----------------------------------------------------------------------------------

## Pre-Reqs

- Docker
- Nvidia GPU Drivers installed and functional

----------------------------------------------------------------------------------

## Setup

Update `models_to_install.conf` with the models you want installed. 

The default file includes contains:
- llama3
- gemma 2

----------------------------------------------------------------------------------

## Running the Script:

### Interactive Mode:
Run the script without arguments to get the interactive menu:

  - `sudo ./manage_openwebui.sh`

## Command-Line Mode:

Run the script with one of the following arguments to perform specific actions directly:

  - `sudo ./manage_openwebui.sh install`
  - `sudo ./manage_openwebui.sh update`
  - `sudo ./manage_openwebui.sh download-models`
  - `sudo ./manage_openwebui.sh help`

----------------------------------------------------------------------------------

## Post Install:

You should now be able to access OpenWeb UI in your browser at http://localhost:8080

----------------------------------------------------------------------------------


