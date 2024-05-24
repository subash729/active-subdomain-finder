#!/bin/bash

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}

# --------------- Large Banner Display Section End --------------

# Displaying Screen Messages with Colors

# Detection in Yellow color
function print_init {
    local message="$1"
    printf "\e[33m%s\e[0m\n" "$message"
}

# Intermediate in Blue color
function print_intermediate {
    local message="$1"
    printf "\e[34m%s\e[0m\n" "$message"
}

# Completion in Green color
function print_success {
    local message="$1"
    printf "\e[1m\e[32m%s\e[0m\n" "$message"
}

# Failures in Red color
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
}

# Function to display script usage
usage() {
    print_header "Mega Setup"

    echo "Usage: $0 [-u <username>] [-p <password>] [-s <source_directory/file>] [-d <destination>]"
    echo "Options:"
    echo "  -u, --user <username>                   Mega username"
    echo "  -p, --password <password>               Mega password"
    echo "  -s, --source <source_directory/file>    Complete path of local directory/file"
    echo "  -d, --dest <destination>                Mega directory"
    echo
    print_intermediate "Examples:"
    print_init "  ./mega-config.sh -u Jiwan@gmail.com -p test@123 -s \"/home/test\" -d cloud-dir"
    print_init "  ./mega-config.sh -u subash@gmail.com -p password -s \"test/*.txt\" -d /ANY-Directory"
    print_fail "For more information, contact us:"
    print_success "  Email: pingjiwan@gmail.com,  Phone: +977 9866358671"
    print_success "  Email: subaschy729@gmail.com, Phone: +977 9823827047"
    exit 1
}

# Function to take input from user
taking_input() {
    # Initialize variables with default values
    USERNAME=""
    PASSWORD=""
    SOURCE=""
    DEST=""

    # Parse command-line options
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -u|--user)
                USERNAME="$2"
                shift # past argument
                shift # past value
                ;;
            -p|--password)
                PASSWORD="$2"
                shift # past argument
                shift # past value
                ;;
            -s|--source)
                SOURCE="$2"
                shift # past argument
                shift # past value
                ;;
            -d|--dest)
                DEST="$2"
                shift # past argument
                shift # past value
                ;;
            *)
                # unknown option
                usage
                ;;
        esac
    done

    # Check if username, password, source, and destination are provided
    if [[ -z $USERNAME || -z $PASSWORD || -z $SOURCE || -z $DEST ]]; then
        echo "Error: Mega username, password, source, and destination are required."
        usage
    fi
}

check_installation() {
    if ! command -v mega-cmd &> /dev/null; then
        print_fail "mega-cmd is not installed. Please install it and try again."
        exit 1
    fi
    print_success "mega-cmd is installed."
}

# Function to configure rclone for Google Drive
copy_to_mega() {
    print_separator
    print_header "Login Setup"
    print_init "Please wait, Mega Login in progress"
    print_separator
    sleep 2
    mega-login $USERNAME $PASSWORD
    print_separator
    print_success "Login sucessfully"
    echo -e "\n"

    # Check if the destination directory exists
    print_intermediate "Checking Directory in cloud"
    if mega-ls "$DEST" > /dev/null 2>&1; then
        print_init "Directory '$DEST' already exists in MEGA."
    else
        print_fail "$DEST Directory NOT FOUND,  creating Directory"
        print_success "Creating directory '$DEST' in MEGA."
        mega-mkdir "$DEST"
    fi

    # Copy files from local source to MEGA destination
    print_intermediate "Copying files from local '$SOURCE' to MEGA '$DEST'."
    mega-put "$SOURCE" "$DEST"
}

# Function to make files publicly accessible
public_share() {
    print_separator
    print_header "Public Sharing"

    print_success "Making files publicly accessible on MEGA."
    mega-export -a $DEST
}

# Function to remove configurations
remove_config() {
    print_separator
    print_header "Clean Up"
    print_separator
    print_fail "Logging out and removing all configurations."
    mega-logout
    rm -rf $HOME/.megaCmd/*
    print_success "All config files are deleted from system"
}

# Main function
main() {
    check_installation
    taking_input "$@"
    copy_to_mega
    public_share
    remove_config

    # Unset all variables
    unset USERNAME PASSWORD SOURCE DEST
}

main "$@"
