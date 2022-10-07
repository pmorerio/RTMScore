#!/bin/bash
mkdir results
for complex_folder in $1/*/ 
do
	echo ${complex_folder}
	echo ${complex_folder: -5:4}
	echo ${complex_folder}pocket.pdb
	echo "./results/${complex_folder: -5:4}.csv"
	python rtmscore.py -p ${complex_folder}pocket.pdb -l ${complex_folder}docked_poses.mol2 -m ../trained_models/rtmscore_model1.pth -pl -o "./results/${complex_folder: -5:4}"

	done
