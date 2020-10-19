# DeMulMe

DeMulMe is another way to demultiplex your data. It implements two algorithms wrapped together by basics shell commands:

1. Sabre [https://github.com/najoshi/sabre](https://github.com/najoshi/sabre)
 
2. A dirty python script : [deMulMe.py](https://github.com/RemiMaglione/genomicScript/blob/master/deMulMe/deMulMe.py)
---
## Note on 16S primers removal 
An aditional step can be used after demultuplexing with [cutadapt](https://cutadapt.readthedocs.io)
1. Create a samples name list. In the follwing command, names = XXX in XXX_R1.fastq (plz adapt it to your needs):

```ls *_R1.fastq | awk -F '_' '{print $1}' > samples.name```

2. Iterate over the samples.name and remove 16S primers with cutadapt

```while read sample ; do R1="${sample}""_R1.fastq" ; R2="${sample}""_R2.fastq" ;  R1out="${sample}"".PC_R1.fastq" ;  R2out="${sample}"".PC_R2.fastq" ;  cutadapt --trimmed-only --no-indels -g file:./16Sprimer_f.fa -G file:./16Sprimer_r.fa -o $R1out -p $R2out $R1 $R2 ; done < samples.name >> cut_pc.log```

---
## Update 10.2020
* Introduce a trick to remove 16S primers after demultiplexing with cutadapt
---
## Update 09.2020
* Paralelize group of output files per thread instead of piece of raw .fastq files
---
## Update 01.2020
* Shell scripts for a _all-in-one_ command --> [deMulMe.sh](https://github.com/RemiMaglione/genomicScript/blob/master/deMulMe/deMulMe.sh)
* Fiound a way to parallelize deMulMe in Shell
---
## Update 09.2019
* Full shell commands --> [deMulMe_main.sh](https://github.com/RemiMaglione/genomicScript/blob/master/deMulMe/deMulMe_main.sh)
* Extract barcodes without calling QiiME --> [trimMe.py](https://github.com/RemiMaglione/genomicScript/blob/master/trimMe/trimMe.py)
* Parallelize barcodes extraction
---
## Future Dev
* ~~Full shell commands~~
* ~~Find a way to extract barcodes without calling QiiME package (maybe in R)~~
* ~~Parallelize barcodes extraction~~
* Debugging parameter to keep intermediate files
* ~~Shell scripts for a _all-in-one_ command~~
* ~~Find a way to parallelize deMulMe (maybe in R)~~
