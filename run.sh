#!/usr/bin/env bash
set -eu

OUTDIR=$1
shift

mkdir -p $OUTDIR

make -C tourtre-simple clean
make -C tourtre-simple 

tourtre-simple/simple "$@" > $OUTDIR/output.txt 2>&1

for i in $(seq 1 10); do
    \time --format="%e %P" -o $OUTDIR/time.$i.txt tourtre-simple/simple "$@" >/dev/null 2>&1
done

# Collect some stats about the timing
cat $OUTDIR/time.*.txt | \
    awk '{ print $1 }' | \
    R -q -e 'x <- scan("stdin", quiet=TRUE); summary(x)' | \
    grep -v '^>' | sed '1s/.*/#\0/' > $OUTDIR/time.txt

#valgrind --tool=cachegrind --branch-sim=yes --cachegrind-out-file=$OUTDIR/cachegrind.out tourtre-simple/simple "$@"
#cg_annotate --auto=yes $OUTDIR/cachegrind.out > $OUTDIR/cg_annotate.txt

#make -C tourtre-simple clean
#make -C tourtre-simple -f Makefile-gcc-gprof

#rm -f gmon.out
#tourtre-simple/simple "$@" 2>&1
#gprof simple > $OUTDIR/grof.txt
