#!/usr/bin/env bash

file_r1=$1
file_r2=$2
threadMe=$3

clear
###Input control
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ $# -ne 3 ]
then
    echo "usage: main.sh file_r1 file_r2 threads bc_length_r1 bc_length_r2"
    echo "file_r1 & r2: input fastq files"
    echo "threads: number of threads to use"
    exit 1
fi

#SpinerBar adapted from
#https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-working-indicator#12498305
spinner()
{
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "\r %c  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    echo ""
}

###export some path
export b2mPATH=/data/users/remi/scripts/barcode2mapping/
export sabrePATH=/data/users/remi/sabre/


echo "### PARAMETER INPUT ###"
echo "R1 fastq file = ""${file_r1}"
echo "R2 fastq file = ""${file_r2}"
echo "Core = ""${threadMe}"
  echo "#######################"


filename_r1=$(basename "$file_r1" .fastq)
filename_r2=$(basename "$file_r2" .fastq)

echo "file basename input OK"

tempName_r1="${filename_r1}"".tmp_"
tempName_r2="${filename_r2}"".tmp_"


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

if ! [[ "$threadMe" =~ ^[0-9]+$ ]] ;
then
echo "For some reason you choose to not multithread me ! (You enter : $3 ...)"
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
echo "splitMe = ""${splitMe}"" lines per file"

split -l ${splitMe} -d ${file_r1} ${tempName_r1} &
split -l ${splitMe} -d ${file_r2} ${tempName_r2} &
spinner & wait

echo "split r1 & r2 files OK"

for splitFile in ${tempName_r1}* ;
do
python3 trimMe.py -r1 ${tempName_r1}"${splitFile: -2}" -r2 ${tempName_r2}"${splitFile: -2}" -len-r1 ${bc_length_r1} -len-r2 ${bc_length_r2} -o "barcodes_""${splitFile: -2}""_tmp.fastq" &
done
spinner
wait

echo "You trimMe !"
