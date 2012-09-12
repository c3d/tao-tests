#!/bin/sh
# 

# different_pixels image1 image2
# Echo the number of pixels that differ in image2 from image1. 0 = identical.
different_pixels() {
  compare -metric ae $1 $2  null: 2>&1
}

REFDIR=./ref
OUTDIR=./out

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
echo "File totals:"
echo "  identical: $IDENTICAL_FILES"
echo "  different: $DIFFERENT_FILES"
