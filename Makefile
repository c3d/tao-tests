# ******************************************************************************
# Makefile                                                         Tao3D project
# ******************************************************************************
#
# File description:
#
#
#
#
#
#
#
#
# ******************************************************************************
# This software is licensed under the GNU General Public License v3
# (C) 2015,2019, Christophe de Dinechin <christophe@dinechin.org>
# (C) 2012-2014, Jérôme Forissier <jerome@taodyne.com>
# ******************************************************************************
# This file is part of Tao3D
#
# Tao3D is free software: you can r redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Tao3D is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Tao3D, in a file named COPYING.
# If not, see <https://www.gnu.org/licenses/>.
# ******************************************************************************
# Non-regression test scripts for Tao Presentations
#
# TL;DR - Example: non-reg tests between Tao 1.44 and master (pre-1.45)
#
# tao$ git co 1.44 && git submodule update && ./configure --with-modlic modules+=+display_2dplusdepth modules+=+display_alioscopy modules+=+display_tridelity && make -j3 install
# tao_tests$ make disclean ; make ref
# tao$ git co master && git submodule update && ./configure --with-modlic modules+=+display_2dplusdepth modules+=+display_alioscopy modules+=+display_tridelity && make -j3 install
# tao_tests$ TAO_VERSION=1.45 make check
#
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

all: check

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

