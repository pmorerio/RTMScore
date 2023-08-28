#!/bin/bash

### run the following in terminal
# conda activate rtmscore
# ./predict_GOSTAR.sh

mol2_data_dir='/home/wahmed/codes/data/short_targets____BBB/*/'
model_dir='../trained_models/rtmscore_model1.pth'
results_dir_mol='./results_RTMScore_GOSTAR_mol/'
results_dir_sdf='./results_RTMScore_GOSTAR_sdf/'
# results_dir_crystal='./results_ALLPDBs_crystal/*'

################################# compute results using plants_mol and plants_sdf ##################################
rm -r $results_dir_mol
rm -r $results_dir_sdf
###
mkdir $results_dir_mol
mkdir $results_dir_sdf
###
sample_count=0
for complex_folder in $mol2_data_dir
	do
	# echo $complex_folder
	pocket_file=$complex_folder$"pocket.pdb"
	poses_mol2_file=$(find $complex_folder -type f -name "*.mol2")
	poses_sdf_file=$(find $complex_folder$"LIGEN/" -type f -name "*.sdf")
	my_array=($(echo $complex_folder | tr "/" "\n"))
	sample_dir="${my_array[-1]}"
	###
	# if [ ${#sample_dir} -eq 10 ] && [ ! -e $results_dir_mol${sample_dir}'.csv' ]; then
	((sample_count=sample_count+1))
	echo sample_count: $sample_count, ${sample_dir}
	start_time=$(date +%s)
	#
	echo "Processing :" $pocket_file $poses_mol2_file $poses_sdf_file $results_dir_mol$sample_dir$".csv" $results_dir_sdf$sample_dir$".csv"
	###
	CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
	-p $pocket_file \
	-l $poses_mol2_file \
	-m $model_dir \
	-o $results_dir_mol${sample_dir}
	###
	CUDA_VISIBLE_DEVICES=1 python rtmscore.py -pl \
	-p $pocket_file \
	-l $poses_sdf_file \
	-m $model_dir \
	-o $results_dir_sdf${sample_dir}
	###
	# echo "concatenating crystal" ${results_dir_mol: 0:-1}"/"$sample_dir".csv" ${results_dir_crystal: 0:-1}$sample_dir".csv"
	# cp ${results_dir_crystal: 0:-1}$sample_dir".csv" ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c"
	# sed -i '1d' ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c"
	# val=$(cat ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c")
	# # echo $val
	# my_array=($(echo $val | tr " " "\n"))
	# val_new=$(printf '%s %s 0\t%s' "${my_array[0]}" "${my_array[1]}" "${my_array[3]}")
	# # echo $val_new
	# # echo -e "$val_new" | hexdump -C
	# echo "$val_new" >> ${results_dir_mol: 0:-1}"/"$sample_dir".csv"
	# rm ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c"
	###
	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	echo Finished...   time_elapsed: $elapsed  Secs
	# fi
    # break
	done > eval_GOSTAR.log




