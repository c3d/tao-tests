#!/bin/bash
# 

. functions.sh

usage() {
    echo "Usage: $0 <refdir> <dir>" >&2
    exit 1
}

check_IM() {
  compare --version 2>&1 | grep ImageMagick >/dev/null
}

check_IM || die "ImageMagick command 'compare' not installed?"

# different_pixels image1 image2
# Echo the number of pixels that differ in image2 from image1. 0 = identical.
different_pixels() {
  DIFF=${3-null:}
  compare -metric ae $1 $2 $DIFF 2>&1
}


REFDIR=$1; shift
OUTDIR=$1; shift

[ "$OUTDIR" ] || usage

[ -d "$REFDIR" ] || die "Directory $REFDIR does not exist"
[ -d "$OUTDIR" ] || die "Directory $OUTDIR does not exist"

IDENTICAL_FILES=0
DIFFERENT_FILES=0
shopt -s nullglob
{
  echo "Comparing image files in $REFDIR and $OUTDIR:"
  cd $OUTDIR
  for f in cap*.png ; do
    if [ -e ../$REFDIR/$f ] ; then
        DIFF=$(different_pixels ../$REFDIR/$f $f diff_$f)
        if [ "$DIFF" = 0 ] ; then
            echo "  $f: identical"
            IDENTICAL_FILES=$((IDENTICAL_FILES + 1))
            rm diff_$f
        else
            echo "! $f: $DIFF pixels differ"
            DIFFERENT_FILES=$(($DIFFERENT_FILES + 1))
        fi
    else
        echo "  !! Only in $OUTDIR: $f"
    fi
  done
  cd - >/dev/null
}

echo
echo "Summary:"
echo "  identical: $IDENTICAL_FILES files"
echo "  different: $DIFFERENT_FILES files"
