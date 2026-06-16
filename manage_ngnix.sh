#!/bin/bash

# Directories
AVAIL="/etc/nginx/sites-available"
ENABL="/etc/nginx/sites-enabled"

# Ensure we have whiptail installed for the UI
if ! command -v whiptail &> /dev/null; then
    sudo apt-get install -y whiptail
fi

while true; do
    CHOICE=$(whiptail --title "NCIS Domain Management" --menu "Choose an action:" 15 60 4 \
        "1" "Start a Domain (Enable)" \
        "2" "Stop a Domain (Disable)" \
        "3" "View Live Logs" \
        "4" "Exit" 3>&1 1>&2 2>&3)

    case $CHOICE in
        1) # START DOMAIN
            SITES=($(ls $AVAIL))
            MENU_LIST=()
            for site in "${SITES[@]}"; do
                status="OFF"
                [ -f "$ENABL/$site" ] && status="ON"
                MENU_LIST+=("$site" "[$status]")
            done
            
            PICK=$(whiptail --title "Enable Domain" --menu "Select a domain to start:" 20 60 10 "${MENU_LIST[@]}" 3>&1 1>&2 2>&3)
            
            if [ -n "$PICK" ]; then
                sudo ln -sf "$AVAIL/$PICK" "$ENABL/"
                sudo nginx -t && sudo systemctl reload nginx
                whiptail --msgbox "$PICK has been enabled and Nginx reloaded." 8 45
            fi
            ;;

        2) # STOP DOMAIN
            SITES=($(ls $ENABL))
            if [ ${#SITES[@]} -eq 0 ]; then
                whiptail --msgbox "No domains are currently active." 8 45
                continue
            fi
            
            PICK=$(whiptail --title "Disable Domain" --menu "Select a domain to stop:" 20 60 10 $(ls $ENABL | awk '{print $1 " [ACTIVE]"}') 3>&1 1>&2 2>&3)
            
            if [ -n "$PICK" ]; then
                sudo rm "$ENABL/$PICK"
                sudo nginx -t && sudo systemctl reload nginx
                whiptail --msgbox "$PICK has been disabled." 8 45
            fi
            ;;

        3) # VIEW LOGS
            SITES=($(ls $AVAIL))
            PICK=$(whiptail --title "View Logs" --menu "Select a domain to tail:" 20 60 10 $(ls $AVAIL | awk '{print $1 " [LOGS]"}') 3>&1 1>&2 2>&3)
            
            if [ -n "$PICK" ]; then
                # Assumes your log naming convention is domain-access.log
                # Adjust path if using standard /var/log/nginx/access.log
                LOG_PATH="/var/log/nginx/${PICK}_access.log"
                if [ -f "$LOG_PATH" ]; then
                    clear
                    echo "Press CTRL+C to stop viewing logs..."
                    sudo tail -f "$LOG_PATH"
                else
                    whiptail --msgbox "Log file not found at $LOG_PATH. Check your Nginx config for this domain." 10 50
                fi
            fi
            ;;

        4|*)
            exit 0
            ;;
    esac
done

