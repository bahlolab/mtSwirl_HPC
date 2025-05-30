#!/bin/bash

#SBATCH --time=3:00:00
#SBATCH --mem=10G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=mity
#SBATCH --error=mity.err
#SBATCH --output=mity.out
#SBATCH --mail-user=wang.lo@wehi.edu.au
#SBATCH --mail-type=END,FAIL

# Define working and data directories
work_dir=/vast/scratch/users/wang.lo/1000G
data_dir=$work_dir/data/WGS

# Move to mity working directory
cd $work_dir/mity || { echo "Failed to change directory to $work_dir/mity"; exit 1; }

# Load Apptainer module
module load apptainer

# Log Apptainer and working paths
echo "Running mity using Apptainer container..."
echo "Data directory: $data_dir"
echo "Working directory: $(pwd)"
echo "Timestamp: $(date)"

# Run mity call and report inside the Apptainer container
#apptainer exec --bind $data_dir:/data $work_dir/software/mity_latest.sif \
#bash -c 'mity call --reference hg38 --prefix 1000G --normalise --bam-file-list 1000G.txt && \
#             mity report --prefix 1000G --min_vaf 0.01 --contig chrM 1000G.normalise.vcf.gz'

apptainer exec --bind $data_dir:/data $work_dir/software/mity_latest.sif bash -c '
    echo "Running mity call..."
    mity call --reference hg38 --prefix 1000G --normalise --bam-file-list 1000G.txt || { echo "mity call failed"; exit 1; }

    echo "Running mity report..."
    mity report --prefix 1000G --min_vaf 0.01 --contig chrM 1000G.normalise.vcf.gz || { echo "mity report failed"; exit 1; }

    echo "Finished successfully at $(date)"
'
