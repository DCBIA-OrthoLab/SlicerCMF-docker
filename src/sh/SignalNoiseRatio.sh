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
        --before_dir )  shift
            before_dir=$1;;
        --after_dir )  shift
            after_dir=$1;;
        --outfile )  shift
            outfile=$1;;

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

# before_dir=$1
# after_dir=$2
# outfile=$3
outfile="${outfile:-SNR.txt}"

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
