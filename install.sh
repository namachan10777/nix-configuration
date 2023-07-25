#!/bin/sh
set -eux

if [ $# != 2 ]; then
    echo "Usage: install.sh <src> <dest>"
    exit 0
fi

platform="$(uname)"

if [ "$platform" = "Linux" ]; then
	find "$1" -type f -exec install -m 644 -D "$1" "$2/{}" \;
elif [ "$platform" = "Darwin" ]; then
	find "$1" -type d -exec install -d -m 755 "{}" "$2/{}" \;
	find "$1" -type f -exec install -m 644 "{}" "$2/{}" \;
fi
