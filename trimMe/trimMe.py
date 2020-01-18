__author__ = 'Remi Maglione'

import sys
import argparse

parser = argparse.ArgumentParser(description=
                                 "Extract fixed-length sequences from your r1 and r2 fastq files and concat them")

parser.add_argument('-r1', '--forward-fq', type=str, required=True,
                    help='Name of the R1 fastq')

parser.add_argument('-r2', '--reverse-fq', type=str, required=True,
                    help='Name of the R2 fastq')

parser.add_argument('-len-r1', '--barcode-length-r1', type=str, required=True,
                    help='Length of your r1 barcode to extract')

parser.add_argument('-len-r2', '--barcode-length-r2', type=str, required=True,
                    help='Length of your r2 barcode to extract')


try:
    args = parser.parse_args()
except:
    sys.exit()


# Defining classes
class Fastq(object):
    """Fastq object with name and sequence
    """
    def __init__(self, name, seq, name2, qual):
        self.name = name
        self.seq = seq
        self.name2 = name2
        self.qual = qual

    def write_to_file(self, handle):
        handle.write("@" + self.name + "\n")
        handle.write(self.seq + "\n")
        handle.write("+" + self.name2 + "\n")
        handle.write(self.qual + "\n")

# Defining functions
def fastq_iterator(input_file):
    """Takes a fastq file infile and returns a fastq object iterator
    """
    with open(input_file) as f:
        while True:
            name = f.readline().strip()
            if not name:
                break
            seq = f.readline().strip()
            name2 = f.readline().strip()[1:]
            qual = f.readline().strip()
            yield Fastq(name, seq, name2, qual)

###For future Dev###
#def myopen(infile, mode="r"):
#    if infile.endswith(".gz"):
#        return gzip.open(infile, mode=mode)
#    else:
#        return open(infile, mode=mode)
###For future Dev###


if __name__ == '__main__':
    ###For future Dev###
    #gz = args.gzip
    #if gz == 'gz':
    #    outSuffix = '.fastq.gz'
    #else:
    #    outSuffix = '.fastq'
    #print(outSuffix)
    ###For future Dev###

    fqIteratorR1 = fastq_iterator(args.forward_fq)
    fqIteratorR2 = fastq_iterator(args.reverse_fq)
    lenR1=int(args.barcode_length_r1)
    lenR2=int(args.barcode_length_r2)
    print("[Done]: building fastq iterator")
    separator = " "
    while True:
        try:
            s1 = fqIteratorR1.__next__()
            s2 = fqIteratorR2.__next__()

            s1.seq = "{}{}".format(s1.seq[1:lenR1], s2.seq[1:lenR2])
            s1.qual= "0"

            with open("barcodeMe.fastq", "a") as outpufile:
                s1.write_to_file(outpufile)

        except:
            print("Congrat, You (probably) Extract My Barcodes !")
            break
