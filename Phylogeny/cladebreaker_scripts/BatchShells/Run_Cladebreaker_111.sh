#!bin/bash
# cladebreaker
################
source ~/mambaforge/bin/activate ~/mambaforge/envs/cladebreaker2

mkdir -p /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_patient_111

cladebreaker \
--input /Users/amycampbell/Desktop/GriceLabGit/DFUStrainsWGS/Phylogeny/cladebreaker_scripts/InputCSVs/patient_111_input.csv \
--outdir /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_patient_111 \
--coverage 100 --db /home/acampbe/DownloadedDatabases/WhatsGNU_Sau_Ortholog/Sau_Ortholog_10350.pickle \
--o --topgenomes_count 5 --force -profile conda -with-conda true \
-c /home/acampbe/DFU/data/WGS_2020/cladebreaker/penn_cluster.config

# raxML
################
source ~/mambaforge/bin/activate ~/mambaforge/envs/TreeEnv2
# Estimate tree based on roary output
raxmlHPC -m GTRGAMMA -p 19104 \
-s /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_patient_111/roary_alignment/results/core_gene_alignment.aln \
-# 100 -npatient_111.newick

mv *.newick /home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_patient_111/
rm *_111.newick.RUN*
