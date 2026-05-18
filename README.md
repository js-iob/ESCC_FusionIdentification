## ESCC_FusionIdentification
This repository contains bash and Perl scripts used to reproduce the results of the primary gene fusion detection from RNA-Seq of 12 paired tumor-normal samples of patients with ESCC for further filtration steps performed

## Quick Start

1. Obtain the RNA-Seq data (in .fastq format) of 12 paired tumor-normal samples of patients with ESCC from the source as described in the "**Data and Code availability**" section of the original manuscript.
2. Ensure naming the prefix of the ".fastq" files with the respective sample ID as in the provided "samples_{normal|tumor}.txt" file, followed by "_R1" or "_R2" as applicable from the NCBI metadata of the respective samples, **only if not in this original format already**.

    *For example: "3507_15_T_R1.fastq" and "3507_15_T_R2.fastq"
4. Install the pre-requisite tools/data as per the version described in the original manuscript or as applicable (Refer to the instructions of the original publisher of the tools in case of facing difficulties installing)

    *Trimmomatic-0.39: http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
 
    *FastQC v0.11.9: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
 
    *STAR v2.7.11b: https://github.com/alexdobin/STAR/releases/download/2.7.11b/STAR_2.7.11b.zip

    *samtools: https://github.com/samtools/samtools

    *GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play Reference Genome Library (extract/decompress): https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/GRCh38_gencode_v44_CTAT_lib_Oct292023.plug-n-play.tar.gz

    *SingularityCE: https://docs.sylabs.io/guides/4.4/user-guide/quick_start.html#quick-installation-steps

    *STAR-Fusion Singularity Image v1.15.1: https://data.broadinstitute.org/Trinity/CTAT_SINGULARITY/STAR-Fusion/star-fusion.v1.15.1.simg

    *Arriba v2.5.1: https://github.com/suhrig/arriba/releases/download/v2.5.1/arriba_v2.5.1.tar.gz, and https://github.com/suhrig/arriba/wiki/02-Quickstart#manual-installation
6. Clone this repo/download the scripts into a working directory
7. Replace the "Paths" or other applicable settings (commented with #Settings/Paths and well documented) in the scripts accordingly
8. Run the following scripts sequencially

   a. **Quality Control**: "trimmomatic_fastqc_normal.sh" and "trimmomatic_fastqc_tumor.sh"

   b. **STAR-Fusion**: "star_fusion_normal.sh" and "star_fusion_tumor.sh"

   c. **Arriba**: "arriba_normal.sh" and "arriba_tumor.sh"

   d. **Merge gene fusion calls**: "merge_star_fusion_calls_tumor_normal.pl" and "merge_arriba_calls_tumor_normal.pl"
10. This reproduces the primary gene fusion calls from both the tools. The gene fusion calls resulted can be used for further filtration performed as per the steps described in the original manuscript (removal of gene fusions present in normal samples, DepMap filtration, intersection for common gene fusions), without the need of any script.

## Thank You.


