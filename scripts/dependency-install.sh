#!/bin/bash

scan_store_dir=$HOME/information-gathering

# ------- LARGE Banner display section start

function print_separator {
    printf "\n%s\n" "--------------------------------------------------------------------------------"
}

function print_header {
    figlet -c -f slant "$1"
    print_separator
}

# --------------- LArge Banner display Section end --------------

# Displaying Screen message in color  Start

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

# -------------Displaying Screen message in color  end ----------------


# ---------- Package installed Function check start -------------
check_figlet_installed() {
    print_separator
    print_header "1 - FIGLET"
    print_separator
    sleep 2
    if command -v figlet &>/dev/null; then
        print_success "Figlet is already installed"
        return 0
    else
        print_fail "Figlet Package is missing"
        return 1
    fi
}

check_subfinder_installed() {
    print_separator
    print_header "2 - SUBFINDER"
    print_separator
    sleep 2
    if command -v subfinder &>/dev/null; then
        print_success "subfinder is already installed"
        return 0
    else
        print_fail "subfinder Package is missing"
        return 1
    fi
}

check_amass_installed() {
    print_separator
    print_header "3 - AMASS"
    print_separator
    sleep 2
    if command -v amass &>/dev/null; then
        print_success "amass is already installed"
        return 0
    else
        print_fail "amass Package is missing"
        return 1
    fi
}

check_chaos_installed() {
    print_separator
    print_header "3 - AMASS"
    print_separator
    sleep 2
    if command -v chaos &>/dev/null; then
        print_success "chaos is already installed"
        return 0
    else
        print_fail "chaos Package is missing"
        return 1
    fi
}

# ---------- Package installation start -------------

install_figlet() {
    if check_figlet_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing Figlet"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt-get install -y figlet
        print_separator

        if [ $? -eq 0 ]; then
            print_success "Figlet is now installed"
        else
            print_fail "Failed to install Figlet"
        fi

    elif grep -qEi 'redhat\|centos' /etc/os-release; then
        sudo yum -y install figlet
        print_separator
        if [ $? -eq 0 ]; then
            print_success "Figlet is now installed"
        else
            print_fail "Failed to install Figlet"
        fi

    elif grep -q 'Amazon Linux 2' /etc/os-release || grep -q 'Amazon Linux 3' /etc/os-release; then
        sudo amazon-linux-extras install epel -y
        sudo yum -y install figlet
        print_separator
        if [ $? -eq 0 ]; then
            print_success "Figlet is now installed"
        else
            print_fail "Failed to install Figlet"
        fi
    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi
}

install_subfinder(){
    if check_subfinder_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing subfinder"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt-get install -y subfinder
        print_separator

        if [ $? -eq 0 ]; then
            print_success "subfinder is now installed"
        else
            print_fail "subfinder to install Figlet"
        fi

    elif grep -qEi 'redhat\|centos' /etc/os-release; then
        sudo yum -y install subfinder
        sudo dnf -y update
        sudo dnf -y install epel-release
        sudo dnf -y update
        sudo dnf -y install subfinder
        print_separator
        if [ $? -eq 0 ]; then
            print_success "subfinder is now installed"
        else
            print_fail "subfinder to install Figlet"
        fi

    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi

}

install_amass() {
    if check_amass_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing amass"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt-get install -y amass
        print_separator

        if [ $? -eq 0 ]; then
            print_success "amass is now installed"
        else
            print_fail "amass to install Figlet"
        fi

    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi

}

install_chaos (){
    if check_chaos_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing chaos"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
        sudo apt-get update
	    sudo apt install -y golang
        go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
        print_separator

        if [ $? -eq 0 ]; then
            print_success "chaos is now installed"
        else
            print_fail "chaos to install Figlet"
        fi

    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi


}

main() {
    #first package installation
    install_figlet
    install_subfinder
    install_amass
    install_chaos
}
main
