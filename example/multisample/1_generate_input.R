rm(list = ls())
setwd("/vast/scratch/users/wang.lo/mtSwirl_HPC/MacTel/")

# Load necessary library
library(jsonlite)
# Read the JSON file
data <- fromJSON("input_noalt.json")

# Define the directory containing the files
MacTel_WGS <- "/stornext/Bioinf/data/lab_bahlo/projects/mactel/MacTel_WGS_2023/bams"
bam <- list.files(path = MacTel_WGS, pattern = "\\.bam$", full.names = TRUE)
bai <- list.files(path = MacTel_WGS, pattern = "\\.bai$", full.names = TRUE)
bam_names <- list.files(path = MacTel_WGS, pattern = "\\.bam$")
sample <- sub("\\.merged\\.bam$", "", bam_names)
input <- data.frame(sample, bam, bai)
write.table(input, "input_list.txt", row.names = F, quote = F, sep = "\t")

for(i in 1:nrow(input)){
    # Check if the folder exists and create it if it does not
  if (!dir.exists(input$sample[i])) dir.create(input$sample[i])
  
  dat1 <- data
  # Replace values as needed
  dat1$MitochondriaPipeline.sample_name <- input$sample[i]
  dat1$MitochondriaPipeline.wgs_aligned_input_bam_or_cram <- input$bam[i]
  dat1$MitochondriaPipeline.wgs_aligned_input_bam_or_cram_index <- input$bai[i]
  # Convert the modified list back to JSON
  new_json_data <- toJSON(dat1, pretty = TRUE, auto_unbox = TRUE)
  
  # Write the new JSON back to file or print it
  write(new_json_data, file = paste0(input$sample[i],"/input.json"))
}


