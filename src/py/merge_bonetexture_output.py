# Script to merge bone texture output files. 
# The outputs are from a scrip: BoneTexture.sh

import argparse
import csv
import os

def updateDictFromFile(filepath, target_dict):
    try:
        with open(filepath, 'r') as f1:
            for l in f1.readlines():
                keyval = l.split("=")
                if keyval[0].strip().lower() != "outputvector":
                    target_dict[keyval[0].strip().lower()] = keyval[1].strip()
        os.remove(filepath)
    except Exception as e:
        print("Error reading the file {} \n ERROR: {}".format(filepath, e))

def main(args):

    file1 = args.file1
    file2 = args.file2
    file3 = args.file3

    outpath = args.out
    keyvals = {}
    updateDictFromFile(file1, keyvals)
    updateDictFromFile(file2, keyvals)
    updateDictFromFile(file3, keyvals)

    try:
        with open(outpath, 'w') as f:
            header = keyvals.keys()
            writer = csv.DictWriter(f, header)
            writer.writeheader()
            writer.writerow(keyvals)
    except Exception as e:
        print('Error writing the file {} \n ERROR: {}'.format(outpath, e))

if __name__ ==  '__main__':
    parser = argparse.ArgumentParser(description='Merge files for Bone Texture output', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    files = parser.add_argument_group('Input files')
    files.add_argument('--file1', type=str, help='Input 1', required=True)
    files.add_argument('--file2', type=str, help='Input 2', required=True)
    files.add_argument('--file3', type=str, help='Input 3', required=True)
    parser.add_argument('--out', type=str, help='output merged ', required=True)

    args = parser.parse_args()

    main(args)
