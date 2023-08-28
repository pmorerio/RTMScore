#!/bin/bash

### run the following in terminal
# conda activate rtmscore
# ./predict_RSCPDB-plants.sh

ALLPDBs_dir='/data01/pmorerio/ALLPDBs/*/'
PDB_plants_dir='/home/wahmed/codes/data/RSCPDB_Plants/PDBs_short/*/Plants_chemplp_speed1'
model_dir='../trained_models/rtmscore_model1.pth'
results_dir_mol='./results_RTMScore_RSCPDB_Plants_mol/'
results_dir_crystal='./results_ALLPDBs_crystal/*'

################################# compute results using plants_mol and plants_sdf ##################################
rm -r $results_dir_mol
###
mkdir $results_dir_mol
###
sample_count=0
for complex_folder in $PDB_plants_dir
	do
	# echo $complex_folder
	my_array=($(echo $complex_folder | tr "/" "\n"))
	# echo ${my_array[3]} # here [3] corresponds to sample's folder name, modify it according to ALLPDBs_dir path
	root_array=($(echo $ALLPDBs_dir | tr "/" "\n"))
	# echo ${root_array[2]}
	sample_dir="${my_array[6]}"
    # echo $sample_dir
	pocket_file="/""${root_array[0]}""/""${root_array[1]}""/""${root_array[2]}""/"$sample_dir"/pocket.pdb"
	poses_mol2_file=$complex_folder"/docked_ligands.mol2"
	###
	# if [ ${#sample_dir} -eq 10 ] && [ ! -e $results_dir_mol${sample_dir}'.csv' ]; then
	((sample_count=sample_count+1))
	echo sample_count: $sample_count, ${sample_dir}
	start_time=$(date +%s)
	#
	echo "Processing :" $pocket_file $poses_mol2_file
	CUDA_VISIBLE_DEVICES=0 python rtmscore.py -pl \
	-p $pocket_file \
	-l $poses_mol2_file \
	-m $model_dir \
	-o $results_dir_mol${sample_dir}
	###
	echo "concatenating crystal" ${results_dir_mol: 0:-1}"/"$sample_dir".csv" ${results_dir_crystal: 0:-1}$sample_dir".csv"
	cp ${results_dir_crystal: 0:-1}$sample_dir".csv" ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c"
	sed -i '1d' ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c"
	val=$(cat ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c")
	# echo $val
	my_array=($(echo $val | tr " " "\n"))
	val_new=$(printf '%s %s 0\t%s' "${my_array[0]}" "${my_array[1]}" "${my_array[3]}")
	# echo $val_new
	# echo -e "$val_new" | hexdump -C
	echo "$val_new" >> ${results_dir_mol: 0:-1}"/"$sample_dir".csv"
	rm ${results_dir_mol: 0:-1}"/"$sample_dir$".csv_c"
	###
	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	echo Finished...   time_elapsed: $elapsed  Secs
	# fi
    # break
	done > eval_RSCPDB_Plants.log




