#!/bin/bash

### run the following in terminal
# conda activate rtmscore
# ./predict_ALLPDBs_plants.sh

ALLPDBs_dir='/data01/pmorerio/ALLPDBs/*/'
PDBbind_plants_dir='/data01/pmorerio/PDBbind_plants/*/'
model_dir='../trained_models/rtmscore_model1.pth'
results_dir_plants_mol='./results_ALLPDBs_plants_mol/'
results_dir_plants_sdf='./results_ALLPDBs_plants_sdf/'

################################# compute results using plants_mol and plants_sdf ##################################
# rm -r $results_dir_plants_mol
# rm -r $results_dir_plants_sdf
###
# mkdir $results_dir_plants_mol
# mkdir $results_dir_plants_sdf
###
sample_count=0
for complex_folder in $ALLPDBs_dir
	do
	# echo $complex_folder
	my_array=($(echo $complex_folder | tr "/" "\n"))
	# echo ${my_array[3]} # here [3] corresponds to sample's folder name, modify it according to ALLPDBs_dir path
	root_array=($(echo $PDBbind_plants_dir | tr "/" "\n"))
	# echo ${root_array[2]}
	sample_dir="${my_array[3]}"
    # echo $sample_dir
	pocket_file="/""${my_array[0]}""/""${my_array[1]}""/""${my_array[2]}""/""${my_array[3]}""/pocket.pdb"
	poses_mol2_file="/""${root_array[0]}""/""${root_array[1]}""/""${root_array[2]}""/""${my_array[3]}""/plants_poses.mol2"
	poses_sdf_file="/""${root_array[0]}""/""${root_array[1]}""/""${root_array[2]}""/""${my_array[3]}""/plants_poses.sdf"
	#
	if [ ${#sample_dir} -eq 10 ] && [ ! -e $results_dir_plants_mol${sample_dir}'.csv' ]; then
		((sample_count=sample_count+1))
		echo sample_count: $sample_count, ${complex_folder}
		start_time=$(date +%s)
		#
		echo "Processing :" $pocket_file $poses_mol2_file
		CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
		-p $pocket_file \
		-l $poses_mol2_file \
		-m $model_dir \
		-o $results_dir_plants_mol${sample_dir}
		#
		echo "Processing :" $pocket_file $poses_sdf_file
		CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
		-p $pocket_file \
		-l $poses_sdf_file \
		-m $model_dir \
		-o $results_dir_plants_sdf${sample_dir}
		#
		end_time=$(date +%s)
		elapsed=$(( end_time - start_time ))
		echo Finished...   time_elapsed: $elapsed  Secs
	fi
    # break
	done > eval_ALLPDBs_plants.log



# ############################### concatenate results from plants_sdf to plants_mol ####################################
# results_dir_plants_mol=$results_dir_plants_mol$'*'
# results_dir_plants_sdf=$results_dir_plants_sdf$'*'
# results_dir='./results_ALLPDBs_DimeNet_single-underscore/'
# ###
# rm -r $results_dir
# ###
# mkdir $results_dir
# sample_count=0
# for complex_folder in $results_dir_crystal
# 	do
# 	###
# 	# echo $complex_folder
# 	my_array=($(echo $complex_folder | tr "/" "\n"))
# 	sample_file=${my_array[2]}
# 	# echo $sample_file
# 	sample_dir="$sample_file"
# 	if [[ ${#sample_dir} -eq 14 ]]; then # 10 name characters and 4 charaters in .csv 
# 		((sample_count=sample_count+1))
# 		echo sample_count: $sample_count, ${sample_file}
# 		# echo ${results_dir_plants_mol: 0:-1}$sample_file ${results_dir}$sample_file
# 		# echo ${results_dir_plants_sdf: 0:-1}$sample_file ${results_dir}$sample_file$"_c"
# 		###
# 		cp ${results_dir_plants_mol: 0:-1}$sample_file ${results_dir}$sample_file
# 		cp ${results_dir_plants_sdf: 0:-1}$sample_file ${results_dir}$sample_file$"_c"
# 		###
# 		sed -i '1s/.*/pose_ID\tSCORE/' ${results_dir}$sample_file
# 		sed -i '1d' ${results_dir}$sample_file$"_c"
# 		###
# 		val=$(cat "${results_dir}$sample_file"_c"")
# 		# echo $val
# 		#
# 		my_array=($(echo $val | tr " " "\n"))
# 		val_new=$(printf '%s %s 0\t%s' "${my_array[0]}" "${my_array[1]}" "${my_array[3]}")
# 		# echo $val_new
# 		# echo -e "$val_new" | hexdump -C
# 		echo "$val_new" >> ${results_dir}$sample_file
# 		###
# 		rm ${results_dir}$sample_file$"_c"
# 	fi
# 	# break
# 	done

