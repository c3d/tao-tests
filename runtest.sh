#!/bin/bash
#
# Usage: runtest.sh [file|directory]...
#
# Run Tao test documents. capture.xl is automatically pre-loaded.
# If file name ends in .xl, its content is wrapped in capture_begin/capture_end
# before being loaded in Tao. Otherwise, the file is loaded as is.
# If a directory is encountered, it is treated as <dir>/*.ddd <dir>/*.xl.
#
# Examples:
#   runtest.sh all.ddd
#   runtest.sh t_anaglyph.xl
#   runtest.sh modules

. functions.sh

[ "$@" ] || die "No file"

# $TAO is set when the script calls itself (to process directories)
if [ -z "$TAO" ] ; then
  # Set environment variables to run Tao Presentations
  case $(uname) in
    Darwin)
      TAOBASE="Tao Presentations"
      ;;
    Linux|MINGW*)
      TAOBASE="Tao"
      ;;
  esac
  DFLT=none
  TAO=$(which "$TAOBASE" 2>&1)
  if [ -z "$TAO" ] ; then
    case $(uname) in
      Darwin)
        DFLT="$HOME/work/tao/install/Tao Presentations.app/Contents/MacOS"
        PATH="$DFLT:$PATH"
        ;;
      Linux|MINGW*)
        DFLT="$HOME/work/tao/install"
        PATH="$DFLT:$PATH"
        ;;
    esac
    TAO=$(which "$TAOBASE" 2>&1)
  fi
  [ "$TAO" ] || die "Command '$TAOBASE' not found in \$PATH or default working location '$DFLT'"
  echo "Using Tao: '$TAO'"
fi


[ $(uname) = "Linux" ] && export LD_LIBRARY_PATH=$(dirname "$TAO"):$LD_LIBRARY_PATH

# Default values for environment variables
[ "$CAPTURE_DIR" ] || export CAPTURE_DIR=out

[ -e "$CAPTURE_DIR" ] || mkdir -p "$CAPTURE_DIR"

WRAPFILE=""
# If $1 is a .xl file, create a .ddd file that can be run by itself
wrap_xl_file() {
  case "$1" in
    *.xl)
      BASENAME=$(basename $1)
      WRAPFILE=$(_mktemp $BASENAME.XXXX)
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

shopt -s nullglob

for f in "$@" ; do
  if [ -d "$f" ] ; then
    for ff in $f/*.ddd $f/*.xl ; do
      export TAO; $0 $ff
    done
  else
    wrap_xl_file $f
    [ "$WRAPFILE" ] && f="$WRAPFILE"
    "$TAO" -nosplash -p capture.xl $f
    clean_wrap_file
  fi
done
