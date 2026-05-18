#Author: Babul Pradhan
#Date: 08/12/2025
#Purpose: Batched run of fusion gene identification from the quality controlled FASTQ files (from trimmomatic_fastqc_normal.sh) using Singularity based STAR-Fusion from normal samples

#!/bin/bash

sample_type="normal"

while read line
do
id=$line
echo "Sample is $id\n\n"

################
##Settings/Paths
################
#Replace the path of the "PE" trimmed ".fastq" files (output from Trimmomatic)
path_fastq="/home/user/DATA_02/Babul_August/2_trimmomatic/PE"
################
#This block is read identifiers, recommended to keep as it is
R1="$id""_""R1"
R2="$id""_""R2"
trimmed_PE_R1="$id""_""trimmed_PE""_""R1"
trimmed_PE_R2="$id""_""trimmed_PE""_""R2"
trimmed_UP_R1="$id""_""trimmed_UP""_""R1"
trimmed_UP_R2="$id""_""trimmed_UP""_""R2"
################
#Set the number of "threads" according to the system configuration
threads="20"
################
#Replace the path of the "genome_lib" with the /path/to/the/downloaded_and_extracted/ctat_genome_lib_build_dir
#Downloaded and extracted from "https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play.tar.gz"
genome_lib="/home/user/Babul/GIC/ref_genome/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play/ctat_genome_lib_build_dir"

#Replace the path of the downloaded STAR-Fusion Singularity Image v1.15.1, ".simg" file
#Downloaded from "https://data.broadinstitute.org/Trinity/CTAT_SINGULARITY/STAR-Fusion/star-fusion.v1.15.1.simg"
star_fusion_image="star-fusion.v1.15.1.simg"
################

mkdir -p STAR_Fusion STAR_Fusion/$sample_type

singularity exec -e -B `pwd` -B $genome_lib $star_fusion_image STAR-Fusion --left_fq $path_fastq/$trimmed_PE_R1.fastq --right_fq $path_fastq/$trimmed_PE_R2.fastq --genome_lib_dir $genome_lib -O STAR_Fusion/$sample_type/$id"."StarFusionOut --FusionInspector validate --examine_coding_effect --denovo_reconstruct --CPU $threads

done < samples_$sample_type.txt
