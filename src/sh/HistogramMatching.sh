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


echo " ============================== "
echo " ===== Histogram Matching ===== "
echo " ============================== "


refs=($references/*)
filename=$(basename $inputfile)
ext="${filename##*.}"
filename="${filename%.*}"

if [ ! -d $outputdir/$filename ]
then
    mkdir $outputdir/$filename
fi


for ref in "${refs[@]}"; do
    ref_name=$(basename $ref)
    ref_name="${ref_name%.*}"
    # split=(${ref_name//_/ })
    # add_ref=${split[0]}_${split[1]}   

    $cli_modules_path/HistogramMatching $inputfile $ref $outputdir/$filename/${filename}_HM_$ref_name.$ext
done


