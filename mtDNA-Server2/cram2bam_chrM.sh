#!/bin/bash

#SBATCH --job-name=cram2bam_%j
#SBATCH --output=cram2bam_{{ID}}.out
#SBATCH --error=cram2bam_{{ID}}.err
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4

# Load required module
module load samtools

id={{ID}}

# Set file paths
REF="/home/users/allstaff/wang.lo/lab_bahlo/ref_db/human/hg38/GATK/fasta/Homo_sapiens_assembly38.fasta"
INPUT_CRAM="/vast/projects/bahlo_mtDNA/1000G/WGS/${id}.final.cram"
UNSORTED_BAM="/vast/projects/bahlo_mtDNA/1000G/chrM/${id}.chrM.bam"
SORTED_BAM="/vast/projects/bahlo_mtDNA/1000G/chrM/${id}.chrM.sorted.bam"

# Extract chrM and convert to BAM
samtools view -T "$REF" -b "$INPUT_CRAM" chrM > "$UNSORTED_BAM"

# Sort BAM
samtools sort -@ 4 -o "$SORTED_BAM" "$UNSORTED_BAM"

# Index sorted BAM
samtools index "$SORTED_BAM"

# Optional: remove unsorted BAM to save space
rm "$UNSORTED_BAM"

echo "chrM BAM conversion complete: $SORTED_BAM and index created."
