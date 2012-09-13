# Non-regression test scripts for Tao Presentations
#
# Pre-requisites:
#   * bash, gmake
#   * ImageMagick (the 'convert' command)
#   * Copy tao_tests_env to $HOME/.tao_tests_env and edit it so
#     that the tester will find the Tao executable
#
# Usage:
#   $ make ref   # Save reference pics under ./ref
#   ... Hack and "make install" Tao ...
#   $ make check # Non-regression test:
#                # save pics under ./out then compare with ./ref
#
# More advanced usage:
#   * Choose the reference directory:
#     make ref REF=./macosx_1.14
#     make check REF=./macosx_1.14

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

