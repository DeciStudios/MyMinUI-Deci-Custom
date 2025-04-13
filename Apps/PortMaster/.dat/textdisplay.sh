#!/bin/bash

# Path to Love2D executable
LOVE_BIN="love"

# Kill any existing text display instances
pkill -f "love"

# Text to display (passed as arguments)
TEXT="$*"
echo "$TEXT"

echo "$LOVE_BIN ./textdisplay/ $TEXT &"
$LOVE_BIN "./textdisplay/" "$TEXT" &

exit 0
