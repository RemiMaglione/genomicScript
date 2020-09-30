#!/usr/bin/env bash

file_r1=$1
file_r2=$2
threadMe=$3
bc_length_r1=$4
bc_length_r2=$5
barcoRef=$6
barcoRun=$7
cut_file_r1=$8
cut_file_r2=$9

clear
###Input control
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ $# -ne 9 ]
then
    echo "usage: main.sh file_r1 file_r2 threads bc_length_r1 bc_length_r2 barcoRef barcoRun cut_file_r1 cut_file_r2"
    echo "file_r1 & r2: input fastq files [Must contain the barcode]"
    echo "threads: number of threads to use"
    echo "bc_length_r1 & r2: Fixed barcode length of your input fastq files"
    echo "barcoRef: reference file of your barcodes"
    echo "barcoRun: barcode to sample file"
    echo "cut_file_r1 & r2: input removed barcodes fastq files [=file_r1 & r2 without their barcode]"
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
echo "R1 barcode length = ""${bc_length_r1}"
echo "R2 barcode length = ""${bc_length_r2}"
echo "barcode reference = ""${barcoRef}"
echo "barcode to sample = ""${barcoRun}"
echo "R1 adaptor cut fastq file = ""${cut_file_r1}"
echo "R2 adaptor cut fastq file = ""${cut_file_r2}"
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

echo "Extract barcodes OK"
#cat barcodes*_tmp.fastq > barcodeMe.fastq & spinner

for splitFile in ${tempName_r1}* ;
do
python3 ${b2mPATH}barcode2mapping.py -i ${barcoRun} -b ${barcoRef} -f sabre_se -o "barcode_mapping.txt""${splitFile: -2}" -s "${splitFile: -2}" &
done
spinner
wait

echo "Map barcodes OK"

for splitFile in ${tempName_r1}* ;
do
${sabrePATH}sabre se -m 1 -f "barcodes_""${splitFile: -2}""_tmp.fastq" -b "barcode_mapping.txt""${splitFile: -2}" -u unknown_sabre"${splitFile: -2}" >sabre.log"${splitFile: -2}" &
done
spinner
wait

echo "Sabre demul Ok"


for splitFile in ${tempName_r1}* ;
do
    for i in *.fastq"${splitFile: -2}" ;
    do grep @M03660 $i > $i.seqID"${splitFile: -2}" ;
    done &
done
wait

echo "seqID Ok"

for seqIDfiles in *.fastq.seqID ;
do
 echo $seqIDfiles ;
done > seqID.files
wait

echo "seqID Files Ok"


lines_seqIDFiles=$(wc -l seqID.files | cut -d' ' -f1)
splitMySeqIDFiles=$(echo "(($lines_seqIDFiles / $threadMe) + 1)"|bc)
split -l ${splitMySeqIDFiles} -d seqID.files seqID.files_

for splitFile in ${tempName_r1}* ;
do
    python3 deMulMe.py -i seqID.files_"${splitFile: -2}" -r1 ${cut_file_r1} -r2 ${cut_file_r2} &
done
spinner
wait

echo "You demulMe"

for splitFile in ${tempName_r1}* ;
do
    rm "barcodes_""${splitFile: -2}""_tmp.fastq"
    rm sabre.sample"${splitFile: -2}"
    rm unknown_sabre"${splitFile: -2}"
    rm *seqID"${splitFile: -2}"
    rm *fastq"${splitFile: -2}"
    rm *tmp* &
done
wait
