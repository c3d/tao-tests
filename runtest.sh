#!/bin/bash

. functions.sh

# Set path to the Tao Presentations executable
: ${ENV_FILE:="$HOME/.tao_tests_env"}
if [ "$ENV_FILE" -a -r "$ENV_FILE" ] ; then
  . "$ENV_FILE"
else
  # Defaults
  case $(uname) in
    Darwin)
      TAO="$HOME/work/tao/install/Tao Presentations.app/Contents/MacOS/Tao Presentations"
      ;;
    Linux)
      export LD_LIBRARY_PATH="$HOME/work/tao/install"
      TAO="$HOME/work/tao/install/Tao"
      ;;
  esac
fi

[ "$@" ] || die "No file"

# Default values for environment variables
[ "$CAPTURE_DIR" ] || export CAPTURE_DIR=out

[ -e "$CAPTURE_DIR" ] || mkdir -p "$CAPTURE_DIR"

for f in "$@" ; do
  "$TAO" -nosplash -p capture.xl $f
done
