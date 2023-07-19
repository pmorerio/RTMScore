### Preporocess datasets

Generate graphs from `.mol2` with 
```
cd /data01/pmorerio/
cp PDBbind_2022_BK.tar.gz ~/codes/RTMScore/RTMScore/feats
cd ~/codes/RTMScore/RTMScore/feats
tar -xvzf PDBbind_2022_BK.tar.gz 
```

```
conda activate rtmscore
CUDA_VISIBLE_DEVICES=0 python -u mol2graph_rdmda_res.py -p -d ./PDBbind_2022_BK -c 10.0 -o ./graphs_for_pdbbind/v2022_train  2>&1 | tee mol2graph.log 
```


```
cp /data01/pmorerio/ALLPDBs.tar.gz ~/codes/RTMScore/RTMScore/feats
tar -xvzf ALLPDBs.tar.gz

conda activate rtmscore
CUDA_VISIBLE_DEVICES=0 python -u mol2graph_rdmda_res.py -p -d ./ALLPDBs -c 10.0 -o ./graphs_for_pdbbind/v2022_train  2>&1 | tee mol2graph.log 
```