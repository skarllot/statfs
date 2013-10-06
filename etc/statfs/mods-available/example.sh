#!/bin/bash
# description:  Example module for statfs
#

MOD_NAME=example

show_help() {
    echo "Usage:
    $MOD_NAME       update <directory> [-v]
    $MOD_NAME       default-frequency
    $MOD_NAME       dependencies
    $MOD_NAME       name

Actions:
    default-frequency   gets default update frequency (in seconds)
    dependencies        returns which modules this module depends
    name                returns this module name
    update              updates info provided by this module

Options:
    directory           path to mounted statfs
    -h, --help          show this help message and exit
    -v, --verbose       verbose output"
}

update() {
    if [ ! -d "$1" ]; then
        echo "Directory '$1' cannot be found" >&2
        exit 1
    fi

    FNAME=$1/update
    if [ $VERBOSE -eq 1 ]; then
        if [ ! -f "$FNAME" ]; then
            echo "File '$FNAME' does not exist, will be created"
        fi
    fi
    date > "$FNAME"
}

show_frequency() {
    echo "60"
}

show_dependencies() {
    echo ""
}

show_name() {
    echo "$MOD_NAME"
}

incompatible_args() {
    echo "$MOD_NAME: You may not specify more than one '-uSD' option" >&2
    echo "Refer to -h for more information" >&2
    exit 2
}

if (($# == 0)); then
    echo "$MOD_NAME: No arguments given (use -h for help)" >&2
    exit 1
fi

getopt -T > /dev/null
if [ $? -eq 4 ]; then
    ARGS=$(getopt --name "$MOD_NAME" \
        --long help,verbose \
        --options hv -- "$@")
else
    ARGS=$(getopt hv "$@")
fi
if [ $? -ne 0 ]; then
    echo "$MOD_NAME: usage error (use -h for help)" >&2
    exit 2
fi
eval set -- $ARGS

VERBOSE=0
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=1
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

if [ $# -eq 0 ]; then
    echo "$MOD_NAME: You must specify one valid action" >&2
    echo "Refer to -h for more information"
    exit 2
elif [ $# -eq 1 ]; then
    case "$1" in
        default-frequency)
            show_frequency
            ;;
        dependencies)
            show_dependencies
            ;;
        name)
            show_name
            ;;
        update)
            echo "$MOD_NAME: Missing 'directory' argument" >&2
            echo "Refer to -h for more information"
            exit 2
            ;;
        *)
            echo "$MOD_NAME: You must specify one valid action" >&2
            echo "Refer to -h for more information"
            exit 2
    esac
elif [ $# -eq 2 ]; then
    case "$1" in
        update)
            update $2
            ;;
        *)
            echo "$MOD_NAME: You must specify one valid action" >&2
            echo "Refer to -h for more information"
            exit 2
    esac
else
    echo "$MOD_NAME: Invalid arguments found (use -h for help)" >&2
    exit 2
fi

# vim: set ts=4 et
