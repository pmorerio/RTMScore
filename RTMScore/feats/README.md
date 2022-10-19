### Preporocess datasets

Generate graphs from `.mol2` with 
```
python -u  mol2graph_rdmda_res.py -p -d /data2T/PDBbind_2022_BK/ -c 10.0 -o /data2T/graphs_for_pdbbind/v2022_train_  2>&1 | tee mol2graph.log 
```