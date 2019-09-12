# DeMulMe

DeMulMe is another way to demultiplex your data. It implements two algorithms wrapped together by basics shell commands:

1. Sabre [https://github.com/najoshi/sabre](https://github.com/najoshi/sabre)
 
2. A dirty python script : [deMulMe.py](https://github.com/RemiMaglione/genomicScript/blob/master/deMulMe/deMulMe.py)

By the time you read this lines You also need a QiiME script : [extract_barcodes.py](http://qiime.org/scripts/extract_barcodes.html)

---
## Update
* Full shell commands --> [deMulMe_main.sh](https://github.com/RemiMaglione/genomicScript/blob/master/deMulMe/deMulMe_main.sh)

---

## Future Dev
* ~~Full shell commands~~
* Find a way to extract barcodes without calling QiiME package (maybe in R)
* parallelize barcodes extraction
* Debugging parameter to keep intermediate files
* Shell scripts for a _all-in-one_ command
* Find a way to parallelize deMulMe (maybe in R)
