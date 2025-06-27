### Convert CRAM to BAM chrM
rm(list=ls())
setwd("/vast/scratch/users/wang.lo/1000G/")

### download CRAM+CRAI files
work_dir <- "/vast/scratch/users/wang.lo/1000G/"
files <- list.files("/vast/projects/bahlo_mtDNA/1000G/WGS/", pattern = "cram$")
ids <- sub("\\.final\\.cram$", "", files)

# Load template
template <- readLines("/vast/projects/bahlo_mtDNA/Scripts/convert/cram2bam_chrM.sh")

# Output directory for scripts
dir.create("cram2bam_scripts", showWarnings = FALSE)

# Generate bash scripts
for (id in ids) {
  script_content <- gsub("\\{\\{ID\\}\\}", id, template)
  script_file <- file.path("cram2bam_scripts", paste0("cram2bam_", id, ".sh"))
  writeLines(script_content, script_file)
  Sys.chmod(script_file, mode = "0755")  # make it executable
}

# Now generate a run_all_sbatch.sh file to submit all jobs
sbatch_cmds <- paste0("sbatch ", list.files("cram2bam_scripts", full.names = TRUE, pattern = "\\.sh$"))
writeLines(sbatch_cmds, "run_all_sbatch.sh")

# Optionally, you can run it from R (or manually run bash run_all_sbatch.sh)
# system("bash run_all_sbatch.sh")

