#!/bin/bash
#
# Usage: runtest files...
#
# Run Tao test documents. capture.xl is automatically pre-loaded.
# If file name ends in .xl, its content is wrapped in capture_begin/capture_end
# before being loaded in Tao. Otherwise, the file is loaded as is.
#
# Examples:
#   run_test.sh all.ddd
#   run_test.sh t_anaglyph.xl

. functions.sh

[ "$@" ] || die "No file"

# Set environment variables to run Tao Presentations
case $(uname) in
  Darwin)
    TAOBASE="Tao Presentations"
    ;;
  Linux|MINGW*)
    TAOBASE="Tao"
    ;;
esac
TAO=$(which "$TAOBASE" 2>&1)
if [ -z "$TAO" ] ; then
  case $(uname) in
    Darwin)
      PATH="$HOME/work/tao/install/Tao Presentations.app/Contents/MacOS:$PATH"
      ;;
    Linux|MINGW*)
      PATH="$HOME/work/tao/install:$PATH"
      ;;
  esac
  TAO=$(which "$TAOBASE" 2>&1)
fi

[ "$TAO" ] || die "Command '$TAOBASE' not found in \$PATH or default working location"
echo "Using Tao: '$TAO'"

[ $(uname) = "Linux" ] && export LD_LIBRARY_PATH=$(dirname "$TAO"):$LD_LIBRARY_PATH

# Default values for environment variables
[ "$CAPTURE_DIR" ] || export CAPTURE_DIR=out

[ -e "$CAPTURE_DIR" ] || mkdir -p "$CAPTURE_DIR"

WRAPFILE=""
# If $1 is a .xl file, create a .ddd file that can be run by itself
wrap_xl_file() {
  case "$1" in
    *.xl)
      WRAPFILE=$(_mktemp $1.XXXX)
      cat >$WRAPFILE <<_EOF_
// Generated by run_test.sh
capture_begin
import "$1"
capture_end
_EOF_
      ;;
  esac
}

# Remove file previously created by wrap_xl_file
clean_wrap_file() {
  [ "$WRAPFILE" ] || return 0
  rm -f "$WRAPFILE"
  WRAPFILE=""
}

for f in "$@" ; do
  wrap_xl_file $f
  [ "$WRAPFILE" ] && f="$WRAPFILE"
  "$TAO" -nosplash -p capture.xl $f
  clean_wrap_file
done
