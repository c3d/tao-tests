comp: out ref
	./compare.sh

out:
	./runtest.sh all.ddd

ref:
	CAPTURE_DIR=./ref ./runtest.sh all.ddd

clean:
	rm -rf ./out

distclean: clean
	rm -rf ./ref

