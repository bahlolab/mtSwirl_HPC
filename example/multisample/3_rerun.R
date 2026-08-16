### re-run failed the jobs

rm(list = ls())
setwd("/path/to/mtSwirl_HPC/folder/")
library(jsonlite)

dir_path <- "/path/to/mtSwirl_HPC/folder/"

# List all files with a .out extension in the specified directory and its sub-directories
files <- list.files(path = dir_path, pattern = "\\.out$",)
file_details <- file.info(files)
files_over_1kb <- rownames(file_details[file_details$size > 1024, ])
sample.done <- gsub("\\.out$", "", files_over_1kb)
sample.all <- gsub("\\.out$", "", files)
sample.fail <- sample.all[!(sample.all %in% sample.done)]

input <- read.table("input_list.txt", header = T, sep = "\t")
input <- input[input$sample %in% sample.fail,]

writeLines("cd /path/to/mtSwirl_HPC/folder\n", "run.sh")

for(i in 1:nrow(input)){
  # Define the sample value
  sample <- input$sample[i]
  cat(paste0("sbatch /path/to/mtSwirl_HPC/folder/",sample,"/script.sh\n"), file = "run.sh", append = T)
  
}

