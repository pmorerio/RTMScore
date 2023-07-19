#!/bin/bash

### run the following in terminal
# conda activate rtmscore
# ./predict_ALLPDBs.sh

ALLPDBs_dir='/data01/pmorerio/ALLPDBs/*/'
model_dir='../trained_models/rtmscore_model1.pth'
results_dir_ligen='./results_ALLPDBs_ligen/'
results_dir_crystal='./results_ALLPDBs_crystal/'



# ################################# compute results using ligen and crystal ##################################
# # rm -r $results_dir_ligen
# # rm -r $results_dir_crystal
# ###
# # mkdir $results_dir_ligen
# # mkdir $results_dir_crystal
# sample_count=0
# for complex_folder in $ALLPDBs_dir
# 	do
# 	my_array=($(echo $complex_folder | tr "/" "\n"))
# 	# echo ${my_array[3]} # here [3] corresponds to sample's folder name, modify it according to ALLPDBs_dir path
# 	sample_dir="${my_array[3]}"
# 	#
# 	if [ ${#sample_dir} != 10 ]; then #if [[ ${#sample_dir} -eq 10 ]]; then
# 		((sample_count=sample_count+1))
# 		echo sample_count: $sample_count, ${complex_folder}
# 		# echo $sample_dir
# 		# echo ${complex_folder}pocket.pdb
# 		# echo ${complex_folder}ligen_poses.sdf
# 		# echo $results_dir_ligen${sample_dir}
# 		# echo $results_dir_crystal${sample_dir}
# 		start_time=$(date +%s)
# 		#
# 		CUDA_VISIBLE_DEVICES=0 python rtmscore.py -pl \
# 		-p ${complex_folder}pocket.pdb \
# 		-l ${complex_folder}ligen_poses.sdf \
# 		-m $model_dir \
# 		-o $results_dir_ligen${sample_dir}
# 		#
# 		CUDA_VISIBLE_DEVICES=0 python rtmscore.py -pl \
# 		-p ${complex_folder}pocket.pdb \
# 		-l ${complex_folder}crystal.sdf \
# 		-m $model_dir \
# 		-o $results_dir_crystal${sample_dir}
# 		#
# 		end_time=$(date +%s)
# 		elapsed=$(( end_time - start_time ))
# 		echo Finished...   time_elapsed: $elapsed  Secs
# 	fi
# 	done > eval_ALLPDBs.log


############################### concatenate results from crystal to ligen ####################################
results_dir_ligen=$results_dir_ligen$'*'
results_dir_crystal=$results_dir_crystal$'*'
results_dir='./results_ALLPDBs_RTMscore_single-underscore/'
###
rm -r $results_dir
###
mkdir $results_dir
sample_count=0
for complex_folder in $results_dir_crystal
	do
	###
	# echo $complex_folder
	my_array=($(echo $complex_folder | tr "/" "\n"))
	sample_file=${my_array[2]}
	# echo $sample_file
	sample_dir="$sample_file"
	if [[ ${#sample_dir} -eq 14 ]]; then # 10 name characters and 4 charaters in .csv 
		((sample_count=sample_count+1))
		echo sample_count: $sample_count, ${sample_file}
		# echo ${results_dir_ligen: 0:-1}$sample_file ${results_dir}$sample_file
		# echo ${results_dir_crystal: 0:-1}$sample_file ${results_dir}$sample_file$"_c"
		###
		cp ${results_dir_ligen: 0:-1}$sample_file ${results_dir}$sample_file
		cp ${results_dir_crystal: 0:-1}$sample_file ${results_dir}$sample_file$"_c"
		###
		sed -i '1s/.*/pose_ID\tSCORE/' ${results_dir}$sample_file
		sed -i '1d' ${results_dir}$sample_file$"_c"
		###
		val=$(cat "${results_dir}$sample_file"_c"")
		# echo $val
		#
		my_array=($(echo $val | tr " " "\n"))
		val_new=$(printf '%s %s 0\t%s' "${my_array[0]}" "${my_array[1]}" "${my_array[3]}")
		# echo $val_new
		# echo -e "$val_new" | hexdump -C
		echo "$val_new" >> ${results_dir}$sample_file
		###
		rm ${results_dir}$sample_file$"_c"
	fi
	# break
	done

