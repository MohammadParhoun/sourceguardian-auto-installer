#!/bin/bash

# ==============================================================================
# Script Name: SourceGuardian Auto Installer
# Description: This script installs and configures SourceGuardian loaders for multiple PHP versions on DirectAdmin servers.
# Author: Mohammad Parhoun <mohammad.parhoun.7@gmail.com
# Version: 1.0
#
# Copyright (c) 2025 Mohammad Parhoun. All Rights Reserved.
# This script is licensed under the MIT License.
#
# Changelog:
# v1.0 - 2025-03-29: Initial release.
# ==============================================================================


RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"
required_packages=(unzip wget)
missing_packages=()

install() {

    mkdir -p /usr/local/lib/loaders/
    cd /usr/local/lib/loaders/
    wget --user-agent="Mozilla" http://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.zip
    unzip -q loaders.linux-x86_64.zip -d source
    cd source/ && rm -f README "SourceGuardian Loader License.pdf" version && find . -type f -name "*ts.lin" -exec rm -f {} + && chmod 0755 * && chown -R root:root *
    declare -a php_versions
    mapfile -t php_versions < <(/usr/local/directadmin/custombuild/build options | grep PHP | cut -d ":" -f 2 | tr -d " " | perl -pe 's/\e\[?.*?[\@-~]//g') # Removing ANSI Escape Codes
    for var in ${php_versions[@]}; do
        mv "ixed.$var.lin" ../
    done
    cd .. && rm -rf source loaders.linux-x86_64.zip

    for php in ${php_versions[@]}; do
        path=$(echo $php | tr -d ".")
        if [[ -f /usr/local/php$path/lib/php.ini ]]; then
        echo "extension=/usr/local/lib/loaders/ixed.$php.lin" >> /usr/local/php$path/lib/php.ini
        systemctl restart php-fpm$path && echo -e "${GREEN} Source Guardian has been successfully installed on $php.${RESET}"
        else
            echo -e "${RED}The file /usr/local/php$path/lib/php.ini doesn't exist${RESET}"
            echo -e "${RED}Source Guardian failed to install on $php.${RESET}"
        fi
    done

}

package_checker() {
    package=$1
    if ! command -v $package &> /dev/null; then
        missing_packages+=("$package")
    else
        echo -e "$package is already installed."
    fi
}

package_installer() {

    if [[ ${#missing_packages[@]} -gt 0 ]]; then

        echo -e "Required packages are being installed.."
        local status=1

        if [[ -f /etc/redhat-release ]]; then
            dnf install -y `echo ${missing_packages[@]}`
            if [[ $? -eq 0 ]]; then
                status=0
            fi
        
        elif [[ -f /etc/debian_version ]]; then
            apt install -y `echo ${missing_packages[@]}`
            if [[ $? -eq 0 ]]; then
                status=0
            fi
        fi

        if [[ $status -eq 0 ]]; then
            echo -e "${GREEN}All required packages have been installed.${RESET}"
        else
            echo -e "${RED}Something went wrong while installing packages.${RESET}"
            exit 1
        fi

    fi

}




for var in ${required_packages[@]}; do
    package_checker $var
done


package_installer
install






