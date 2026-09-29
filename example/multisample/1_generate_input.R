rm(list = ls())
setwd("/path/to/mtSwirl_HPC/folder/")

# Load necessary library
library(jsonlite)
# Read the JSON file
data <- fromJSON("input_noalt.json")

# Define the directory containing the files
WGS <- "/path/to/bams"
bam <- list.files(path = WGS, pattern = "\\.bam$", full.names = TRUE)
bai <- list.files(path = WGS, pattern = "\\.bai$", full.names = TRUE)
bam_names <- list.files(path = WGS, pattern = "\\.bam$")
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


