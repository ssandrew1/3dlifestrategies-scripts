#!/bin/bash

# Set a title for our dialogs
TITLE="Whiptail Demo for Experts"
# Global dimensions for dialogs (height width)
HEIGHT=15
WIDTH=70

# --- 1. Message Box (simple display) ---
whiptail --title "$TITLE" --msgbox "Welcome to the Whiptail demonstration, expert shell programmer!\n\nPress Enter to continue..." $HEIGHT $WIDTH

# --- 2. Yes/No Box (decision making) ---
if (whiptail --title "$TITLE" --yesno "Do you want to see an input box next?" $HEIGHT $WIDTH); then
    whiptail --title "$TITLE" --msgbox "You chose Yes!" $HEIGHT $WIDTH
else
    whiptail --title "$TITLE" --msgbox "You chose No. Skipping input box." $HEIGHT $WIDTH
fi

# --- 3. Input Box (get user text) ---
# The 3>&1 1>&2 2>&3 magic redirects whiptail's output (the input text)
# from stderr to stdout, so it can be captured by `$(...)`.
NAME=$(whiptail --title "$TITLE" --inputbox "What's your name, expert?" $HEIGHT $WIDTH "Shell Hacker" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    whiptail --title "$TITLE" --msgbox "Hello, $NAME!" $HEIGHT $WIDTH
else
    whiptail --title "$TITLE" --msgbox "You cancelled the input. No name for you!" $HEIGHT $WIDTH
fi

# --- 4. Password Box (hidden input) ---
PASS=$(whiptail --title "$TITLE" --passwordbox "Enter a secret password (it will be hidden):" $HEIGHT $WIDTH 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    whiptail --title "$TITLE" --msgbox "Your secret: $PASS (Don't worry, I won't store it!)" $HEIGHT $WIDTH
else
    whiptail --title "$TITLE" --msgbox "Password input cancelled." $HEIGHT $WIDTH
fi

# --- 5. Menu Box (single selection from a list) ---
OPTION=$(whiptail --title "$TITLE" --menu "Choose your favorite shell:" $HEIGHT $WIDTH 5 \
"bash" "The GNU Bourne-Again Shell" \
"zsh" "Z Shell, often with Oh My Zsh" \
"fish" "Friendly Interactive Shell" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    whiptail --title "$TITLE" --msgbox "You picked: $OPTION" $HEIGHT $WIDTH
else
    whiptail --title "$TITLE" --msgbox "Menu cancelled." $HEIGHT $WIDTH
fi

# --- 6. CheckList Box (multiple selections) ---
# Note: Checklist returns selected items in quotes, space-separated
CHOICES=$(whiptail --title "$TITLE" --checklist \
"Select some scripting languages you know:" $HEIGHT $WIDTH 4 \
"Python" "Powerful and Versatile" ON \
"Perl" "The Swiss Army Chainsaw" OFF \
"Ruby" "Fun and Object-Oriented" OFF \
"NodeJS" "JavaScript for the Server" ON 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    whiptail --title "$TITLE" --msgbox "You selected: $CHOICES" $HEIGHT $WIDTH
else
    whiptail --title "$TITLE" --msgbox "Checklist cancelled." $HEIGHT $WIDTH
fi

# --- 7. Radiolist Box (single selection, visual radio buttons) ---
COLOR=$(whiptail --title "$TITLE" --radiolist \
"Pick your favorite color:" $HEIGHT $WIDTH 3 \
"Red" "A primary color" OFF \
"Green" "Color of nature" ON \
"Blue" "Another primary color" OFF 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    whiptail --title "$TITLE" --msgbox "You picked: $COLOR" $HEIGHT $WIDTH
else
    whiptail --title "$TITLE" --msgbox "Radiolist cancelled." $HEIGHT $WIDTH
fi

# --- 8. Progress/Gauge Box (demonstrative, requires external process) ---
# This part uses a 'here document' (<<EOF) to feed input to whiptail's gauge.
(
for i in $(seq 0 25 100) ; do
    echo $i
    sleep 0.5 # <--- Add this for a half-second pause!
done
) | whiptail --title "$TITLE" --gauge "Simulating a long task..." 6 50 0

echo "Almost done, back to shell ..."
read go

whiptail --title "$TITLE" --msgbox "Demo ALMOST complete! Hope that gave you a good overview of whiptail." $HEIGHT $WIDTH
