#!/usr/bin/env bash

file_r1=$1
file_r2=$2
threadMe=$3

filename_r1=$(basename "$file_r1" .fastq)
filename_r2=$(basename "$file_r2" .fastq)

echo "file basenme input OK"

echo $file_r1
echo $file_r2
echo $threadMe

if [ "${file_r1##*.}" != "fastq" ];
then
echo "Input Error: it's not a .fastq file or file extension is .fq instead of .fastq (which bother me !)"
exit
fi

echo "fastq r1 control OK"

if [ "${file_r2##*.}" != "fastq" ];
then
echo "Input Error: it's not a .fastq file or file extension is .fa instead of .fastq (which bother me !)"
exit
fi

echo "fastq r2 control OK"

if [ $# -ne 3 ];
then
echo "For some reason you choose to not multithread me !"
echo "Did you really think that I have been design to work on a single thread? Duh..."
echo "You now what? I'll we work on a single core, taking you to the middle age of computer! Screw you!"
threadMe=1
fi

echo "thread control OK"

lines_r1=$(wc -l ${file_r1} | cut -d' ' -f1)
echo "lines count control OK"
echo "lines = ""${lines_r1}"

splitMe=$(echo "(($lines_r1 / $threadMe / 4) + 1) * 4"|bc)
echo "lines split control OK"
echo "splitMe = ""${splitMe}"

split -l ${splitMe} -d ${file_r1} "${filename_r1}"".tmp_" &
split -l ${splitMe} -d ${file_r2} "${filename_r2}"".tmp_" &
wait

for splitFile in "${filename_r1}"".tmp_"* ;
do
python3 trimMe.py -r1 "${filename_r1}"".tmp_""${splitFile: -2}" -r2 "${filename_r2}"".tmp_""${splitFile: -2}" -len-r1 10 -len-r2 20 &
done
wait
