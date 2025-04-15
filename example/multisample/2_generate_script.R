rm(list = ls())
setwd("/vast/scratch/users/wang.lo/mtSwirl_HPC/MacTel/")

input <- read.table("input_list.txt", header = T, sep = "\t")

writeLines("cd /vast/scratch/users/wang.lo/mtSwirl_HPC/MacTel\n", "run.sh")

for(i in 1:nrow(input)){
  # Define the sample value
  sample <- input$sample[i]
  
  # Define the content of the shell script
  script_content <- sprintf(
    "#!/bin/bash

#SBATCH --time=8:00:00
#SBATCH --mem=3G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=mtSwirl
#SBATCH --error=%s.err
#SBATCH --output=%s.out
#SBATCH --mail-user=wang.lo@wehi.edu.au

export APPTAINER_TMPDIR=/vast/scratch/users/$USER/tmp 
export APPTAINER_CACHEDIR=/vast/scratch/users/$USER/scache 
[ ! -d $APPTAINER_TMPDIR ] && mkdir $APPTAINER_TMPDIR # creates the tmp folder on vast scratch if it doesn't exist 
[ ! -d $APPTAINER_CACHEDIR ] && mkdir $APPTAINER_CACHEDIR # same as above, except for cached containers

cd /vast/scratch/users/wang.lo/mtSwirl_HPC/MacTel/%s

# module load miniwdl 
module load apptainer/1.3.5
source /vast/scratch/users/wang.lo/mtSwirl_HPC/miniwdl_env/bin/activate
miniwdl run /vast/scratch/users/wang.lo/mtSwirl_HPC/WDL/v2.5_MongoSwirl_Single/fullMitoPipeline_v2_5_Single.wdl --input input.json",
    sample, sample, sample)
  
  # Write the content to the shell file
  writeLines(script_content, paste0(sample,"/script.sh"))
  
  #cat(paste0("bash /vast/scratch/users/wang.lo/mtSwirl_HPC/MacTel/",sample,"/script.sh &\n"), file = "run.sh", append = T)
  cat(paste0("sbatch /vast/scratch/users/wang.lo/mtSwirl_HPC/MacTel/",sample,"/script.sh\n"), file = "run.sh", append = T)
  
}

