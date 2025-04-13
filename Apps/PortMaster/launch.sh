#!/bin/bash
#
# SPDX-License-Identifier: MIT
#

export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

controlfolder="/MyMinUI/Apps/PortMaster/PortMaster"
cp -r "$controlfolder/../.dat/mods/." "$controlfolder/"


source $controlfolder/control.txt


get_controls


cd "$controlfolder"

> "$controlfolder/log.txt" && exec > >(tee "$controlfolder/log.txt") 2>&1

export TERM=linux

source "$controlfolder/utils/pmsplash.txt"

$controlfolder/../.dat/textdisplay.sh "Starting PortMaster."

$ESUDO chmod -R +x .

## Autoinstallation Code
# This will automatically install zips found within the PortMaster/autoinstall directory using harbourmaster
AUTOINSTALL=$(find "$controlfolder/autoinstall" -type f \( -name "*.zip" -o -name "*.squashfs" \))
if [ -n "$AUTOINSTALL" ]; then
  source "$controlfolder/PortMasterDialog.txt"

  GW=$(PortMasterIPCheck)
  PortMasterDialogInit "no-check"

  PortMasterDialog "messages_begin"

  $controlfolder/../.dat/textdisplay.sh "Auto-installation"

  # Install the latest runtimes.zip
  if [ -f "$controlfolder/autoinstall/runtimes.zip" ]; then
    $controlfolder/../.dat/textdisplay.sh "- Installing runtimes.zip, this could take a minute or two."
    $ESUDO unzip -o "$controlfolder/autoinstall/runtimes.zip" -d "$controlfolder/libs"
    $ESUDO rm -f "$controlfolder/autoinstall/runtimes.zip"
    $controlfolder/../.dat/textdisplay.sh "- SUCCESS: runtimes.zip"
  fi

  for file_name in "$controlfolder/autoinstall"/*.squashfs
  do
    $ESUDO mv -f "$file_name" "$controlfolder/libs"
    $controlfolder/../.dat/textdisplay.sh "- SUCCESS: $(basename $file_name)"
  done

  for file_name in "$controlfolder/autoinstall"/*.zip
  do
    if [[ "$(basename $file_name)" == "PortMaster.zip" ]]; then
      continue
    fi

    if [[ $(PortMasterDialogResult "install" "$file_name") == "OKAY" ]]; then
      $ESUDO rm -f "$file_name"
      $controlfolder/../.dat/textdisplay.sh "- SUCCESS: $(basename $file_name)"
    else
      $controlfolder/../.dat/textdisplay.sh "- FAILURE: $(basename $file_name)"
    fi
  done

  if [ -f "$controlfolder/autoinstall/PortMaster.zip" ]; then
    file_name="$controlfolder/autoinstall/PortMaster.zip"

    if [[ $(PortMasterDialogResult "install" "$file_name") == "OKAY" ]]; then
      $ESUDO rm -f "$file_name"
      $controlfolder/../.dat/textdisplay.sh "- SUCCESS: $(basename $file_name)"
    else
      $controlfolder/../.dat/textdisplay.sh "- FAILURE: $(basename $file_name)"
    fi
  fi

  PortMasterDialog "messages_end"
  if [ -z "$GW" ]; then
    $controlfolder/../.dat/textdisplay.sh "Finished running autoinstall.\n\nNo internet connection present so exiting."
    PortMasterDialogExit
    exit 0
  else
    $controlfolder/../.dat/textdisplay.sh "Finished running autoinstall."
    PortMasterDialogExit
  fi
fi
cp -r "$controlfolder/../.dat/mods/." "$controlfolder/"

# PORTMASTER_CMDS=${PORTMASTER_CMDS:---debug}

export PYSDL2_DLL_PATH="/usr/lib"
$ESUDO rm -f "${controlfolder}/.pugwash-reboot"
while true; do
  $ESUDO ./pugwash $PORTMASTER_CMDS

  if [ ! -f "${controlfolder}/.pugwash-reboot" ]; then
    break;
  fi

  $ESUDO rm -f "${controlfolder}/.pugwash-reboot"
done
cp -r "$controlfolder/../.to_overwrite/*" "$controlfolder/"

unset LD_LIBRARY_PATH
unset SDL_GAMECONTROLLERCONFIG
$ESUDO systemctl restart oga_events &

if [ -f "${controlfolder}/.emustation-refresh" ]; then
  $ESUDO rm -f "${controlfolder}/.emustation-refresh"
  $ESUDO systemctl restart emustation
elif [ -f "${controlfolder}/.weston-refresh" ]; then
  $ESUDO rm -f "${controlfolder}/.weston-refresh"
  $ESUDO systemctl restart ${UI_SERVICE}
elif [ -f "${controlfolder}/.emulationstation-refresh" ]; then
  $ESUDO rm -f "${controlfolder}/.emulationstation-refresh"
  $ESUDO systemctl restart emulationstation
elif [ -f "${controlfolder}/.batocera-es-refresh" ]; then
  $ESUDO rm -f "${controlfolder}/.batocera-es-refresh"
  # BROKEN :(
  # batocera-es-swissknife --restart
  curl http://localhost:1234/reloadgames
fi
