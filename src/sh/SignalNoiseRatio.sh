#!/bin/sh

before_dir=$1
after_dir=$2
# outfile=$3
outfile='SNR.txt'

before_files=( $before_dir/* )
after_files_dirs=( $after_dir/* )

while [ "${#before_files[@]}" -gt 0 ] &&
      [ "${#after_files_dirs[@]}" -gt 0 ]
do

    after_files=( ${after_files_dirs[0]}/* )

    while [ "${#after_files[@]}" -gt 0 ]
    do
        echo $(basename ${before_files[0]}) >> $outfile
        echo $(basename ${after_files[0]}) >> $outfile

        ./build_ImageNoise/bin/ImageNoise ${before_files[0]} -s ${after_files[0]} -i ${before_files[0]} >> $outfile
        
        echo >> $outfile

        after_files=( "${after_files[@]:1}" )
    done

    before_files=( "${before_files[@]:1}" )
    after_files_dirs=( "${after_files_dirs[@]:1}" )
done
