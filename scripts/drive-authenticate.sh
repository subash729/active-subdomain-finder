#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 [-u <username>] [-p <password_only>] [-t <token>] [-c <client_id>] [-s <client_secret>]"
    echo "Options:"
    echo "  -u, --user <username>          Google Drive username"
    echo "  -p, --password <password_only> Google Drive password"
    echo "  -t, --token <token>            Google Drive token"
    exit 1
}

# Function to take input from user
taking_input() {
    # Initialize variables with default values
    USERNAME=""
    PASSWORD_ONLY=""
    TOKEN=""
    CLIENT_ID=""
    CLIENT_SECRET=""

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
                PASSWORD_ONLY="$2"
                shift # past argument
                shift # past value
                ;;
            *)
                # unknown option
                usage
                ;;
        esac
    done

    # Check if username, password, token, client_id, and client_secret are provided
    if [[ -z $USERNAME || -z $PASSWORD_ONLY ]]; then
        echo "Error: Google Drive username, password required."
        usage
    fi
}

# Function to configure rclone for Google Drive
configure_rclone() {
    REMOTE_NAME="googledrive"

    # Add remote configuration for Google Drive
    rclone config create $REMOTE_NAME drive scope drive client_id "" client_secret "" token {"access_token":"$TOKEN"}

    # Print the configuration to the terminal
    echo "Rclone configured for Google Drive with remote name '$REMOTE_NAME'."
}

# Main function
main() {
    taking_input "$@"
    configure_rclone
}

main "$@"
