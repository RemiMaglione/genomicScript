#!/bin/bash

###Variable
file=$1

filename=$(basename "$file" .fasta)

if [ "${file##*.}" != "fasta" ];
then
echo "Input Error: it's not a .fasta file or file extention is .fa instead of .fasta"
exit
fi


fasta_formatter -i $file -o tmp.fa -w 1

Rscript N_vizu.R tmp.fa
