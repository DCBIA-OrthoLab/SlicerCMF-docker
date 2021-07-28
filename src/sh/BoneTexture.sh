#!/bin/bash

# Do not remove this line
# It defines all variable environnements
source /app/slicer-env.sh

# Path to the cli-modules inside the docker image
cli_modules_path="/app/Slicer/lib/Slicer-4.11/cli-modules"


Help()
{
# Display Help

echo "-h|--help                 Print this Help."
echo
}

while [ "$1" != "" ]; do
    case $1 in
        --inputfile )  shift
            inputfile=$1;;
        --outputdir )  shift
            outputdir=$1;;
        --references )  shift
            references=$1;;

        -h | --help )
            Help
            exit;;
        * ) 
            echo ' - Error: Unsupported flag'
            Help
            exit 1
    esac
    shift
done




input_dir=$1
output_dir=$2

voxelMin=$3
voxelMax=$4
threshold=$5

cols=(${@:6})
cols="${cols:-None}"

GLCM=$cli_modules_path/ComputeGLCMFeatures
GLRLM=$cli_modules_path/ComputeGLRLMFeatures
BM=$cli_modules_path/ComputeBMFeatures


dir_BT=($input_dir/*)

# for dir in "${dir_BT[@]}"; do
#     if [[ ! -d $output_dir/$(basename $dir) ]]; then
#         mkdir $output_dir/$(basename $dir)
#     fi

#     files=($dir/*)
#     for file in "${files[@]}"; do
#         filename=$output_dir/$(basename $dir)/$(basename $file)
#         output_filename="${filename%.*}"

#         $GLCM $file -p $voxelMin -P $voxelMax --returnparameterfile "$output_filename"_1.csv
#         $GLRLM $file -p $voxelMin -P $voxelMax --returnparameterfile "$output_filename"_2.csv
#         $BM $file -t $threshold --returnparameterfile "$output_filename"_3.csv

#         python3 src/BoneTexture_code/merge_csv.py --csv1 "$output_filename"_1.csv --csv2 "$output_filename"_2.csv --csv3 "$output_filename"_3.csv --out "${filename%.*}".csv
#     done
# done




# python3 src/BoneTexture_code/BoneTextureExcel.py -i $output_dir -c ${cols[@]} -o $(dirname $output_dir)/BoneTextureExcel.xlsx








