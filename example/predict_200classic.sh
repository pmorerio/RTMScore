#!/bin/bash
mkdir results_200classic
for complex_folder in $1/*/ 
do
	echo ${complex_folder}
	echo ${complex_folder: -5:4}
	echo ${complex_folder}pocket.pdb
	echo "./results/${complex_folder: -5:4}.csv"
	start_time=$(date +%s)
	python rtmscore.py -p ${complex_folder}pocket.pdb -l ${complex_folder}docked_poses.mol2 -m ../scripts/my_rtmscore_nocasf_no200classic.pth -pl -o "./results_200classic/${complex_folder: -5:4}"	
	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	echo $elapsed

	done
