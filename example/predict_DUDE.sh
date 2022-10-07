#!/bin/bash
mkdir results_DUDE
for complex_folder in $1/* 
do
	echo ${complex_folder:16}
	echo ${complex_folder}/pocket.pdb
	python rtmscore.py -p ${complex_folder}/pocket.pdb -l ${complex_folder}/LIGEN-keysites/DSCORE_pose.mol2  -m ../trained_models/rtmscore_model1.pth -pl -o "./results_DUDE/${complex_folder:16}"

	done
