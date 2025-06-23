# install mity using Docker image

# Set working directory
work_dir=/vast/projects/bahlo_mtDNA/
cd $work_dir || { echo "Failed to change to $work_dir"; exit 1; }

# Create software directory if it doesn't exist
mkdir -p software
cd software || { echo "Failed to change to $work_dir/software"; exit 1; }

# Load the Apptainer module
module load apptainer

# Pull the mity image from DockerHub using Apptainer
apptainer pull mity_latest.sif docker://drmjc/mity:2.0.0
