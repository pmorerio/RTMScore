#!/bin/bash
# ./remove_heavy_atoms.sh  /data2T/CASF-2016-poses


# mkdir results_casf2016
for pocket_file in $1/*/pocket.pdb 
do
	ls -l ${pocket_file}
	less ${pocket_file} | grep -v HETATM > ${pocket_file}

	done
