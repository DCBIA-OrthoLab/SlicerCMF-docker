import argparse
import csv
import glob
import os

import pandas as pd


def main(args):

    dir = args.input
    cols = args.columns
    out = args.output

    filenames = []
    normpath = os.path.normpath("/".join([dir, '**', '']))
    for filename in sorted(glob.iglob(normpath, recursive=True)):
        if os.path.isfile(filename) and True in [ext in filename for ext in [".csv"]]:
            filenames.append(filename)
    
    all_features = []
    with open(filenames[0], newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        for row in reader:
            for list in row:
                for feat in list.split(','):
                    if feat!='':
                        if cols == ['None']:
                            all_features.append(feat)
                        else: 
                            for col in cols:
                                all_features.append(feat+'-'+col)
            next(reader)
            next(reader)
            try: next(reader)
            except: pass
    
    idx = pd.MultiIndex.from_arrays([[],[],[]], names=['Patient','Sides','Ref'])
    BT = pd.DataFrame(index=idx,columns=all_features)

    old_dir = None

    for filename in filenames:
        
        new_dir = os.path.dirname(filename)
        print(new_dir)
        if (new_dir != old_dir) and (old_dir != None):
            # print(features[0])
            BT.loc[(patient,side,'Average'),features] = BT.loc[(patient,side),features].mean(0).round(6)
        old_dir = new_dir

        basename = os.path.basename(filename)
        splitname = basename.split('.')[0].split('_')
        patient = splitname[0]
        side = splitname[1]
        ref = basename.split('.')[0].split('_HM_')[-1]

        features=[]
        values=[]
        with open(filename, newline='') as csvfile:
            reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
            for row in reader:
                for list in row:
                    for feat in list.split(','):
                        if feat!='':
                            if cols == ['None']:
                                features.append(feat)
                            else: 
                                for col in cols:
                                    # print(basename)
                                    if col in basename:
                                        features.append(feat+'-'+col)
                next(reader)
                for list in next(reader):
                    for val in list.split(','):
                        if val!='':
                            values.append(float(val))
                try: next(reader)
                except: pass
            
        BT.loc[(patient,side,ref),features] = values
    BT.loc[(patient,side,'Average'),features] = BT.loc[(patient,side),features].mean(0).round(6)

    idx = pd.IndexSlice
    average = BT.loc[idx[:,:,'Average'],:]

    writer = pd.ExcelWriter(out, engine='xlsxwriter')
    BT.to_excel(writer, sheet_name='Sheet1', startrow=1, header=False)
    average.to_excel(writer, sheet_name='Sheet2', startrow=1, header=False)
    workbook = writer.book
    worksheet = writer.sheets['Sheet1']
    worksheet_average = writer.sheets['Sheet2']
    color_list = ['#90CAF9','#FFC107','#40E0D0','#AF7AC5','#58D68D','#EC7063']

    col_format = workbook.add_format({'align': 'center', 'valign': 'vcenter'})
    for ind, col_name in enumerate(BT.columns):
        column_len = BT[col_name].astype(str).str.len().max() + 2
        for col in cols:
            if col in col_name:
                worksheet.set_column(ind+3, ind+3, column_len, workbook.add_format({'align': 'center', 'valign': 'vcenter', 'bg_color': color_list[cols.index(col)]}))
                worksheet_average.set_column(ind+3, ind+3, column_len, workbook.add_format({'align': 'center', 'valign': 'vcenter', 'bg_color': color_list[cols.index(col)]}))

    header_format = workbook.add_format({'bold': True,'text_wrap': True,'align': 'center','valign': 'vcenter','border': 1})
    formats = []
    for col in cols:
        formats.append(workbook.add_format({'bold': True,'text_wrap': True,'align': 'center','valign': 'vcenter','border': 1, 'bg_color': color_list[cols.index(col)]}))

    BT.insert(loc=0, column='Patient', value='')
    BT.insert(loc=1, column='Side', value='')
    BT.insert(loc=2, column='Ref', value='')

    for ind, col_name in enumerate(BT.columns.values):
        if ind < 3:
            worksheet.write(0, ind, col_name, header_format)
            worksheet_average.write(0, ind, col_name, header_format)
        else:
            if cols == ['None']:
                worksheet.write(0, ind, col_name, header_format)
                worksheet_average.write(0, ind, col_name, header_format)
            else: 
                for col in cols:
                    if col in col_name:
                        worksheet.write(0, ind, col_name, formats[cols.index(col)])
                        worksheet_average.write(0, ind, col_name, formats[cols.index(col)])

    for ind, ind_name in enumerate(BT.index.names):
        indexcol_len = max(BT.index.get_level_values(ind_name).astype(str).str.len().max(), len(ind_name)) + 2
        worksheet.set_column(ind, ind, indexcol_len, col_format)
        worksheet_average.set_column(ind, ind, indexcol_len, col_format)

    row_format = workbook.add_format({'bold': True, 'align': 'center', 'valign': 'vcenter'})
    for ind, row in enumerate(BT.index):
        if 'Average' in row:
            worksheet.set_row(ind+1, 15, row_format)
            # worksheet_average.set_row(ind+1, 15, row_format)

    worksheet.set_row(0, 45, workbook.add_format({'align': 'center', 'valign': 'vcenter'}))
    worksheet_average.set_row(0, 45, workbook.add_format({'align': 'center', 'valign': 'vcenter'}))
    writer.save()

    print("Saved to ", out)


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--input','-i',default='BoneTexture/',help='input folder containing the csv bone texture files')
    parser.add_argument('--columns','-c',type=str,nargs='+',default=['None'],help='Name of the different columns for each feature')
    parser.add_argument('--output','-o',default='BoneTexture.xlsx',help='output file')
    args = parser.parse_args()

    main(args)
