# local-ai
Shell script to install/update OpenWeb UI, and install models from ollama.

Tested with:
- Ubuntu 20.04
- RTX 4070 12gb Ram
- 64gb DDR5 System Ram
- i7-13700F (24 cores)



## Pre-Reqs

- Curl
- Docker
- Nvidia GPU Drivers installed and functional



## Setup

Update `models_to_install.conf` with the models you want installed. 

The default file includes contains:
- llama3
- gemma 2



## Running the Script:

### Interactive Mode:
Run the script without arguments to get the interactive menu:

  - `sudo ./manage_openwebui.sh`

## Command-Line Mode:

Run the script with one of the following arguments to perform specific actions directly:

  - `sudo ./manage_openwebui.sh install`

If all went well, you should see output like this:
```
>>> Installing ollama to /usr/local
>>> Downloading Linux amd64 CLI
######################################################################## 100.0%######################################################################### 100.0%
>>> Making ollama accessible in the PATH in /usr/local/bin
>>> Creating ollama user...
>>> Adding ollama user to render group...
>>> Adding ollama user to video group...
>>> Adding current user to ollama group...
>>> Creating ollama systemd service...
>>> Enabling and starting ollama service...
Created symlink /etc/systemd/system/default.target.wants/ollama.service → /etc/systemd/system/ollama.service.
>>> NVIDIA GPU installed.
```

  - `sudo ./manage_openwebui.sh update`
  - `sudo ./manage_openwebui.sh download-models`
  - `sudo ./manage_openwebui.sh help`

----------------------------------------------------------------------------------

## Post Install:

You should now be able to access OpenWeb UI in your browser at http://localhost:8080

On first boot: Click "Sign Up" at the bottom of the login screen and create your admin login.

** Make sure you write down the admin login creds as this is the only user that can create new users unless you assign more admins **

----------------------------------------------------------------------------------


