#!/usr/bin/env bash
#

infile=hg19_TSS.txt.gz
outfile=hg19_TSS.bed.gz

zcat $infile | awk -v OFS="\t" '!/^($|#)/ {print $2, $4-1, $4, $5, "."}' | head