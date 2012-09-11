#!/bin/bash
# 


. functions.sh

check_IM() {
  compare --version 2>&1 | grep ImageMagick >/dev/null
}

check_IM || die "ImageMagick command 'compare' not installed?"


# different_pixels image1 image2
# Echo the number of pixels that differ in image2 from image1. 0 = identical.
different_pixels() {
  compare -metric ae $1 $2  null: 2>&1
}

REFDIR=./ref
OUTDIR=./out

[ -d "$REFDIR" ] || die "Directory $REFDIR does not exist"
[ -d "$OUTDIR" ] || die "Directory $OUTDIR does not exist"

IDENTICAL_FILES=0
DIFFERENT_FILES=0
shopt -s nullglob
{
  echo "Comparing image files in $REFDIR and $OUTDIR"
  cd $OUTDIR
  for f in *.png ; do
    if [ -e ../$REFDIR/$f ] ; then
        DIFF=$(different_pixels ../$REFDIR/$f $f)
        if [ "$DIFF" = 0 ] ; then
            echo "  $f: identical"
            IDENTICAL_FILES=$((IDENTICAL_FILES + 1))
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
