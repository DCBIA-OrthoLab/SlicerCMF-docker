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
        --tmp_dir )  shift
            tmp_dir=$1;;
        --voxelMin )  shift
            voxelMin=$1;;
        --voxelMax )  shift
            voxelMax=$1;;
        --threshold )  shift
            threshold=$1;;
        # --cols )  shift
        #     cols=$1;;

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




# input_dir=$1
# output_dir=$2

# voxelMin=$3
# voxelMax=$4
# threshold=$5

# cols=(${@:6})
# cols="${cols:-None}"


tmp_dir="${tmp_dir:-/app/tmp}"
voxelMin="${voxelMin:--1000}"
voxelMax="${voxelMax:-2500}"
threshold="${threshold:-250}"


GLCM=$cli_modules_path/ComputeGLCMFeatures
GLRLM=$cli_modules_path/ComputeGLRLMFeatures
BM=$cli_modules_path/ComputeBMFeatures


# dir_BT=($input_dir/*)

# for dir in "${dir_BT[@]}"; do
# if [[ ! -d $output_dir/$(basename $dir) ]]; then
#     mkdir $output_dir/$(basename $dir)
# fi

# files=($dir/*)
# for file in "${files[@]}"; do
# filename=$output_dir/$(basename $dir)/$(basename $file)
basename="$(basename $inputfile)"
output_filename="${basename%.*}"

$GLCM $inputfile -p $voxelMin -P $voxelMax --returnparameterfile $tmp_dir/"$output_filename"_1.txt
$GLRLM $inputfile -p $voxelMin -P $voxelMax --returnparameterfile $tmp_dir/"$output_filename"_2.txt
$BM $inputfile -t $threshold --returnparameterfile $tmp_dir/"$output_filename"_3.txt

declare -x "LD_LIBRARY_PATH=/usr/bin/../lib/"
declare -x "PYTHONPATH=/usr/bin/../lib/python3.7:/usr/bin/../lib/python3.7/lib-dynload:/usr/local/bin/../lib:/usr/local/bin/../lib/python3.7:/usr/local/bin/../lib/python3.7/site-packages:/usr/local/bin/../lib/python3.7/lib-dynload${PYTHONPATH:+:$PYTHONPATH}"

python3 /app/src/py/merge_bonetexture_output.py --file1 $tmp_dir/"$output_filename"_1.txt --file2 $tmp_dir/"$output_filename"_2.txt --file3 $tmp_dir/"$output_filename"_3.txt --out $outputdir/$output_filename.csv
# done
# done

echo "Bone Texture csv file created"
