# Amy Campbell
# Feb 2023
# Make a shellscript for each patient with a CSV in input csvs folder for cladebreaker
# also make a helpful little text file of bsub commands to kick off these jobs :)
import os

PathToInputs="/Users/amycampbell/Desktop/GriceLabGit/DFUStrainsWGS/Phylogeny/cladebreaker_scripts/InputCSVs/"
configstring="/home/acampbe/DFU/data/WGS_2020/cladebreaker/penn_cluster.config"


listInputs = os.listdir(PathToInputs)
#len(listInputs)
jobcommands=[]
for l in range(len(listInputs)):
    inputcsvpath = PathToInputs + str(listInputs[l])
    jobIDstring=listInputs[l].replace("_input.csv", "")
    outputpath="/home/acampbe/DFU/data/WGS_2020/cladebreaker/cladebreaker_" + jobIDstring
    inputpath=PathToInputs + listInputs[l]
    NumberID=jobIDstring.replace("patient_","")
    BatchFileName="Run_Cladebreaker_" + str(NumberID) +".sh"
    BatchFilePath = "/Users/amycampbell/Desktop/GriceLabGit/DFUStrainsWGS/Phylogeny/cladebreaker_scripts/BatchShells/" + BatchFileName
    jobRunCommand= "bsub -e " + jobIDstring + ".e -o " + jobIDstring + ".o sh " +  BatchFileName
    with open(BatchFilePath, "w") as outputshell:
        outputshell.write("#!bin/bash\n")
        outputshell.write("# cladebreaker\n")
        outputshell.write("################\n")
        outputshell.write("source ~/mambaforge/bin/activate ~/mambaforge/envs/cladebreaker2\n")
        outputshell.write("\n")
        outputshell.write("mkdir -p " + outputpath + "\n")
        outputshell.write("\n")
        outputshell.write("cladebreaker \\\n")
        outputshell.write("--input "+inputpath+" \\\n")
        outputshell.write("--outdir " + outputpath + " \\\n")
        outputshell.write("--coverage 100 --db /home/acampbe/DownloadedDatabases/WhatsGNU_Sau_Ortholog/Sau_Ortholog_10350.pickle \\\n")
        outputshell.write("--o --topgenomes_count 5 --force -profile conda -with-conda true \\\n")
        outputshell.write("-c /home/acampbe/DFU/data/WGS_2020/cladebreaker/penn_cluster.config")
        outputshell.write("\n")
        outputshell.write("\n")
        outputshell.write("# raxML\n")
        outputshell.write("################\n")
        outputshell.write("source ~/mambaforge/bin/activate ~/mambaforge/envs/TreeEnv2\n")
        outputshell.write("# Estimate tree based on roary output\n")
        outputshell.write("raxmlHPC -m GTRGAMMA -p 19104 \\\n")
        outputshell.write("-s " + outputpath+ "/roary_alignment/results/core_gene_alignment.aln" + " \\\n")
        outputshell.write("-# 100 -n"  + jobIDstring + ".newick\n")
        outputshell.write("\n")
        outputshell.write("mv *.newick " + outputpath + "/\n")
        outputshell.write("rm *_" + str(NumberID) + ".newick.RUN*\n")
    jobcommands.append(jobRunCommand)
with open("CladebreakerCommandList.txt", "w") as OutputListCommands:
    for i in range(len(jobcommands)):
        OutputListCommands.write(jobcommands[i] + "\n")
