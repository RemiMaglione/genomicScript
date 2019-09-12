################################################
###                 DeMulMe                  ###
### Scripted by Remi Maglione for Kembel Lab ###
################################################

#1. Extract your barcodes into other files
## This will help you work on a smaller file and increase the efficiency of your memory usage
extract_barcodes.py -f R1.fastq.gz -r R2.fastq.gz -c barcode_paired_end --bc1_len 22 --bc2_len 16

#2. Produce a barcode mapping file from your barcoded run and the reference of your barcode
## See the help barcode2mapping.py manual for more help
python3 barcode2mapping.py -i barcode.csv -b barcodeRef.csv -f sabre_se -o barcode_mapping.txt

#3. Demultiplex your barcodes.fastq with sabre. 
##[WARNING on -m parameter] DON'T TOLERATE TOO MUCH MISMTACH ON SIMILAR BARCODE SEQUENCES
sabre se -m 3 -f barcodes.fastq -b barcode_mapping.txt -u unknown_sabre

#4.Extract the sequence IDs
#By the time you read this lines you need to replace @M03660 by your RUN ID
for i in *.fastq ; do grep @M03660 $i > $i.seqID ; done

#5.Extract sample name
for i in *seqID ; do echo $i ; done > sabre.sample

#6. Finalyze the demultiplexing from your true R1 & R2.fastq files
python3 deMulMe.py -i sabre.sample -r1 R1.fastq -r2 R2.fastq
