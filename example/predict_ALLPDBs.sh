#!/bin/bash

### run the following in terminal
# conda activate rtmscore
# ./predict_ALLPDBs.sh

ALLPDBs_dir='/home/wahmed/codes/RTMScore/RTMScore/feats/ALLPDBs/*/'
model_dir='../trained_models/rtmscore_model1.pth'
results_dir_ligen='./results_ALLPDBs_ligen/'
results_dir_crystal='./results_ALLPDBs_crystal/'

# ################################ compute results using ligen ###################################
# rm -r $results_dir_ligen
# ###
# mkdir $results_dir_ligen
# sample_count=0
# for complex_folder in $ALLPDBs_dir
# 	do
# 	### echo (for debugging only)
# 	# echo ${complex_folder}
# 	# echo ${complex_folder}pocket.pdb
# 	# echo ${complex_folder}ligen_poses.sdf
# 	#
# 	my_array=($(echo $complex_folder | tr "/" "\n"))
# 	sample_dir="${my_array[7]}"
# 	#
# 	if [[ ${#sample_dir} -eq 10 ]]
# 	then
# 		((sample_count=sample_count+1))
# 		echo sample_count: $sample_count, ${complex_folder}
# 		# echo $sample_dir
# 		# echo "The sample_dir name (" ${sample_dir} ") is of 10 characters"
# 		# echo ${complex_folder}pocket.pdb
# 		# echo ${complex_folder}ligen_poses.sdf
# 		# echo $results_dir_ligen${sample_dir}.csv 
# 		start_time=$(date +%s)
# 		CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
# 		-p ${complex_folder}pocket.pdb \
# 		-l ${complex_folder}ligen_poses.sdf \
# 		-m $model_dir \
# 		-o $results_dir_ligen${sample_dir}.csv
# 		end_time=$(date +%s)
# 		elapsed=$(( end_time - start_time ))
# 		echo Finished...   time_elapsed: $elapsed  Secs
# 	fi
# 	# break
# 	done > eval_ALLPDBs_ligen.log


# ################################ compute results using crystal ###################################
# rm -r $results_dir_crystal
# ###
# mkdir $results_dir_crystal
# sample_count=0
# for complex_folder in $ALLPDBs_dir
# 	do
# 	### echo (for debugging only)
# 	# echo ${complex_folder}
# 	# echo ${complex_folder}pocket.pdb
# 	# echo ${complex_folder}crystal.sdf
# 	#
# 	my_array=($(echo $complex_folder | tr "/" "\n"))
# 	sample_dir="${my_array[7]}"
# 	#
# 	if [[ ${#sample_dir} -eq 10 ]]
# 	then
# 		((sample_count=sample_count+1))
# 		echo sample_count: $sample_count, ${complex_folder}
# 		# echo $sample_dir
# 		# echo "The sample_dir name (" ${sample_dir} ") is of 10 characters"
# 		# echo ${complex_folder}pocket.pdb
# 		# echo ${complex_folder}crystal.sdf
# 		# echo $results_dir_crystal${sample_dir}.csv 
# 		start_time=$(date +%s)
# 		CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
# 		-p ${complex_folder}pocket.pdb \
# 		-l ${complex_folder}crystal.sdf \
# 		-m $model_dir \
# 		-o $results_dir_crystal${sample_dir}.csv
# 		end_time=$(date +%s)
# 		elapsed=$(( end_time - start_time ))
# 		echo Finished...   time_elapsed: $elapsed  Secs
# 	fi
# 	# break
# 	done > eval_ALLPDBs_crystal.log


############################### concatenate results from crystal to ligen ####################################
results_dir_crystal='/home/wahmed/codes/RTMScore/example/results_ALLPDBs_crystal/*'
results_dir_ligen='/home/wahmed/codes/RTMScore/example/results_ALLPDBs_ligen/*'
results_dir='./results_ALLPDBs/'
###
rm -r $results_dir
###
mkdir $results_dir
sample_count=0
for complex_folder in $results_dir_crystal
	do
	###
	echo ${complex_folder: -18:18}
	# echo ${results_dir_crystal: 0:-1}${complex_folder: -18:18}
	# echo ${results_dir_ligen: 0:-1}${complex_folder: -18:18}
	###
	cp ${results_dir_ligen: 0:-1}${complex_folder: -18:18} ${results_dir}${complex_folder: -18:14}
	cp ${results_dir_crystal: 0:-1}${complex_folder: -18:18} ${results_dir}${complex_folder: -18:18}
	###
	sed -i '1d' ${results_dir}${complex_folder: -18:18}
	###
	cat ${results_dir}${complex_folder: -18:18} >> ${results_dir}${complex_folder: -18:14}
	###
	rm ${results_dir}${complex_folder: -18:18}
	done

