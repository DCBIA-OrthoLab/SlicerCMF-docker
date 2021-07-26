#!/bin/sh

# path_CLI_BT="/app/Slicer/Extensions-29402/BoneTextureExtension/lib/Slicer-4.11/cli-modules"
path_CLI_BT="/Applications/Slicer.app/Contents/Extensions-29738/BoneTextureExtension/lib/Slicer-4.11/cli-modules"

input_dir=$1
output_dir=$2

voxelMin=$3
voxelMax=$4
threshold=$5

cols=(${@:6})
cols="${cols:-None}"

GLCM=$path_CLI_BT/ComputeGLCMFeatures
GLRLM=$path_CLI_BT/ComputeGLRLMFeatures
BM=$path_CLI_BT/ComputeBMFeatures


dir_BT=($input_dir/*)

for dir in "${dir_BT[@]}"; do
    if [[ ! -d $output_dir/$(basename $dir) ]]; then
        mkdir $output_dir/$(basename $dir)
    fi

    files=($dir/*)
    for file in "${files[@]}"; do
        filename=$output_dir/$(basename $dir)/$(basename $file)
        output_filename="${filename%.*}"

        $GLCM $file -p $voxelMin -P $voxelMax --returnparameterfile "$output_filename"_1.csv
        $GLRLM $file -p $voxelMin -P $voxelMax --returnparameterfile "$output_filename"_2.csv
        $BM $file -t $threshold --returnparameterfile "$output_filename"_3.csv

        python3 src/BoneTexture_code/merge_csv.py --csv1 "$output_filename"_1.csv --csv2 "$output_filename"_2.csv --csv3 "$output_filename"_3.csv --out "${filename%.*}".csv
    done
done

python3 src/BoneTexture_code/BoneTextureExcel.py -i $output_dir -c ${cols[@]} -o $(dirname $output_dir)/BoneTextureExcel.xlsx


# echo
# echo "================================================="
# echo
# echo "Input folder : $input_dir"
# echo "Output folder: $output_dir"
# echo
# echo "Voxel Min: $voxelMin"
# echo "Voxel Max: $voxelMax"
# echo "Threshold: $threshold"
# echo 
# echo "Program Finished"
# echo "================================================="




