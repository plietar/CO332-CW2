#!/usr/bin/bash env

echo -e "# X\tMin\t1st Q\tMedian\tMean\t3rd Q\tMax\tA\tB\tName." > results/time.txt
for f in $(find results -mindepth 1 -maxdepth 1 -type d | sort -n); do
    x=$(basename $f | cut -d'_' -f1)
    name=$(basename $f | cut -d'_' -f2-)
    cat $f/time.txt | grep -v '^#' | sed '1s/.*/'"$x"' \0 '"$name/"
done | \
    awk 'NR == 1 { initial = $4 ; prev = $4 }
         { printf "%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %s\n", \
             $1, $2, $3, $4, $5, $6, $7, \
             ((prev - $4) / prev * 100.0), \
             ((initial - $4) / initial * 100.0), $8;
           prev = $4 }' | \
    tr -s " " "\t" >> results/time.txt

gnuplot <<EOF
set terminal pngcairo  transparent noenhanced font "arial,10" fontscale 1.0 size 500,    350 
set output 'results/time.png'
set xrange[-1:9]
set yrange[0:2.5]

set style fill empty
set xtics rotate
set boxwidth 0.5
set style fill solid border -1

plot 'results/time.txt' using 1:4:xticlabels(10) title 'Average elapsed time' with boxes

# plot 'results/time.txt' using 1:3:2:7:6:xticlabels(10) with candlesticks title 'Quartiles' whiskerbars
EOF

