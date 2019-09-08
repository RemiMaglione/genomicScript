__author__ = 'Remi Maglione'

import sys
import argparse
import csv
import gzip
import threading


parser = argparse.ArgumentParser(description=
                                 "Extract paired sequences based on sequence ID")
parser.add_argument('-i', '--input-fn', type=str, required=True,
                    help='Name of the input .csv file.\nMust contain: the list of the files with seq ID')

parser.add_argument('-r1', '--forward-fq', type=str, required=True,
                    help='Name of the R1 fastq')

parser.add_argument('-r2', '--reverse-fq', type=str, required=True,
                    help='Name of the R1 fastq')

parser.add_argument('-z', '--gzip', type=str, required=False,
                    help='gz for output compressed with gzip. [Default] = no compression')

parser.add_argument('-t', '--thread', type=str, required=False,
                    help='Number of threads for multithreading purpose. [Defaut] = 1')


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

    def getShortname(self, separator):
        self.temp = self.name.split(separator)
        del(self.temp[-1])
        return separator.join(self.temp)

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

def csv_open(filename):
    """Take a CSV file and open it
    :param filename: a .csv file
    :return csv reader file
    """
    return csv.reader(open(filename), delimiter=',', skipinitialspace=True)

def seqid2hash(infq):
    """ Create the dict with couple read name/file name
        :param infile:
        :return dict: """
    hashi = {}
    with open(infq) as seqId:
        while True:
            try:
                sid = seqId.readline().split()[0]
                #print(sid)
                if not sid:
                    break
                hashi[sid] = infq
            except:
                break
    return hashi

def myopen(infile, mode="r"):
    if infile.endswith(".gz"):
        return gzip.open(infile, mode=mode)
    else:
        return open(infile, mode=mode)

#def demulme(fqIteratorR1, fqIteratorR2, seqiHash):
#    separator = " "
#    while True:
#        try:
#            s1 = fqIteratorR1.__next__()
#            s2 = fqIteratorR2.__next__()
#            if s1.getShortname(separator) in seqiHash:
#                with open(seqiHash[s1.getShortname(separator)].split('.fastq')[0]+'_R1'+outSuffix, "a") as seqFileR1:
#                    with open(seqiHash[s1.getShortname(separator)].split('.fastq')[0]+'_R2'+outSuffix, "a") as seqFileR2:
#                        s1.write_to_file(seqFileR1)
#                        s2.write_to_file(seqFileR2)

if __name__ == '__main__':
    seqiHash = {}
    with open(args.input_fn, "r") as idFile:
        print("[Start]: Building sequences-file dictionary")
        while True:
            try:
                file = idFile.readline().split()[0]
                #print(file)
                seqiHash.update(seqid2hash(file))
            except:
                print("[Done]: sequences-file dictionary")
                break

    gz = args.gzip
    if gz == 'gz':
        outSuffix = '.fastq.gz'
    else:
        outSuffix = '.fastq'
    #print(outSuffix)
    fqIteratorR1 = fastq_iterator(args.forward_fq)
    fqIteratorR2 = fastq_iterator(args.reverse_fq)
    print("[Done]: building fastq iterator")
    separator = " "
    while True:
        try:
            s1 = fqIteratorR1.__next__()
            s2 = fqIteratorR2.__next__()
            if s1.getShortname(separator) in seqiHash:
                with open(seqiHash[s1.getShortname(separator)].split('.fastq')[0]+'_R1'+outSuffix, "a") as seqFileR1:
                    with open(seqiHash[s1.getShortname(separator)].split('.fastq')[0]+'_R2'+outSuffix, "a") as seqFileR2:
                        s1.write_to_file(seqFileR1)
                        s2.write_to_file(seqFileR2)
        except:
            print("Congrat, You Demul Me !")
            break
