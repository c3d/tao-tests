#!/bin/bash

# Path to the Tao Presentations executable
TAO="$HOME/work/tao/install/Tao Presentations.app/Contents/MacOS/Tao Presentations"

# Default values for environment variables
[ "$CAPTURE_DIR" ] || export CAPTURE_DIR=out

[ -e "$CAPTURE_DIR" ] || mkdir -p "$CAPTURE_DIR"

"$TAO" -nosplash -p capture.xl "$@"
