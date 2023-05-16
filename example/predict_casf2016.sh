#!/bin/bash

data_dir='data_concatenated_casf2016/'
coreset_dir='/data01/pmorerio/CASF-2016/coreset/*/'
decoys_dir='/data01/pmorerio/CASF-2016/decoys_docking/'
model_dir='../trained_models/rtmscore_model1.pth'
results_coreset_dir='./results_coreset_casf2016/'
results_decoys_dir='./results_decoys_casf2016/'
results_concatenated_dir='./results_concatenated_casf2016/'
###
rm -r $data_dir $results_coreset_dir $results_decoys_dir $results_concatenated_dir
###
mkdir $data_dir $results_coreset_dir $results_decoys_dir $results_concatenated_dir
for complex_folder in $coreset_dir
	do
	### echo (for debugging only)
	echo ${complex_folder}
	echo ${complex_folder: -5:4}
	echo ${complex_folder}${complex_folder: -5:4}_pocket.pdb
	echo ${complex_folder}${complex_folder: -5:4}_ligand.mol2
	echo ${data_dir}${complex_folder: -5:4}_pocket.pdb
	echo ${data_dir}${complex_folder: -5:4}_ligand.mol2
	### copy files
	mkdir ${data_dir}${complex_folder: -5:4}/
	cp ${complex_folder}${complex_folder: -5:4}_pocket.pdb ${data_dir}${complex_folder: -5:4}/
	cp ${complex_folder}${complex_folder: -5:4}_ligand.mol2 ${data_dir}${complex_folder: -5:4}/		
	cp ${decoys_dir}${complex_folder: -5:4}_decoys.mol2 ${data_dir}${complex_folder: -5:4}/			
	cp ${decoys_dir}${complex_folder: -5:4}_decoys.mol2 ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_concatenated.mol2
	### concatenate e.g., '../coreset/5tmn/5tmn_ligand.mol2' to '../decoys_docking/5tmn_decoys.mol2' and create new file in data_dir e.g., '/data_concatenated_casf2016/5tmn_concatenated.mol2'
	cat ${complex_folder}${complex_folder: -5:4}_ligand.mol2 >> ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_concatenated.mol2
	### coreset
	start_time=$(date +%s)
	python rtmscore.py -pl \
	-p ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_pocket.pdb \
	-l ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_ligand.mol2 \
	-m $model_dir \
	-o $results_coreset_dir${complex_folder: -5:4}
	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	echo $elapsed
	### decoys
	start_time=$(date +%s)
	python rtmscore.py -pl \
	-p ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_pocket.pdb \
	-l ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_decoys.mol2 \
	-m $model_dir \
	-o $results_decoys_dir${complex_folder: -5:4}
	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	echo $elapsed
	### concatenated
	start_time=$(date +%s)
	python rtmscore.py -pl \
	-p ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_pocket.pdb \
	-l ${data_dir}${complex_folder: -5:4}/${complex_folder: -5:4}_concatenated.mol2 \
	-m $model_dir \
	-o $results_concatenated_dir${complex_folder: -5:4}
	end_time=$(date +%s)
	elapsed=$(( end_time - start_time ))
	echo $elapsed
	done

### script to process coreset alone
# mkdir results_casf2016
# for complex_folder in /data01/pmorerio/CASF-2016/coreset/*/  
# 	do
# 	echo ${complex_folder}
# 	echo ${complex_folder: -5:4}
# 	echo ${complex_folder}${complex_folder: -5:4}_pocket.pdb
# 	echo "./results_casf2016/${complex_folder: -5:4}.csv"
# 	start_time=$(date +%s)
# 	python rtmscore.py -pl \
# 	-p ${complex_folder}${complex_folder: -5:4}_pocket.pdb \
# 	-l ${complex_folder}${complex_folder: -5:4}_ligand.mol2 \
# 	-m ../trained_models/rtmscore_model1.pth \
# 	-o "./results_casf2016/${complex_folder: -5:4}"	
# 	end_time=$(date +%s)
# 	elapsed=$(( end_time - start_time ))
# 	echo $elapsed
# 	done
