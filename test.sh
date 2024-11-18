#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

banner() {
    clear
    echo -e "${GREEN}               __                  __           __         "
    echo " ___ ________ / /__ ____      ___ / /____ _____/ /____ ____"
    echo "/ _ \`/ __(_-</ / _ \`/ _ \    (_-</ __/ _ \`/ __/ __/ -_) __/"
    echo "\_,_/_/ /___/_/\_,_/_//_/   /___/\__/\_,_/_/  \__/\__/_/   "
    echo "   __            __                  __                    "
    echo "  / /  ___ _____/ /__ ___  ___ _____/ /__                  "
    echo " / _ \/ _ \`/ __/  '_// _ \/ _ \`/ __/  '_/                  "
    echo "/_.__/\_,_/\__/_/\_\/ .__/\_,_/\__/_/\_\                    "
    echo "                   /_/                                      "
    echo ""
}

trap 'ctrl_c' SIGINT
ctrl_c_count=0
ctrl_c() {
    ((ctrl_c_count++))
    if [ $ctrl_c_count -ge 2 ]; then
        echo -e "\n${RED}Exiting tool...${NC}"
        exit 0
    else
        echo -e "\n${YELLOW}Operation stopped. Returning to the main menu...${NC}"
        sleep 1
        ctrl_c_count=0
        main_menu
    fi
}

check_and_install() {
    command -v $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}$1 is not installed. Do you want to install it? (y/n): ${NC}"
        read answer
        if [[ "$answer" == "y" ]]; then
            echo -e "${BLUE}Installing $1...${NC}"
            sudo apt-get install -y $1
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}$1 installed successfully!${NC}"
                return 0
            else
                echo -e "${RED}Failed to install $1. Returning to the main menu...${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}$1 not installed. Returning to the main menu...${NC}"
            return 1
        fi
    fi
    return 0
}

main_menu() {
    while true; do
        banner
        echo -e "${GREEN}** LINUX QUICK HELP TOOL **${NC}"
        echo -e "${BLUE}1. Display IP Address"
        echo "2. View System Information"
        echo "3. Check Disk Usage"
        echo "4. Show CPU Information"
        echo "5. Show Memory (RAM) Usage"
        echo "6. Show Storage Status"
        echo "7. Scan Disk (fsck)"
        echo "8. Disable Firewall"
        echo "9. Enable Firewall"
        echo "10. Clean Unnecessary Files (/tmp folder)"
        echo "11. Perform Ping Test"
        echo "12. Perform Traceroute"
        echo "13. Clear DNS Cache"
        echo "14. Show ARP Table"
        echo "15. Show Routing Table"
        echo "16. Show Wi-Fi Passwords"
        echo -e "0. Exit${NC}"
        echo -e "${GREEN}**${NC}"

        read -p "Choose an option: " choice
        echo -e "${YELLOW}Processing...${NC}"

        case $choice in
            1) ip addr show ;;
            2) uname -a; lsb_release -a ;;
            3) df -h ;;
            4) check_and_install lscpu && lscpu ;;
            5) free -h ;;
            6) lsblk ;;
            7) echo "Root privileges required!"; sudo fsck ;;
            8) check_and_install ufw && sudo ufw disable ;;
            9) check_and_install ufw && sudo ufw enable ;;
            10) sudo rm -rf /tmp/* ;;
            11) read -p "Enter address to ping: " address; ping -c 4 $address ;;
            12) check_and_install traceroute && { read -p "Enter target address: " target; traceroute $target; } ;;
            13) check_and_install resolvectl && sudo resolvectl flush-caches ;;
            14) ip neigh ;;
            15) ip route ;;
            16) check_and_install nmcli && sudo nmcli dev wifi list ;;
            0) echo -e "${GREEN}Exiting...${NC}"; break ;;
            *) echo -e "${RED}Invalid choice, please try again!${NC}" ;;
        esac

        echo -e "${GREEN}Operation completed.${NC}"
        read -p "Press any key to return to the main menu..."
    done
}

main_menu
