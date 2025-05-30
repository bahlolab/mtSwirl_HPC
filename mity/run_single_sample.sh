#!/bin/bash

# Set working and data directories
work_dir=/vast/project/bahlo_mtDNA
data_dir=/vast/scratch/users/wang.lo/1000G/data/WGS
sample_id=HG00446
cram_file=${sample_id}.final.cram

# Output directory
output_dir=$work_dir/mity
mkdir -p $output_dir

# Load Apptainer
module load apptainer

# Run mity call and report in one container session
apptainer exec --bind $data_dir:/data --bind $output_dir:/out $work_dir/software/mity_latest.sif bash -c "
    echo 'Running mity call for $sample_id...'
    mity call --reference hg38 --prefix $sample_id --output-dir /out --normalise /data/$cram_file || { echo 'mity call failed'; exit 1; }

    echo 'Running mity report for $sample_id...'
    cd /out
    mity report --prefix $sample_id --min_vaf 0.01 --contig chrM ${sample_id}.normalise.vcf.gz || { echo 'mity report failed'; exit 1; }

    echo 'mity completed for $sample_id.'
"
