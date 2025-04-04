#!/bin/bash

# Set the script directory as the base path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set path to love executable and love file
DAT="$SCRIPT_DIR/data/"
LIB="$DAT/lib"


# Set LD_LIBRARY_PATH to include the love library directory
export LD_LIBRARY_PATH="$LIB:$LD_LIBRARY_PATH"
cd "$DAT" || exit
# Run the love file with the love binary
./bin/love plymouth_ui.love > ../log.txt 2>&1

# Exit with the same status as the love process
exit $?
