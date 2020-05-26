__author__ = 'Remi Maglione'

import csv
import argparse
import sys

parser = argparse.ArgumentParser(description=
                                 "Create a ready-to-use barcode file with a correct input format "
                                 "for Qiime, Mothur and idemp (so far)")
parser.add_argument('-i', '--input-csv', type=str, required=True,
                    help='Name of the input .csv file.\nMust contain: 1- The Forward primer number\n'
                         '2- The Reverse primer number, \n'
                         '3- The Sample Name')

parser.add_argument('-b', '--barcode-csv', type=str, required=True,
                    help='Name of the barcode .csv file\nMust contain: \n1- The Name of the barcode'
                         '\n2- The sequence of the barcode')

parser.add_argument('-f', '--format', type=str, required=True,
                    help='format of the output file'
                         'supporting: [qiime, mothur and idemp]')

parser.add_argument('-o', '--output-csv', type=str, required=True,
                    help='Name of the output .csv file')

parser.add_argument('-s', '--output-suffix', type=str, required=False,
                    help='Add a suffix to the output file')

try:
    args = parser.parse_args()
except:
    sys.exit()


def csv_open(filename):
    """Take a CSV file and open it
    :param filename: a .csv file
    :return csv reader file
    """
    return csv.reader(open(filename), delimiter=',', skipinitialspace=True)


def CSV_2_dict(filename):
    """Take a CSV file and convert it in a dict with keys/value as name/sequence
    :param filename: a .csv file
    :return dict: a dict with name/sequence
    """
    dict = {}
    for line in csv_open(filename):
        if line:
            dict[line[0]] = line[1]
    return dict


if __name__ == '__main__':
    barcoDict = CSV_2_dict(args.barcode_csv)  # Hash the barcode file through a dict
    with open(args.output_csv, "w") as of:  # Open the ouput file

        if args.format == "qiime":
            of.write("#SampleID\tBarcodeSequence\tLinkerPrimerSequence\tReversePrimer\tDescription\n")  # Add the header
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}'
                         '\t{}{}'
                         '\tAACMGGATTAGATACCCKG'
                         '\tAGGGTTGCGCTCGTTG'
                         '\t{}\n'.format(line[2],
                                         barcoDict[line[0]], barcoDict[line[1]],
                                         line[2]))
        elif args.format == "mothur":
            of.write("primer\tAGGGTTGCGCTCGTTG\tAACMGGATTAGATACCCKG\n") # Add the header
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}'
                         '\t{}'
                         '\t{}'
                         '\t{}\n'.format("barcode",
                                         barcoDict[line[1]],
                                         barcoDict[line[0]],
                                         line[2]))

        elif args.format == "mothur_rev":
            of.write("primer\tAGGGTTGCGCTCGTTG\tAACMGGATTAGATACCCKG\n") # Add the header
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}'
                         '\t{}'
                         '\t{}'
                         '\t{}\n'.format("barcode",
                                         barcoDict[line[0]],
                                         barcoDict[line[1]],
                                         line[2]))

        elif args.format == "idemp":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}{}'
                         '\t{}\n'.format(barcoDict[line[1]],
                                         barcoDict[line[0]],
                                         line[2]))

        elif args.format == "idemp_rev":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}{}'
                         '\t{}\n'.format(barcoDict[line[0]],
                                         barcoDict[line[1]],
                                         line[2]))

        elif args.format == "defq":
            of.write("filename, index1, index2\n")
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}.fastq.gz'
                         ', {}{}\n'.format(line[2],
					 barcoDict[line[0]],
                                         barcoDict[line[1]]))

        elif args.format == "sabre_se":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                if args.output_suffix is not None:
                    of.write('{}{}'
                         ' {}.fastq{}\n'.format(barcoDict[line[0]],
                                                barcoDict[line[1]],
                                                line[2],
                                                args.output_suffix))
                else:
                    of.write('{}{}'
                         ' {}.fastq\n'.format(barcoDict[line[0]],
                                              barcoDict[line[1]],
                                              line[2]))


        elif args.format == "sabre_pe":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}{}'
                         ' {}.fastq\n'.format(barcoDict[line[0]],
                                              barcoDict[line[1]],
                                              line[2]))


        elif args.format == "fasta":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('>{}\n'
                         '{}{}\n'
			 '\n'.format(line[2],
				     barcoDict[line[0]],
                                     barcoDict[line[1]]))


        elif args.format == "demul":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}'
                         '\t{}'
                         '\tAACMGGATTAGATACCCKG'
                         '\t{}'
			 '\tAGGGTTGCGCTCGTTG\n'.format(line[2],
                                         	       barcoDict[line[0]], 
					 	       barcoDict[line[1]]))


        elif args.format == "demulrev":
            for line in csv_open(args.input_csv):
                #  Writing in the output while looping at the key dictionary
                of.write('{}'
                         '\t{}'
                         '\tAGGGTTGCGCTCGTTG'
                         '\t{}'
                         '\tAACMGGATTAGATACCCKG\n'.format(line[2],
                                                       barcoDict[line[0]],
                                                       barcoDict[line[1]]))
