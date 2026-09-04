#!/bin/bash

ESC=$(printf '\033')
RED="${ESC}[91m"
GREEN="${ESC}[92m"
YELLOW="${ESC}[93m"
BLUE="${ESC}[94m"
CYAN="${ESC}[96m"
RESET="${ESC}[0m"

# Check for ADB
if ! command -v adb &> /dev/null; then
    echo -e "\n${YELLOW}[INFO] ADB not found! Attempting to detect distro...${RESET}"
    echo "----------------------------------------"

    INSTALL_CMD=""
    
    if command -v pacman &>/dev/null; then
        echo -e "[+] Found: pacman (Arch Linux based)"
        INSTALL_CMD="sudo pacman -Syu --noconfirm android-tools"
    elif command -v dnf &>/dev/null; then
        echo -e "[+] Found: dnf (Modern RHEL/Fedora/CentOS)"
        INSTALL_CMD="sudo dnf install -y android-tools"
    elif command -v apt &>/dev/null || command -v apt-get &>/dev/null; then
        echo -e "[+] Found: apt/apt-get (Debian/Ubuntu based)"
        INSTALL_CMD="sudo apt update && sudo apt install -y adb"
    elif command -v zypper &>/dev/null; then
        echo -e "[+] Found: zypper (SUSE/openSUSE)"
        INSTALL_CMD="sudo zypper install -y android-tools"
    elif command -v apk &>/dev/null; then
        echo -e "[+] Found: apk (Alpine Linux)"
        INSTALL_CMD="sudo apk add android-tools"
    elif command -v pkg &>/dev/null; then
        echo -e "[+] Found: pkg (Termux)"
        INSTALL_CMD="pkg install -y android-tools"
    elif command -v brew &>/dev/null; then
        echo -e "[+] Found: brew (Homebrew)"
        INSTALL_CMD="brew install android-platform-tools"
    fi

    echo "----------------------------------------"

    if [ -n "$INSTALL_CMD" ]; then
        read -p "ADB is missing. Do you want to install it now? [Y/n]: " CHOICE
        CHOICE=$(echo "$CHOICE" | tr '[:upper:]' '[:lower:]')

        if [ "$CHOICE" = "n" ] || [ "$CHOICE" = "no" ]; then
            echo -e "${RED}[ERROR] ADB installation aborted by user.${RESET}"
            read -n 1 -s -r -p "Press any key to exit..."
            exit 1
        fi

        echo -e "${YELLOW}[*] Executing: $INSTALL_CMD${RESET}"
        eval "$INSTALL_CMD"
        
        if command -v adb &> /dev/null; then
            echo -e "${GREEN}[SUCCESS] ADB installed successfully!${RESET}\n"
            sleep 2
        else
            echo -e "${RED}[ERROR] Installation failed. Please install ADB manually.${RESET}"
            read -n 1 -s -r -p "Press any key to exit..."
            exit 1
        fi
    else
        echo -e "${RED}[ERROR] Could not reliably determine the package manager to install ADB.${RESET}"
        echo -e "Please install 'android-tools' or 'adb' manually."
        read -n 1 -s -r -p "Press any key to exit..."
        exit 1
    fi
fi

CHECK_DEVICE_CONNECTED() {
    echo "Waiting for device (Ensure USB Debugging is ON)..."
    adb wait-for-device

    if adb devices | grep -q "unauthorized"; then
        echo -e "\n  ${RED}[ERROR] ${YELLOW}Device unauthorized!${RESET}"
        echo -e "\nPlease unlock your phone and allow USB debugging (RSA fingerprint)."
        read -n 1 -s -r -p "Press any key to return to menu..."
        return 1
    fi

    if ! adb devices | grep -v "List of devices" | grep -q "device$"; then
        echo -e "\n${RED}[ERROR] No device detected!${RESET}"
        echo -e "\nPlease check USB connection, driver, and developer options."
        read -n 1 -s -r -p "Press any key to return to menu..."
        return 1
    fi
    return 0
}

MENU() {
    while true; do
        clear
        echo -e "           ${BLUE}____ _____ __  __ ___ _   _ ___"
        echo -e "          / ___| ____|  \/  |_ _| \ | |_ _|"
        echo -e "         | |  _|  _| | |\/| || ||  \| || |"
        echo -e "         | |_| | |___| |  | || || |\  || |"
        echo -e "          \____|_____|_|  |_|___|_| \_|___|${RESET}"
        echo ""
        echo -e "${CYAN}##################################################${RESET}"
        echo -e "${CYAN}#${RESET}            ${BLUE}G${RED}o${YELLOW}o${BLUE}g${GREEN}l${RED}e${RESET} ${BLUE}Gemini${RESET} Setup Tool           ${CYAN}#${RESET}"
        echo -e "${CYAN}#${RESET}           ${YELLOW}by PhaPhePha & Vanphat111${RESET}           ${CYAN}#${RESET}"
        echo -e "${CYAN}##################################################${RESET}"
        echo ""
        echo "[1] Setup Google Assistant / Gemini"
        echo "[2] Restore Xiaomi AI (Xiao AI)"
        echo "[3] Check Assistant Status"
        echo "[0] Exit"
        echo ""

        read -p "Select an option: " OPTION

        case "$OPTION" in
            1) SETUP ;;
            2) RESTORE ;;
            3) CHECK ;;
            0) exit 0 ;;
            *) 
                echo -e "\nInvalid option!"
                read -n 1 -s -r -p "Press any key to continue..."
                ;;
        esac
    done
}

SETUP() {
    clear
    echo -e "${YELLOW}============================================${RESET}"
    echo -e "        ${CYAN}Setup Google Gemini Assistant${RESET}"
    echo -e "${YELLOW}============================================${RESET}"
    echo ""

    echo "[1/6] Checking device connection..."
    CHECK_DEVICE_CONNECTED || return

    echo -e "\n${GREEN}Device detected successfully.${RESET}"

    if ! adb shell pm list packages | grep -q "com.google.android.googlequicksearchbox"; then
        echo -e "\n${RED}[ERROR]${RESET} Google App not installed!"
        read -n 1 -s -r -p "Press any key to return to menu..."
        return
    fi

    echo -e "\n[2/6] Granting microphone permission..."
    if adb shell pm grant com.google.android.googlequicksearchbox android.permission.RECORD_AUDIO 2>/dev/null; then
        echo -e "${GREEN}SUCCESS!${RESET}"
    else
        echo -e "${RED}FAILED! (Check USB Debugging (Secure Settings) toggles in Developer Options)${RESET}"
        read -n 1 -s -r -p "Press any key to return to menu..."
        return
    fi

    echo -e "\n[3/6] Setting Assistant on Power button..."
    if adb shell settings put global power_button_long_press 5 2>/dev/null; then
        echo -e "${GREEN}ACTIVATED!${RESET}"
    else
        echo "FAILED!"
        read -n 1 -s -r -p "Press any key to return to menu..."
        return
    fi

    echo -e "\n[4/6] Setting Google App as Default Assistant Service..."
    if adb shell settings put secure assistant com.google.android.googlequicksearchbox/com.google.android.voiceinteraction.GsaVoiceInteractionService &>/dev/null; then
        echo -e "${GREEN}SET AS DEFAULT!${RESET}"
    else
        echo -e "${YELLOW}WARNING: Could not set default assistant app via secure settings.${RESET}"
    fi

    echo -e "\n[5/6] Verifying power button setting..."
    VALUE=$(adb shell settings get global power_button_long_press | tr -d '\r\n')
    echo "Current value: $VALUE"

    if [ "$VALUE" != "5" ]; then
        echo "Verification failed!"
        read -n 1 -s -r -p "Press any key to return to menu..."
        return
    fi
    echo -e "${GREEN}VERIFIED!${RESET}"

    echo -e "\n[6/6] Removing Xiaomi Voice Assistant..."
    TEMP_RES=$(adb shell pm uninstall -k --user 0 com.miui.voiceassist 2>&1)

    if echo "$TEMP_RES" | grep -q "Success"; then
        echo -e "${GREEN}UNINSTALLED!${RESET}"
        COMPLETE
    elif echo "$TEMP_RES" | grep -q "not installed for 0"; then
        echo -e "${CYAN}Xiaomi Voice Assistant is already removed.${RESET}"
        COMPLETE
    else
        echo -e "${RED}FAILED!${RESET}"
        echo "$TEMP_RES"
        read -n 1 -s -r -p "Press any key to return to menu..."
        return
    fi
}

COMPLETE() {
    echo -e "\n============================================"
    echo -e "                  ${GREEN}[ACTIVATED]${RESET}               "
    echo -e "============================================"
    echo ""
    echo -e "${YELLOW}Press any key to return to the menu.${RESET}"
    read -n 1 -s -r
}

RESTORE() {
    clear
    echo -e "${YELLOW}============================================${RESET}"
    echo -e "              ${CYAN}Restore Xiaomi AI${RESET}"
    echo -e "${YELLOW}============================================${RESET}"
    echo ""

    CHECK_DEVICE_CONNECTED || return

    echo -e "\n[*] Re-installing Xiaomi Voice Assistant..."
    adb shell cmd package install-existing com.miui.voiceassist &> /dev/null

    echo "[*] Restoring default assistant service allocation..."
    adb shell settings put secure assistant com.miui.voiceassist/com.miui.voiceassist.VoiceService &>/dev/null
    
    echo -e "\n${GREEN}Xiaomi AI restored successfully!${RESET}"
    echo -e "\n${YELLOW}Press any key to return to the menu.${RESET}"
    read -n 1 -s -r
}

CHECK() {
    clear
    echo -e "${YELLOW}============================================${RESET}"
    echo -e "            ${CYAN}Assistant Status Check${RESET}"
    echo -e "${YELLOW}============================================${RESET}"
    echo ""

    CHECK_DEVICE_CONNECTED || return

    MODEL=$(adb shell getprop ro.product.model | tr -d '\r\n')
    ANDROID=$(adb shell getprop ro.build.version.release | tr -d '\r\n')
    HYPEROS=$(adb shell getprop ro.miui.ui.version.name | tr -d '\r\n')

    echo "Device  : $MODEL"
    echo "Android : $ANDROID"
    echo "HyperOS : $HYPEROS"
    echo ""

    VALUE=$(adb shell settings get global power_button_long_press | tr -d '\r\n')
    CURRENT_ASSISTANT=$(adb shell settings get secure assistant | tr -d '\r\n')
    
    echo "Power Button Value: $VALUE"
    
    if [ "$VALUE" = "5" ] && echo "$CURRENT_ASSISTANT" | grep -q "googlequicksearchbox"; then
        echo -e "${GREEN}[ACTIVE]${RESET} Google Gemini/Assistant is fully enabled as default."
    else
        echo -e "${RED}[INACTIVE]${RESET} Google Gemini/Assistant is not fully configured."
    fi

    echo -e "\n${YELLOW}Press any key to return to the menu.${RESET}"
    read -n 1 -s -r
}

adb kill-server &>/dev/null
adb start-server &>/dev/null

MENU