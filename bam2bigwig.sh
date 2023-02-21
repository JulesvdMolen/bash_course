#!/usr/bin/env bash

#load deeptoals environment
source /scratch/jmolen/mamba/etc/profile.d/conda.sh
conda create -n bam2bigwig deeptools samtools --yes
conda activate bam2bigwig

#output dir
output_dir=$2
mkdir -p  $output_dir
cd $output_dir

#input files
input_dir=$1
cp -r $input_dir/* $output_dir
input_files=$(ls *.bam)

#loop over bam files and create bw files
for input in ${input_files[@]}; do
	nosuff=${input%.*}
	output=$output_dir/$(basename $nosuff).bw
	nice samtools index -b $input
	nice bamCoverage -b $input -o $output \
	>> log.txt 2>&1
	echo $input >> log.txt
	rm $input.bai
	rm $input
done

echo Jules van der Molen
