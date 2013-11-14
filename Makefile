# Non-regression test scripts for Tao Presentations
#
# Pre-requisites:
#   * bash, gmake
#   * ImageMagick (the 'convert' command)
#
# Typical 'configure' command to enable licenses for all modules
# (including display):
# ./configure --with-modlic modules+=+display_alioscopy modules+=+display_2dplusdepth modules+=+display_tridelity
#
# Usage:
#   $ make ref   # Save reference pics under ./ref
#   ... Hack and "make install" Tao, or change $PATH ...
#   $ make check # Non-regression test:
#                # save pics under ./out then compare with ./ref
#
# More advanced usage:
#   * Choose the reference directory:
#     $ make ref REF=./macosx_1.14
#     $ make check REF=./macosx_1.14
#   * Choose the Tao executable:
#     $ PATH=/path/to/Tao:$PATH make ref
#   * Run select tests (pics go into ./out)
#     $ ./runtest.sh t_shapes2d.xl
#   * Set command-line option(s):
#     $ TAOOPT="-nomgtc" make check
#
REF=./ref
OUT=./out

.PHONY: check_ref ref out

all:

check: check_ref $(OUT)
	./compare.sh $(REF) $(OUT)

check_ref:
	@[ -d $(REF) ] || (echo "Reference directory '$(REF)' does not exist. Specify REF= and/or run 'make ref'." ; false)

ref:
	CAPTURE_DIR=$(REF) ./runtest.sh all.ddd

out:
	CAPTURE_DIR=$(OUT) ./runtest.sh all.ddd

clean:
	rm -rf $(OUT)

distclean: clean
	rm -rf $(REF)

