#!/bin/bash

### run the following in terminal
# conda activate dimenet
# ./predict_ALLPDBs.sh

ALLPDBs_dir='/home/wahmed/codes/RTMScore/RTMScore/feats/ALLPDBs/*/'
model_dir='../trained_models/rtmscore_model1.pth'
results_dir='./results_ALLPDBs/'
###
rm -r $results_dir
###
mkdir $results_dir
sample_count=0
for complex_folder in $ALLPDBs_dir
	do
	### echo (for debugging only)
	# echo ${complex_folder}
	# echo ${complex_folder}pocket.pdb
	# echo ${complex_folder}ligen_poses.sdf
	#
	my_array=($(echo $complex_folder | tr "/" "\n"))
	sample_dir="${my_array[7]}"
	#
	if [[ ${#sample_dir} -eq 10 ]]
	then
		((sample_count=sample_count+1))
		echo sample_count: $sample_count, ${complex_folder}
		# echo $sample_dir
		# echo "The sample_dir name (" ${sample_dir} ") is of 10 characters"
		# echo ${complex_folder}pocket.pdb
		# echo ${complex_folder}ligen_poses.sdf
		# echo $results_dir${sample_dir}.csv 
		start_time=$(date +%s)
		CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
		-p ${complex_folder}pocket.pdb \
		-l ${complex_folder}ligen_poses.sdf \
		-m $model_dir \
		-o $results_dir${sample_dir}.csv
		end_time=$(date +%s)
		elapsed=$(( end_time - start_time ))
		echo Finished...   time_elapsed: $elapsed  Secs
	fi
	# break
	done > eval_ALLPDBs.log

