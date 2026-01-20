#Author: Babul Pradhan
#Date: 09/02/2025
#Purpose: Batched run of fusion gene identification from the quality controlled FASTQ files (from trimmomatic_fastqc_normal.sh) using STAR piped Arriba from normal samples

#!/bin/bash

sample_type="normal"

while read line
do
id=$line
echo "Sample is $id\n\n"

################
##Settings
################
arriba_dir="/home/user/softwares/arriba_v2.5.1"
ref_dir="/home/user/DATA/Babul_August/ref_genome/genome_ensembl_style/113"
##########################################
STAR_INDEX_DIR="/home/user/DATA/Babul_August/ref_genome/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play/ctat_genome_lib_build_dir/ref_genome.fa.star.idx"
ANNOTATION_GTF="/home/user/DATA/Babul_August/ref_genome/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play/ctat_genome_lib_build_dir/ref_annot.gtf"
ASSEMBLY_FA="/home/user/DATA/Babul_August/ref_genome/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play/ctat_genome_lib_build_dir/ref_genome.fa"
BLACKLIST_TSV="$arriba_dir/database/blacklist_hg38_GRCh38_v2.5.1.tsv.gz"
KNOWN_FUSIONS_TSV="$arriba_dir/database/known_fusions_hg38_GRCh38_v2.5.1.tsv.gz"
TAGS_TSV="$KNOWN_FUSIONS_TSV" # different files can be used for filtering and tagging, but the provided one can be used for both
PROTEIN_DOMAINS_GFF3="$arriba_dir/database/protein_domains_hg38_GRCh38_v2.5.1.gff3"
THREADS="20"
READ1="/home/user/DATA/Babul_August/2_trimmomatic/PE/$id""_""trimmed_PE_R1.fastq"
READ2="/home/user/DATA/Babul_August/2_trimmomatic/PE/$id""_""trimmed_PE_R2.fastq"
##########################################
results_dir="/home/user/DATA_02/Babul_August_3TB/Arriba"
BASE_DIR="$arriba_dir"
##########################################

mkdir -p $results_dir $results_dir/$sample_type $results_dir/$sample_type/$id

echo "STAR Alignment and Arriba Starting....\n"

# align FastQ files (STAR >=2.7.10a recommended)
STAR \
	--runThreadN "$THREADS" \
	--genomeDir "$STAR_INDEX_DIR" --genomeLoad NoSharedMemory \
	--readFilesIn "$READ1" "$READ2" \
	--outStd BAM_Unsorted --outSAMtype BAM Unsorted --outSAMunmapped Within --outBAMcompression 0 --outSAMattributes NH HI AS nM ch \
	--outFilterMultimapNmax 50 --peOverlapNbasesMin 10 --alignSplicedMateMapLminOverLmate 0.5 --alignSJstitchMismatchNmax 5 -1 5 5 \
	--chimSegmentMin 10 --chimOutType WithinBAM HardClip --chimJunctionOverhangMin 10 --chimScoreDropMax 30 --chimScoreJunctionNonGTAG 0 --chimScoreSeparation 1 --chimSegmentReadGapMax 3 --chimMultimapNmax 50 |

tee Aligned.out.bam |

# call arriba
"$BASE_DIR/arriba" \
	-x /dev/stdin \
	-o $results_dir/$sample_type/$id/fusions.tsv -O $results_dir/$sample_type/$id/fusions.discarded.tsv \
	-a "$ASSEMBLY_FA" -g "$ANNOTATION_GTF" -b "$BLACKLIST_TSV" -k "$KNOWN_FUSIONS_TSV" -t "$TAGS_TSV" -p "$PROTEIN_DOMAINS_GFF3" \
#	-d structural_variants_from_WGS.tsv

echo "STAR Alignment and Arriba Complete....\n"

# sorting and indexing is only required for visualization
if [[ $(samtools --version-only 2> /dev/null) =~ ^1\. ]]; then
	echo "samtools sort -@ "$THREADS" -m $((40000/THREADS))M -T tmp -O bam Aligned.out.bam > Aligned.sorted.bam\n"
	samtools sort -@ "$THREADS" -m $((40000/THREADS))M -T tmp -O bam Aligned.out.bam > Aligned.sorted.bam
	echo "rm -f Aligned.out.bam\n"
	rm -f Aligned.out.bam
	echo "samtools index Aligned.sorted.bam\n"
	samtools index Aligned.sorted.bam
	echo "Moving files to $results_dir Starting....\n"
	mv Aligned.sorted.* $results_dir/$sample_type/$id/
	mv Log.* $results_dir/$sample_type/$id/
	mv SJ.out.tab $results_dir/$sample_type/$id/
	echo "Moving files to $results_dir Complete....\n"
else
	echo "samtools >= 1.0 required for sorting of alignments" 1>&2
fi

done < samples_$sample_type.txt
