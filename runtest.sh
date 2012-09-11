#!/bin/bash

. functions.sh

# Path to the Tao Presentations executable
case $(uname) in
  Darwin)
    TAO="$HOME/work/tao/install/Tao Presentations.app/Contents/MacOS/Tao Presentations"
    ;;
  Linux)
    export LD_LIBRARY_PATH="$HOME/work/tao/install"
    TAO="$HOME/work/tao/install/Tao"
    ;;
esac

[ "$@" ] || die "No file"

# Default values for environment variables
[ "$CAPTURE_DIR" ] || export CAPTURE_DIR=out

[ -e "$CAPTURE_DIR" ] || mkdir -p "$CAPTURE_DIR"

for f in "$@" ; do
  "$TAO" -nosplash -p capture.xl $f
done
