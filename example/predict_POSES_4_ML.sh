#!/bin/bash
# OUT=results_POSES_4_ML_glide
OUT=results_POSES_4_ML_plants
# OUT=results_POSES_4_ML_vina
mkdir $OUT
for complex_folder in $1/*
do
	DIR=$(basename "$complex_folder")
	echo $DIR
	echo ${complex_folder}/pocket.pdb
	# python rtmscore.py -p ${complex_folder}/pocket.pdb -l ${complex_folder}/glide_poses.mol2  -m ../trained_models/rtmscore_model1.pth -pl -o "./$OUT/$DIR"
	python rtmscore.py -p ${complex_folder}/pocket.pdb -l ${complex_folder}/plants_poseslib.sdf  -m ../trained_models/rtmscore_model1.pth -pl -o "./$OUT/$DIR"
	# python rtmscore.py -p ${complex_folder}/pocket.pdb -l ${complex_folder}/vina_poses.mol2  -m ../trained_models/rtmscore_model1.pth -pl -o "./$OUT/$DIR"

	done
