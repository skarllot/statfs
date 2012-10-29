#!/bin/bash
# example   Example module for statfs
#
# description:  Example module for statfs
# param1:       Path for mounted statfs
# param2:       Verbose mode (0=no | 1=yes)

MOD_NAME=example
DEST="$1/$MOD_NAME"

if [ ! -d "$DEST" ]; then
    [ $2 -eq 1 ] && echo "Directory $DEST cannot be found, creating..."
    mkdir -p "$DEST"
fi

date > "$DEST/update"

