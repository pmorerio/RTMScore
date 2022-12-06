#!/bin/bash
mkdir results_DUDE
for complex_folder in $1/* 
do
	DIR=$(basename "$complex_folder")
	echo $DIR
	echo ${complex_folder}/pocket.pdb
	python rtmscore.py -p ${complex_folder}/pocket.pdb -l ${complex_folder}/ligen_poses.mol2  -m ../trained_models/rtmscore_model1.pth -pl -o "./results_DUDE/$DIR"

	done
