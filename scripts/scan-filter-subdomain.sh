#!/bin/bash

scan_store_dir=$HOME/information-gathering
declare -a all_subdomain_array_files # for initial all subdomains
declare -a unique_subdomain_array_files # removing duplicates and storing unique
declare -a active_subdomain_array_files # filtering only active domains

# ------- LARGE Banner display section start

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}

# --------------- Large Banner display Section end --------------

# Displaying Screen message in color Start

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
    print_separator
}

# Failures in Red color
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
    print_separator
}

# -------------Displaying Screen message in color end ----------------

prerequisite_setup() {
    print_init "Creating Scan output Base directory and files at $scan_store_dir"
    print_separator
    mkdir -p $scan_store_dir

    if [[ -f ../domain-list.txt ]]; then
        domains=$(cat ../domain-list.txt)
    else
        echo "domain-list.txt not found!"
        exit 1
    fi

    for domain in $domains; do
        subdomain_single_file=$scan_store_dir/${domain}-initial_subdomain$(date +%Y-%m-%d__%H:%M).txt
        unique_subdomain_file=$scan_store_dir/${domain}-unique_subdomain$(date +%Y-%m-%d__%H:%M).txt
        active_subdomain_file=$scan_store_dir/${domain}-active_subdomain$(date +%Y-%m-%d__%H:%M).txt
        touch $subdomain_single_file
        touch $unique_subdomain_file
        touch $active_subdomain_file

        # Array used to store filenames
        all_subdomain_array_files+=("$subdomain_single_file")
        unique_subdomain_array_files+=("$unique_subdomain_file")
        active_subdomain_array_files+=("$active_subdomain_file")
    done
}

scanning_subdomain() {
    print_separator
    echo "Domains to be scanned:"
    print_init "$domains"
    print_separator

    index=0
    for domain in $domains; do
        print_separator
        print_intermediate "Scanning $domain in progress..."
        subdomain_single_file=${all_subdomain_array_files[$index]}
        subfinder -d $domain >> "$subdomain_single_file"
        print_separator
        echo -e "\n\n"
        index=$((index + 1))
    done
    print_success "All Domain are are scanned Sucessfully !!! "
    print_separator
}

filtering_duplicate_and_inactive(){
    print_separator
    print_init "STEP -1 : Filtering duplicate sub-domains in progress..."
    index=0
    for domain in $domains; do
        print_intermediate "Processing $domain sub-domains in progress..."
        subdomain_single_file=${all_subdomain_array_files[$index]}
        unique_subdomain_file=${unique_subdomain_array_files[$index]}
        
        # Redirecting unique output to respective subdomain-file
        sort "$subdomain_single_file" | uniq >> "$unique_subdomain_file"
        index=$((index + 1))
    done
    print_separator
    echo -e "\n\n"

    print_separator
    print_init "STEP -2 : Finding active subdomains in progress..."
    index=0
    for domain in $domains; do
        print_intermediate "Processing $domain sub-domains in progress..."
        unique_subdomain_file=${unique_subdomain_array_files[$index]}
        active_subdomain_file=${active_subdomain_array_files[$index]}
        # Add logic to filter active subdomains and write to $active_subdomain_file
        index=$((index + 1))
    done
    echo -e "\n\n"
    print_success "Unique Domain are extracted Sucessfully !!! "
    print_separator
}

deleting_others_scan() {
    rm -rf $scan_store_dir/*initial*.txt 
    # rm -rf $scan_store_dir/*unique*.txt
}

main() {
    prerequisite_setup
    scanning_subdomain
    filtering_duplicate_and_inactive
    deleting_others_scan
}

main
