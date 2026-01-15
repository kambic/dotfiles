#!/bin/bash

# ========================================
# CONSTANTS
# ========================================

# ========================================
#  --- COLORS ---
# ========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Define bold color variables
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Define background color variables
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# ========================================
# Functions
# ========================================

# failsafe source method, only source if file exists
include() {
    [[ -f "$1" ]] && source "$1"
}

# failsafe exec method, only execute if file exists
safe_exec() {
    [[ -f "$1" ]] && bash "$1"
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "$1 - [y/N] " response
    case "$response" in
    [yY][eE][sS] | [yY])
        true
        ;;
    *)
        false
        ;;
    esac
}

print_h1() {
    echo -e "$BOLD_PURPLE\n========== [$1] ==========\n$NC"
}

print_h2() {
    echo -e "$BOLD_BLUE\n---------- [$1] ----------\n$NC"
}

print_h3() {
    echo -e "$BOLD_CYAN\n.......... [$1] ..........\n$NC"
}

print_note() {
    echo ":::: $1 ::::"
}

print_warning() {
    echo -e "$BOLD_YELLOW:::: $1 ::::$NC"
}

print_error() {
    echo -e "$BOLD_RED:::: $1 ::::$NC"
}

# Usage print_message 5 "A Message"
print_progress() {
    local percent=$1
    local message=$2

    # Format the percentage to be right-aligned within 3 characters
    printf "[%3d%%] %s\n" "$percent" "$message"
}

toggle_process() {

    PROCESS_NAME="$1"

    # Try to kill the process
    killall "$PROCESS_NAME"

    # Check the exit status of killall
    if [ $? -eq 0 ]; then
        echo "Process $PROCESS_NAME was running and has been killed."
    else
        echo "Process $PROCESS_NAME was not running. Starting it now."
        # Start the process
        $PROCESS_NAME &
    fi

}

# Function to check if a list contains a value
array_contains() {
    local list=("$@")
    local item="${list[-1]}"
    unset list[-1]

    for element in "${list[@]}"; do
        if [[ "$element" == "$item" ]]; then
            return 0
        fi
    done

    return 1
}

# Checks if a provided IP address is present on the local network
ip_present() {
    local ip=$1
    # Ping the IP address with a timeout of 1 second and count of 1 packet
    if ping -c 1 -W 1 $ip &>/dev/null; then
        exit 0
    else
        exit 1
    fi
}

source_all_libs() {
    local dir="$LIB_PATH"
    if [ -d "$dir" ]; then
        find "$dir" -type f -name "*.sh" -exec bash -c 'source "$0"' {} \;
    fi
}

# ========================================
# PACKAGE MANAGER FUNCTIONS
# ========================================

source "$LIB_PATH/my_lib.sh"
source "$LIB_PATH/distributions.sh"

pacman_install_file() {
    # remove comments and spaces at the end of the line
    grep -v '^#' "$1" | grep -o '^[^#]*' | sed 's/[[:space:]]*$//' | sudo pacman $PACMAN_FLAGS -S -
}

pacman_install_single() {

    # Check if the package is installed using yay
    if ! pacman -Qi "$1" &>/dev/null; then
        sudo pacman $PACMAN_FLAGS -S "$@"
    fi
}

yay_install_file() {
    # remove comments and spaces at the end of the line
    grep -v '^#' "$1" | grep -o '^[^#]*' | sed 's/[[:space:]]*$//' | yay $YAY_FLAGS -S -
}

yay_install_single() {
    yay $YAY_FLAGS -S "$@"
}


# ========================================
# CACHE FUNCTIONS
# ========================================

# Check if CACHE_DIR environment variable is set, if not default to $HOME/.cache
CACHE_DIR="${CACHE_DIR:-$HOME/.cache}"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to write a cache option
write_cache_option() {
    local app_name=$1
    local option_name=$2
    local app_dir="$CACHE_DIR/$app_name"
    
    # Create application directory if it doesn't exist
    mkdir -p "$app_dir"
    
    # Create the option file
    touch "$app_dir/$option_name"
}

# Function to check a cache option
check_cache_option() {
    local app_name=$1
    local option_name=$2
    local app_dir="$CACHE_DIR/$app_name"
    
    # Check if the option file exists
    if [[ -f "$app_dir/$option_name" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to remove a cache option
remove_cache_option() {
    local app_name=$1
    local option_name=$2
    local app_dir="$CACHE_DIR/$app_name"
    
    # Remove the option file
    if [[ -f "$app_dir/$option_name" ]]; then
        rm "$app_dir/$option_name"
        echo "Cache option removed"
    else
        echo "Cache option does not exist"
    fi
}

# Function to store a value in a cache option
write_cache_value() {
    local app_name=$1
    local option_name=$2
    local value=$3
    local app_dir="$CACHE_DIR/$app_name"
    
    # Create application directory if it doesn't exist
    mkdir -p "$app_dir"
    
    # Write the value to the option file
    echo "$value" > "$app_dir/$option_name"
}

# Function to get a value from a cache option
read_cache_value() {
    local app_name=$1
    local option_name=$2
    local app_dir="$CACHE_DIR/$app_name"
    
    # Check if the option file exists and read its value
    if [[ -f "$app_dir/$option_name" ]]; then
        cat "$app_dir/$option_name"
    else
        echo "Cache option does not exist"
        return 1
    fi
}

# Example usage:
# write_cache_option MyApp option1
# check_cache_option MyApp option1
# remove_cache_option MyApp option1
# write_cache_value MyApp option1 "some_value"
# read_cache_value MyApp option1
#!/bin/bash

# Function to check if the system is Arch Linux
is_arch() {
    if [[ -f /etc/arch-release ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if the system is Debian-based (Debian or Ubuntu)
is_debian() {
    if [[ -f /etc/debian_version ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if the system is Fedora
is_fedora() {
    if [[ -f /etc/fedora-release ]]; then
        return 0
    else
        return 1
    fi
}

# Functio to check if the system is Andrroid (run with Termux)
is_android() {
    if [[ -f /system/build.prop || -n "$TERMUX_VERSION" ]]; then
        exit 0
    else
        return 1
    fi
}

# Function to check if the system is macOS
is_macos() {
    if [[ -f /System/Library/CoreServices/SystemVersion.plist ]]; then
        return 0
    else
        return 1
    fi
}

print_logo_system_update() {
    echo -e "

██████╗ ██╗████████╗███████╗██╗  ██╗███████╗██████╗ ██╗███████╗███████╗███████╗
██╔══██╗██║╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██║██╔════╝██╔════╝██╔════╝
██████╔╝██║   ██║   ███████╗███████║█████╗  ██████╔╝██║█████╗  █████╗  ███████╗
██╔══██╗██║   ██║   ╚════██║██╔══██║██╔══╝  ██╔══██╗██║██╔══╝  ██╔══╝  ╚════██║
██████╔╝██║   ██║   ███████║██║  ██║███████╗██║  ██║██║██║     ██║     ███████║
╚═════╝ ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝     ╚══════╝
                                                                               
███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗                          
██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║                          
███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║                          
╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║                          
███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║                          
╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝                          
                                                                               
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗                             
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝                             
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗                               
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝                               
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗                             
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝                             
"
}

print_logo_config() {
    echo -e "

██████╗ ██╗████████╗███████╗██╗  ██╗███████╗██████╗ ██╗███████╗███████╗███████╗
██╔══██╗██║╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██║██╔════╝██╔════╝██╔════╝
██████╔╝██║   ██║   ███████╗███████║█████╗  ██████╔╝██║█████╗  █████╗  ███████╗
██╔══██╗██║   ██║   ╚════██║██╔══██║██╔══╝  ██╔══██╗██║██╔══╝  ██╔══╝  ╚════██║
██████╔╝██║   ██║   ███████║██║  ██║███████╗██║  ██║██║██║     ██║     ███████║
╚═════╝ ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝     ╚══════╝
                                                                               
 ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗                                 
██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝                                 
██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗                                
██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║                                
╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝                                
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝                                 
"
}

print_logo_bitSheriff() {
    echo -e "

██████╗ ██╗████████╗███████╗██╗  ██╗███████╗██████╗ ██╗███████╗███████╗
██╔══██╗██║╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██║██╔════╝██╔════╝
██████╔╝██║   ██║   ███████╗███████║█████╗  ██████╔╝██║█████╗  █████╗  
██╔══██╗██║   ██║   ╚════██║██╔══██║██╔══╝  ██╔══██╗██║██╔══╝  ██╔══╝  
██████╔╝██║   ██║   ███████║██║  ██║███████╗██║  ██║██║██║     ██║     
╚═════╝ ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝     
"

}

print_logo_cthulhu() {
    echo -e "
⠀⠀⠀⠀⠀⠀⠀⣠⡤⠶⡄⠀⠀⠀⠀⠀⠀⠀⢠⠶⣦⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣴⣿⡟⠀⠈⣀⣾⣝⣯⣿⣛⣷⣦⡀⠀⠈⢿⣿⣦⡀⠀⠀⠀⠀
⠀⠀⠀⣴⣿⣿⣿⡇⠀⢼⣿⣽⣿⢻⣿⣻⣿⣟⣷⡄⠀⢸⣿⣿⣾⣄⠀⠀⠀
⠀⠀⣞⣿⣿⣿⣿⣷⣤⣸⣟⣿⣿⣻⣯⣿⣿⣿⣿⣀⣴⣿⣿⣿⣿⣯⣆⠀⠀
⠀⡼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣜⡆⠀
⢠⣟⣯⣿⣿⣿⣷⢿⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣟⠿⣿⣿⣿⣿⡷⣾⠀
⢸⣯⣿⣿⡏⠙⡇⣾⣟⣿⡿⢿⣿⣿⣿⣿⣿⢿⣟⡿⣿⠀⡟⠉⢹⣿⣿⢿⡄
⢸⣯⡿⢿⠀⠀⠱⢈⣿⢿⣿⡿⣏⣿⣿⣿⣿⣿⣿⣿⣿⣀⠃⠀⢸⡿⣿⣿⡇
⢸⣿⣇⠈⢃⣴⠟⠛⢉⣸⣇⣹⣿⣿⠚⡿⣿⣉⣿⠃⠈⠙⢻⡄⠎⠀⣿⡷⠃
⠈⡇⣿⠀⠀⠻⣤⠠⣿⠉⢻⡟⢷⣝⣷⠉⣿⢿⡻⣃⢀⢤⢀⡏⠀⢠⡏⡼⠀
⠀⠘⠘⡅⠀⣔⠚⢀⣉⣻⡾⢡⡾⣻⣧⡾⢃⣈⣳⢧⡘⠤⠞⠁⠀⡼⠁⠀⠀
⠀⠀⠀⠸⡀⠀⢠⡎⣝⠉⢰⠾⠿⢯⡘⢧⡧⠄⠀⡄⢻⠀⠀⠀⢰⠁⠀⠀⠀
⠀⠀⠀⠀⠁⠀⠈⢧⣈⠀⠘⢦⠀⣀⠇⣼⠃⠰⣄⣡⠞⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢤⠼⠁⠀⠀⠳⣤⡼⠀⠀⠀
    "
}