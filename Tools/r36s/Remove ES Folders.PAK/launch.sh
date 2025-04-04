#!/bin/bash

#-----------------------------------
# ROM Folders Wiper
# Based on Plymouth-cp.sh by Sucharek233
#---------------------------------++

#Shell setup start
CURR_TTY="/dev/tty0" #CHANGE TO TTY1!!!!!

sudo chmod 666 $CURR_TTY
reset

# hide cursor
printf "\e[?25l" > $CURR_TTY
dialog --clear

if test ! -z "$(cat /home/ark/.config/.DEVICE | grep RG503 | tr -d '\0')"
then
  height="20"
  width="60"
fi

export TERM=linux
export XDG_RUNTIME_DIR=/run/user/$UID/

if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
  if test ! -z "$(cat /home/ark/.config/.DEVICE | grep RG503 | tr -d '\0')"
  then
    sudo setfont /usr/share/consolefonts/Lat7-TerminusBold20x10.psf.gz
  else
    sudo setfont /usr/share/consolefonts/Lat7-TerminusBold22x11.psf.gz
  fi
else
  sudo setfont /usr/share/consolefonts/Lat7-Terminus16.psf.gz
fi

pgrep -f gptokeyb | sudo xargs kill -9
pgrep -f osk.py | sudo xargs kill -9
printf "\033c" > $CURR_TTY
printf "Starting Folders Wiper.  Please wait..." > $CURR_TTY
#Shell setup end

# Define exclusions for each directory
ROMS_EXCLUSIONS=(
  "tools",
  "MyMinUI"
  # Add more exclusions for /roms as needed
)

ROMS2_EXCLUSIONS=(
  # Add more exclusions for /roms2 as needed
)

height="15"
width="55"

BACKTITLE="ROM Folders Wiper"

ExitMenu() {
  printf "\033c" > $CURR_TTY
  if [[ ! -z $(pgrep -f gptokeyb) ]]; then
    pgrep -f gptokeyb | sudo xargs kill -9
  fi
  if [[ ! -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    sudo setfont /usr/share/consolefonts/Lat7-Terminus20x10.psf.gz
  fi
  exit 0
}

# Function to display warning and confirm deletion
ConfirmDeletion() {
  while true; do
    dialog --clear \
      --backtitle "$BACKTITLE" \
      --title "WARNING" \
      --yes-label "Ok" \
      --no-label "Exit" \
      --yesno "Please ensure that all your roms have been moved from /roms or /roms2 before running this script! It will completely erase any data inside them except for excluded folders." 8 60 > $CURR_TTY

    response=$?
    case $response in
      0) # User selected Ok
        DeleteFolders
        ;;
      1) # User selected Exit
        ExitMenu
        ;;
    esac
  done
}

# Function to display list of folders that will be deleted
ListFolders() {
  folderList=""

  # List folders in /roms
  echo "Scanning folders in /roms..."
  for folder in /roms/*; do
    if [[ -d "$folder" ]]; then
      folderName=$(basename "$folder")
      if [[ ! " ${ROMS_EXCLUSIONS[@]} " =~ " ${folderName} " ]]; then
        folderList="$folderList /roms/$folderName\n"
      fi
    fi
  done

  # List folders in /roms2
  echo "Scanning folders in /roms2..."
  for folder in /roms2/*; do
    if [[ -d "$folder" ]]; then
      folderName=$(basename "$folder")
      if [[ ! " ${ROMS2_EXCLUSIONS[@]} " =~ " ${folderName} " ]]; then
        folderList="$folderList /roms2/$folderName\n"
      fi
    fi
  done

  # Display excluded folders
  excludedList="In /roms: "
  for excl in "${ROMS_EXCLUSIONS[@]}"; do
    excludedList="$excludedList $excl,"
  done
  excludedList="${excludedList%, }\n\nIn /roms2: "
  for excl in "${ROMS2_EXCLUSIONS[@]}"; do
    excludedList="$excludedList $excl,"
  done
  excludedList="${excludedList%, }"

  dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "Folders to Delete" \
    --msgbox "The following folders will be deleted:\n\n$folderList\nExcluded folders:\n$excludedList" 15 70 > $CURR_TTY

  ConfirmDeletion
}

# Function to actually delete the folders
DeleteFolders() {
  # Count total folders to delete
  romsCount=0
  roms2Count=0

  # Count folders in /roms
  for folder in /roms/*; do
    if [[ -d "$folder" ]]; then
      folderName=$(basename "$folder")
      if [[ ! " ${ROMS_EXCLUSIONS[@]} " =~ " ${folderName} " ]]; then
        ((romsCount++))
      fi
    fi
  done

  # Count folders in /roms2
  for folder in /roms2/*; do
    if [[ -d "$folder" ]]; then
      folderName=$(basename "$folder")
      if [[ ! " ${ROMS2_EXCLUSIONS[@]} " =~ " ${folderName} " ]]; then
        ((roms2Count++))
      fi
    fi
  done

  total=$((romsCount + roms2Count))
  current=0

  # Create progress dialog
  dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "Deleting Folders" \
    --gauge "Starting deletion process..." 10 70 0 > $CURR_TTY

  # Delete folders in /roms
  for folder in /roms/*; do
    if [[ -d "$folder" ]]; then
      folderName=$(basename "$folder")
      if [[ ! " ${ROMS_EXCLUSIONS[@]} " =~ " ${folderName} " ]]; then
        current=$((current + 1))
        percent=$((current * 100 / total))

        dialog --clear \
          --backtitle "$BACKTITLE" \
          --title "Deleting Folders" \
          --gauge "Deleting /roms/$folderName... ($current/$total)" 10 70 $percent > $CURR_TTY

        sudo rm -rf "/roms/$folderName"
        sleep 0.5
      fi
    fi
  done

  # Delete folders in /roms2
  for folder in /roms2/*; do
    if [[ -d "$folder" ]]; then
      folderName=$(basename "$folder")
      if [[ ! " ${ROMS2_EXCLUSIONS[@]} " =~ " ${folderName} " ]]; then
        current=$((current + 1))
        percent=$((current * 100 / total))

        dialog --clear \
          --backtitle "$BACKTITLE" \
          --title "Deleting Folders" \
          --gauge "Deleting /roms2/$folderName... ($current/$total)" 10 70 $percent > $CURR_TTY

        sudo rm -rf "/roms2/$folderName"
        sleep 0.5
      fi
    fi
  done

  # Show completion message
  dialog --clear \
    --backtitle "$BACKTITLE" \
    --title "Operation Complete" \
    --msgbox "All folders have been deleted except for exclusions!" 6 60 > $CURR_TTY

  MainMenu
}

MainMenu() {
  while true; do
    mainselection=(dialog \
        --backtitle "$BACKTITLE" \
        --title "" \
        --no-collapse \
        --clear \
        --cancel-label "Select + Start to Exit" \
        --menu "Main Menu" $height $width 15)
        mainoptions=( 1 "List folders to delete" 2 "Start deletion process" 3 "Exit" )
        mainchoices=$("${mainselection[@]}" "${mainoptions[@]}" 2>&1 > $CURR_TTY)
        if [[ $? != 0 ]]; then
          exit 1
        fi
    for mchoice in $mainchoices; do
      case $mchoice in
        1) ListFolders ;;
        2) ConfirmDeletion ;;
        3) ExitMenu ;;
      esac
    done
  done
}

#
# Joystick controls
#
# only one instance

sudo chmod 666 /dev/uinput
export SDL_GAMECONTROLLERCONFIG_FILE="/opt/inttools/gamecontrollerdb.txt"
if [[ ! -z $(pgrep -f gptokeyb) ]]; then
  pgrep -f gptokeyb | sudo xargs kill -9
fi
/opt/inttools/gptokeyb -1 "wipe-folders.sh" -c "/opt/inttools/keys.gptk" > /dev/null 2>&1 &
printf "\033c" > $CURR_TTY
dialog --clear
trap ExitMenu EXIT

MainMenu
