#!/bin/bash
# example   Example module for local-tmpfs
#
# description:  Example module for local-tmpfs
# param1:       Path for mounted local-tmpfs
# param2:       Verbose mode (0=no | 1=yes)

MOD_NAME=example
DEST="$1/$MOD_NAME"

if [ ! -d "$DEST" ]; then
    [ $2 -eq 1 ] && echo "Directory $DEST cannot be found, creating..."
    mkdir -p "$DEST"
fi

date > "$DEST/update"

