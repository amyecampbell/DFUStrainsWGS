#!bin/bash
# cladebreaker
################
source ~/mambaforge/bin/activate ~/mambaforge/envs/cladebreaker2

mkdir -p /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_CC45

cladebreaker \
--input /home/acampbe/DFU/data/WGS_2020/cladebreaker/InputCSVs/CC45_input.csv \
--outdir /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_CC45 \
--coverage 100 --db /home/acampbe/DownloadedDatabases/WhatsGNU_Sau_Ortholog/Sau_Ortholog_10350.pickle \
--o --topgenomes_count 5 --force -profile conda -with-conda true \
-c /home/acampbe/DFU/data/WGS_2020/cladebreaker/penn_cluster.config

# raxML
################
source ~/mambaforge/bin/activate ~/mambaforge/envs/TreeEnv2
# Estimate tree based on roary output
raxmlHPC -m GTRGAMMA -p 19104 \
-s /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_CC45/roary_alignment/results/core_gene_alignment.aln \
-# 100 -n CC45.newick

mv *.newick /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_CC45/
rm *_45.newick.RUN*
