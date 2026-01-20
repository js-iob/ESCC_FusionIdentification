#Author: Babul Pradhan
#Date: 08/12/2025
#Purpose: Batched run of fusion gene identification from the quality controlled FASTQ files (from trimmomatic_fastqc_tumor.sh) using Singularity based STAR-Fusion from tumor samples 

#!/bin/bash

sample_type="tumor"

while read line
do
id=$line
echo "Sample is $id\n\n"

################
##Settings
################
path_fastq="/home/user/DATA_02/Babul_August/2_trimmomatic"
R1="$id""_""R1"
R2="$id""_""R2"
trimmed_PE_R1="$id""_""trimmed_PE""_""R1"
trimmed_PE_R2="$id""_""trimmed_PE""_""R2"
trimmed_UP_R1="$id""_""trimmed_UP""_""R1"
trimmed_UP_R2="$id""_""trimmed_UP""_""R2"
threads="8"
################
genome_lib="/home/user/Babul/GIC/ref_genome/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play/ctat_genome_lib_build_dir"
star_fusion_image="star-fusion.v1.15.1.simg"
################

mkdir -p STAR_Fusion STAR_Fusion/$sample_type

singularity exec -e -B `pwd` -B $genome_lib $star_fusion_image STAR-Fusion --left_fq $path_fastq/PE/$trimmed_PE_R1.fastq --right_fq $path_fastq/PE/$trimmed_PE_R2.fastq --genome_lib_dir $genome_lib -O STAR_Fusion/$sample_type/$id"."StarFusionOut --FusionInspector validate --examine_coding_effect --denovo_reconstruct --CPU $threads

done < samples_$sample_type.txt
