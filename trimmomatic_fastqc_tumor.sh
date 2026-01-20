#Author: Babul Pradhan
#Date: 07/10/2025
#Purpose: Batch preprocessing of quality control of raw RNA-seq FASTQ files of 12 tumor samples from the patients with ESCC using Trimmomatic (adapter/quality trimming) followed by FastQC

#!/bin/bash

sample_type="tumor"

while read line
do
id=$line
echo "Sample is $id\n\n"

################
##Settings
################
path_fastq="/home/user/DATA_02/Babul_64GB_system_files/job/normal"
path_trimmomatic="/home/user/DATA_02/Babul_August/2_trimmomatic"
path_fastqc="3_fastqc"
R1="$id""_""R1"
R2="$id""_""R2"
trimmed_PE_R1="$id""_""trimmed_PE""_""R1"
trimmed_PE_R2="$id""_""trimmed_PE""_""R2"
trimmed_UP_R1="$id""_""trimmed_UP""_""R1"
trimmed_UP_R2="$id""_""trimmed_UP""_""R2"
threads="8"
################
trimmomatic_dir="/home/user/softwares/Trimmomatic-0.39"
fastqc_dir="/home/user/softwares/FastQC"
################
mkdir -p $path_trimmomatic $path_trimmomatic/PE $path_trimmomatic/UP

java -jar $trimmomatic_dir/trimmomatic-0.39.jar PE -threads 8 -phred33 $path_fastq/$R1.fastq $path_fastq/$R2.fastq $path_trimmomatic/PE/$trimmed_PE_R1.fastq $path_trimmomatic/UP/$trimmed_UP_R1.fastq $path_trimmomatic/PE/$trimmed_PE_R2.fastq $path_trimmomatic/UP/$trimmed_UP_R2.fastq ILLUMINACLIP:$trimmomatic_dir/adapters/TruSeq3-PE.fa:2:30:10:2:True MINLEN:70


mkdir -p $path_fastqc $path_fastqc/temp

$fastqc_dir/fastqc $path_trimmomatic/PE/$trimmed_PE_R1.fastq $path_trimmomatic/PE/$trimmed_PE_R2.fastq --outdir $path_fastqc --threads $threads --dir $path_fastqc/temp

done < samples_$sample_type.txt
