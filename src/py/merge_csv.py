import argparse
import csv
import itertools
import os

import pandas as pd


def main(args):
    csv1 = pd.read_csv(args.csv1)
    csv2 = pd.read_csv(args.csv2)
    csv3 = pd.read_csv(args.csv3)
    out = args.out

    df = pd.DataFrame()
    for var1, var2, var3 in itertools.zip_longest(csv1.iloc[:,0], csv2.iloc[:,0], csv3.iloc[:,0]):
        if var1==None:
            # split1=['','']
            feat1 = val1 = ''
        else:
            split1 = var1.split('=')
            feat1 = split1[0][0].lower()+split1[0][1:]
            val1 = split1[1]
        if var2==None:
            # split2=['','']
            feat2 = val2 = ''
        else:
            split2 = var2.split('=')
            feat2 = split2[0][0].lower()+split2[0][1:]
            val2 = split2[1]
        if var3==None:
            # split3=['','']
            feat3 = val3 = ''
        else:
            split3 = var3.split('=')
            feat3 = split3[0]
            val3 = split3[1]
        # col = [split1[0][0].lower()+split1[0][1:],'',split1[1],'',split2[0][0].lower()+split2[0][1:],'',split2[1],'',split3[0],'',split3[1],'']
        col = [feat1, '', val1, '', feat2, '', val2, '', feat3, '', val3]
        # print(col)
        df[len(df.columns)] = col

    if not os.path.exists(os.path.dirname(out)):
        os.makedirs(os.path.dirname(out))
    df.to_csv(out, index=False, header=False)

    os.remove(args.csv1)
    os.remove(args.csv2)
    os.remove(args.csv3)


if __name__ ==  '__main__':
    parser = argparse.ArgumentParser(description='Merge 3 csv files for Bone Texture', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    csv_files = parser.add_argument_group('Input csv files')
    csv_files.add_argument('--csv1', type=str, help='Input csv 1', required=True)
    csv_files.add_argument('--csv2', type=str, help='Input csv 2', required=True)
    csv_files.add_argument('--csv3', type=str, help='Input csv 3', required=True)

    parser.add_argument('--out', type=str, help='output merged ', required=True) 


    args = parser.parse_args()

    main(args)
