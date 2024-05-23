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
    print_header "4 - CHAOS"
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
check_ffuf_installed() {
    print_separator
    print_header "5 - ffuf"
    print_separator
    sleep 2
    if command -v ffuf &>/dev/null; then
        print_success "ffuf is already installed"
        return 0
    else
        print_fail "ffuf Package is missing"
        return 1
    fi
}

check_httpx-toolkit_installed() {
    print_separator
    print_header "6 - httpx-toolkit"
    print_separator
    sleep 2
    if command -v httpx-toolkit &>/dev/null; then
        print_success "httpx-toolkit is already installed"
        return 0
    else
        print_fail "httpx-toolkit Package is missing"
        return 1
    fi
}
check_rclone_installed() {
    print_separator
    print_header "7 - rclone"
    print_separator
    sleep 2
    if command -v rclone &>/dev/null; then
        print_success "rclone is already installed"
        return 0
    else
        print_fail "rclone Package is missing"
        return 1
    fi
}
check_mega-cmd_installed() {
    print_separator
    print_header "7 - rclone"
    print_separator
    sleep 2
    if command -v mega-cmd &>/dev/null; then
        print_success "mega-cmd is already installed"
        return 0
    else
        print_fail "mega-cmd Package is missing"
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

    if grep -q 'Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt-get install -y subfinder
        print_separator

        if [ $? -eq 0 ]; then
            print_success "subfinder is now installed"
        else
            print_fail "Failed to install subfinder"
        fi

    
    elif grep -q 'Ubuntu' /etc/os-release; then
        sudo apt-get update
        sudo snap install go
        sudo apt install -y tree
        go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
        sudo cp $HOME/go/bin/subfinder  /usr/bin/
        print_separator
        if [ $? -eq 0 ]; then
            print_success "subfinder is now installed"
        else
            print_fail "Failed to install subfinder"
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
            print_fail "Failed to install subfinder"
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
            print_fail "Failed to install amass"
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

    if grep -q 'Kali\|Ubuntu' /etc/os-release; then
        sudo apt-get update
	    sudo snap install go --classic
        go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
        sudo cp $HOME/go/bin/chaos  /usr/bin/
        print_separator

        if [ $? -eq 0 ]; then
            print_success "chaos is now installed"
        else
            print_fail "chaos is not installed"
        fi
    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi


}
install_ffuf () {
    if check_ffuf_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing ffuf"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt install -y ffuf
        print_separator

        if [ $? -eq 0 ]; then
            print_success "ffuf is now installed"
        else
            print_fail "ffuf is not installed"
        fi

    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi
}

install_httpx-toolkit () {
    if check_httpx-toolkit_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing httpx-toolkit"
    print_separator

    if grep -q 'Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt install -y httpx-toolkit
        print_separator

        if [ $? -eq 0 ]; then
            print_success "httpx-toolkit is now installed"
        else
            print_fail "httpx-toolkit is not installed"
        fi
    
    elif grep -q 'Ubuntu' /etc/os-release; then
        sudo apt-get update
        sudo snap install go
        go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
        sudo cp $HOME/go/bin/httpx  /usr/bin/
        print_separator
        if [ $? -eq 0 ]; then
            print_success "httpx-toolkit is now installed"
        else
            print_fail "subfinder is not installed"
        fi
    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi


}
install_rclone () {
    if check_rclone_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing rclone"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
        sudo apt-get update
        sudo apt install -y rclone
        print_separator

        if [ $? -eq 0 ]; then
            print_success "rclone is now installed"
        else
            print_fail "rclone is not installed"
        fi

    else
        print_separator
        print_fail "Unsupported Linux distribution"
        exit 1
    fi
}

install_mega-cmd() {
    if check_mega-cmd_installed; then
        return
    fi

    os_description=$(lsb_release -a 2>/dev/null | grep "Description:" | awk -F'\t' '{print $2}')
    print_init "$os_description Detected on your system"
    printf "\n"
    print_intermediate "Installing mega-cmd"
    print_separator

    if grep -q 'Ubuntu\|Kali' /etc/os-release; then
	    wget https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megacmd-xUbuntu_22.04_amd64.deb \
		    && sudo apt install -y "$PWD/megacmd-xUbuntu_22.04_amd64.deb"
    if [ $? -eq 0 ]; then
            print_success "mega-cmd is now installed"
        else
            print_fail "mega-cmd is not installed"
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
    install_ffuf


    # tool to find active or up webserver
    install_httpx-toolkit 
    # copy files to google-drive
    install_rclone
}
main
