#!/bin/sh

HM_path="/app/Slicer/lib/Slicer-4.11/cli-modules/HistogramMatching" #Histogram Matching

inputfile=$1
outputfile=$2
refs=(${@:3})


files=($inputfile/*)


for file in "${files[@]}"; do
    filename=$(basename $file)
    ext="${filename##*.}"
    filename="${filename%.*}"

    if [ ! -d $outputfile/$filename ]
    then
        mkdir $outputfile/$filename
    fi


    for ref in "${refs[@]}"; do
        ref_name=$(basename $ref)
        split=(${ref_name//_/ })
        add_ref=${split[0]}_${split[1]}   

        $HM_path $file $ref $outputfile/$filename/${filename}_HM_$add_ref.$ext
    done

done

echo
echo "================================================="
echo
echo "Input folder : $inputfile"
echo "Output folder: $outputfile"
echo
echo "References: "
for ref in "${refs[@]}"; do
    echo $ref
done
echo 
echo "Program Finished"
echo "================================================="








# NumberElemFolder=$(ls $inputfile | wc -l)

# echo

# number=($(((RANDOM%NumberElemFolder)+1)) $(((RANDOM%NumberElemFolder)+1)) $(((RANDOM%NumberElemFolder)+1)) $(((RANDOM%NumberElemFolder)+1)) $(((RANDOM%NumberElemFolder)+1)))


# for i in "${number[@]}"; do
#     echo "Random number less than $NumberElemFolder  ---  $i"
# done



