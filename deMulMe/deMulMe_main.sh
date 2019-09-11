extract_barcodes.py -f R1.fastq.gz -r R2.fastq.gz -c barcode_paired_end --bc1_len 22 --bc2_len 16
python3 barcode2mapping.py -i barcode.csv -b barcodeRef.csv -f sabre_se -o barcode_mapping.txt
sabre se -m 3 -f barcodes.fastq -b barcode_mapping.txt -u unknown_sabre
for i in *.fastq ; do grep @M03660 $i > $i.seqID ; done
for i in *seqID ; do echo $i ; done > sabre.sample
python3 deMulMe.py -i sabre.sample -r1 R1.fastq -r2 R2.fastq
