#!/bin/bash

APP_DIR=/MyMinUI/Apps/PortMaster/
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR" || exit

echo "NEW LAUNCH" >> ./log.txt
"$APP_DIR/launch.sh" >> ./log.txt 2>&1