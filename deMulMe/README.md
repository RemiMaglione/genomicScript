# DeMulMe

DeMulMe is another way to demultiplex your data. It implements two algorithms wrapped together by basics shell commands:

1. Sabre [https://github.com/najoshi/sabre](https://github.com/najoshi/sabre)
 
2. A dirty python script : [deMulMe.py](https://github.com/RemiMaglione/genomicScript/blob/master/deMulMe/deMulMe.py)

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
