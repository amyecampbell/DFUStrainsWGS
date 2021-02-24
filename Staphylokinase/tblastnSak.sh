#!/bin/bash
# Blast searching for sak gene (based on Roary  in each of the assemblies
source /home/acampbe/software/miniconda3/bin/activate BlastEnv

outputfolder="/home/acampbe/DFU/data/WGS_2020/KinaseTBlastN/"
mkdir -p $outputfolder

for fastaname in /project/grice/storage/HiSeq/WGS/HiSeq_19/AssemblyFastas/DFU100_Cleaned_Assemblies/FinalContigs/*.fasta; do
        base=$(basename $fastaname)
        baseext=".fasta"
        blank=""
        extensionless=${base/$baseext/$blank}
        tabext=".tab"
        makeblastdb -in $fastaname -dbtype nucl -out $extensionless
        tblastn -query sak_uniprot.fa -out $outputfolder$extensionless$tabext -db $extensionless -outfmt "6 qseqid sseqid pident length sstart send qcovs evalue bitscore"
	tab="\t"
	fileprefix=$extensionless$tab
	sed -i -e "s/^/$fileprefix/" "$outputfolder$extensionless$tabext"
done

cat > "/home/acampbe/DFU/data/WGS_2020/KinaseTBlastN/CombinedKinaseTBlastNs.tab"

for file in /home/acampbe/DFU/data/WGS_2020/KinaseTBlastN/*.tab; do
   if [ -s "$file" ] ; then
      cat $file >> "/home/acampbe/DFU/data/WGS_2020/KinaseTBlastN/CombinedKinaseTBlastNs.tab"
   else
      echo "$file"
   fi
done 
