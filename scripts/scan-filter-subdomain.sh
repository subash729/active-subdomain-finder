#!/bin/bash

scan_store_dir=$HOME/information-gathering
declare -a all_subdomain_array_files # for initial all subdomains
declare -a unique_subdomain_array_files # removing duplicates and storing unique
declare -a active_subdomain_array_files # filtering only active domains
declare -a complete_subdomain_info_array_files

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
    
}

# Failures in Red color
function print_fail {
    local message="$1"
    printf "\e[1m\e[31m%s\e[0m\n" "$message"
    
}

# -------------Displaying Screen message in color end ----------------

usage() {
    print_header "Scan and Filter Subdomains"


    echo "Usage: $0 [-s <websitename>] | [-f <source-file>] -o <output file>"
    echo "Options:"
    echo "  -s, --site <websitename>        Website Name"
    echo "  -p, --file <source-file>        File containing website names"
    echo "  -o, --output <output file>      Output file name to save result"
    echo
    print_intermediate "Examples:"
    print_init "  ./scan-filter-subdomain.sh -s facebook.com"
    print_init "  ./scan-filter-subdomain.sh --file website-list.txt -o final-outputlist"
    print_fail "For more information, contact us:"
    print_success "  Email: pingjiwan@gmail.com,  Phone: +977 9866358671"
    print_success "  Email: subaschy729@gmail.com, Phone: +977 9823827047"
    exit 1
}

# Function to take input from user
taking_input() {
    # Initialize variables with default values
    SITE=""
    FILE=""
    OUTPUT=""

    # Parse command-line options
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -s|--site)
                SITE="$2"
                shift # past argument
                shift # past value
                ;;
            -f|--file)
                FILE="$2"
                shift # past argument
                shift # past value
                ;;
            -o|--output)
                OUTPUT="$2"
                shift # past argument
                shift # past value
                ;;
            *)
                # unknown option
                usage
                ;;
        esac
    done

    # Check if at least one of site, file, or output is provided
    if [[ -z $SITE && -z $FILE ]]; then
        echo "Error: Please enter  -s website-name or -f file of website"
        usage
    fi

    # -n checks non empty, concatenating both -s and -f domain name
    if [[ -n $SITE && -n $FILE ]]; then
    # Read from -s input and exclude script's own name
        if [[ -f $FILE ]]; then
            domains="$SITE $(grep -v "$0" "$FILE")"
        else
            domains="$SITE"
        fi
    elif [[ -n $SITE ]]; then
        # Read from -s input
        domains="$SITE"
    elif [[ -n $FILE ]]; then
        # Read from -f input if the file exists
        if [[ -f $FILE ]]; then
            domains=$(grep -v "$0" "$FILE")
        else
            echo "Error: File $FILE does not exist."
            exit 1
        fi
    fi
}

prerequisite_setup() {
    print_init "Creating Scan output Base directory and files at $scan_store_dir"
    print_separator
    mkdir -p $scan_store_dir

    for domain in $domains; do
        subdomain_single_file=$scan_store_dir/${domain}__$(date +%Y-%m-%d__%H:%M)__initial_subdomain.txt
        unique_subdomain_file=$scan_store_dir/${domain}__$(date +%Y-%m-%d__%H:%M)__unique_subdomain.txt
        active_subdomain_file=$scan_store_dir/${domain}__$(date +%Y-%m-%d__%H:%M)__active_subdomain.txt
        final_subdomain_file=$scan_store_dir/${domain}__$(date +%Y-%m-%d__%H:%M)__scan_info.txt

        touch $subdomain_single_file
        touch $unique_subdomain_file

        all_subdomain_array_files+=("$subdomain_single_file")
        unique_subdomain_array_files+=("$unique_subdomain_file")
        active_subdomain_array_files+=("$active_subdomain_file")
        complete_subdomain_info_array_files+=("$final_subdomain_file")
    done
}

scanning_subdomain() {
    print_header "1 - SCAN"
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
        chaos -up
        chaos -d $domain -v >> "$subdomain_single_file"
        # ffuf -u http://FUZZ.$domain -w "../source code/ffuf/n0kovo_subdomains_large.txt"
        print_separator
        index=$((index + 1))
    done
    print_success "All Domain are are scanned Sucessfully !!! "
    print_separator
    echo -e "\n\n"
}

filtering_duplicate_sub_domain() {
    print_header "2 - DATA CLEAN"
    print_separator
    print_init "STEP -1 : Filtering duplicate sub-domains in progress..."
    index=0
    for domain in $domains; do
        subdomain_single_file=${all_subdomain_array_files[$index]}
        unique_subdomain_file=${unique_subdomain_array_files[$index]}

        print_intermediate "Processing $domain sub-domains in progress..."
        print_intermediate "Scanning subdomains using file: $subdomain_single_file"
        
        sort "$subdomain_single_file" | uniq >> "$unique_subdomain_file"
        sort "$subdomain_single_file" | uniq >> $OUTPUT
        index=$((index + 1))
    done
    print_success "Unique Domains are extracted successfully!"
    print_separator
}

active_domain_find() {
    print_init "STEP -2 : Finding active subdomains in progress..."
    index=0
    for domain in $domains; do
        print_intermediate "Processing sub-domains of #---- https://$domain ---#  in progress..."
        print_intermediate "scanning subdomain using file : $unique_subdomain_file"
        unique_subdomain_file=${unique_subdomain_array_files[$index]}
        active_subdomain_file=${active_subdomain_array_files[$index]}
        final_subdomain_file=${complete_subdomain_info_array_files[$index]}


        if grep -q 'Ubuntu' /etc/os-release; then
            cat $unique_subdomain_file | httpx >> $active_subdomain_file
        # Initial processing and counting
        else
            cat $unique_subdomain_file | httpx-toolkit >> $active_subdomain_file
        fi

        site_count=$(wc -l < $active_subdomain_file)

        # Conditional execution based on word count
        if [ "$site_count" -lt 300 ]; then
            print_separator
            print_init "Only ### $site_count ### sub-domains are active, Displaying detailed info in console"
            print_separator
            if grep -q 'Kali' /etc/os-release; then
                httpx_argument="httpx-toolkit -probe -sc -cname -ip -method -title -location -td -stats -o $final_subdomain_file"
                cat $unique_subdomain_file | $httpx_argument
            else
                httpx_argument="httpx -probe -sc -cname -ip -method -title -location -td -stats -o $final_subdomain_file"
                cat $unique_subdomain_file | $httpx_argument
            fi
        else
            print_separator
            print_init "Huge no i.e. ### $site_count ### sub-domains are active, Running silently "
            print_separator
            if grep -q 'Kali' /etc/os-release; then
                httpx_argument="httpx-toolkit -probe -sc -cname -ip -method -title -location -td -stats"
                cat $unique_subdomain_file | $httpx_argument >> $final_subdomain_file
            else
                httpx_argument="httpx -probe -sc -cname -ip -method -title -location -td -stats"
                cat $unique_subdomain_file | $httpx_argument >> $final_subdomain_file
            fi
        fi

        # Add logic to filter active subdomains and write to $active_subdomain_file
        site_count=0
        index=$((index + 1))
    done
    print_separator
    print_success "ACTIVE Domain are filtered Sucessfully !!! "
}


deleting_others_scan() {
    print_separator
    print_init "STEP -3 : Deleting other subdomains files in progress..."
    rm -rf $scan_store_dir/*initial*.txt 
}

main() {
    taking_input "$@"
    prerequisite_setup
    scanning_subdomain
    filtering_duplicate_sub_domain
    active_domain_find
    deleting_others_scan

    unset scan_store_dir all_subdomain_array_files unique_subdomain_array_files 
    unset active_subdomain_array_files domains

main "$@"
