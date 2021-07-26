#!/bin/sh

echo "Rescaling intensity"

inputdir=$1
outputdir=$2
min=$3
max=$4

files=($inputdir/*)

for file in "${files[@]}"; do

    python3 /app/src/py/FilterRescaleIntensity.py --img $file --out $outputdir/$(basename $file) --min $min --max $max

done

echo
echo "================================================="
echo
echo "Input folder : $inputdir"
echo "Output folder: $outputdir"
echo 
echo "Program Finished"
echo "================================================="





