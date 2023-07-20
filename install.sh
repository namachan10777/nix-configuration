#!/bin/sh
set -eux

if [ $# != 2 ]; then
    echo "Usage: install.sh <src> <dest>"
    exit 0
fi

platform="$(uname)"

if [ "$platform" = "Linux" ]; then
    for f in $(find $1 -type f); do
        install -m 644 -D "$f" "$2/$f"
    done
elif [ "$platform" = "Darwin" ]; then
    for f in $(find $1); do
        if [ -d "$f" ]; then
            install -d -m 755 "$f" "$2/$f"
        else
            install -m 644 "$f" "$2/$f"
        fi
    done
fi