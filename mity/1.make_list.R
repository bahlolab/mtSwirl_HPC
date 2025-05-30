# Clear workspace
rm(list = ls())

# Set working directory
setwd("/vast/scratch/users/wang.lo/1000G/")

# Define directory containing CRAM files
dir <- "./data/WGS/"

# List all CRAM files in the directory
#files <- list.files(path = dir, pattern = "\\.bam$")
files <- list.files(path = dir, pattern = "\\.cram$")

# Prepend '/data/' to each file name
list <- paste0("/data/",files)

# Create output directory if it doesn't exist
if(!dir.exists("./mity")) dir.create("mity")

# Write the list of file paths to a text file
write.table(list, "./mity/1000G.txt", row.names = F, col.names = F, quote = F)
