#!/bin/bash

# Do not remove this line
# It defines all variable environnements
source /app/slicer-env.sh


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
        --min )  shift
            min=$1;;
        --max )  shift
            max=$1;;

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


echo " ============================= "
echo " ===== Rescale Intensity ===== "
echo " ============================= "

min="${min:-0}"
max="${max:-255}"


# Reset the python path to avoid an issue if you use the python from slicer
declare -x "LD_LIBRARY_PATH=/usr/bin/../lib/"
declare -x "PYTHONPATH=/usr/bin/../lib/python3.7:/usr/bin/../lib/python3.7/lib-dynload:/usr/local/bin/../lib:/usr/local/bin/../lib/python3.7:/usr/local/bin/../lib/python3.7/site-packages:/usr/local/bin/../lib/python3.7/lib-dynload${PYTHONPATH:+:$PYTHONPATH}"

python3 /app/src/py/FilterRescaleIntensity.py --img $inputfile --out $outputdir/$(basename $inputfile) --min $min --max $max




