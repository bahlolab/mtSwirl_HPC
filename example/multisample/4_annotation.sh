
# pipeline installation
cd /vast/scratch/users/$USER

# Clone this repository
git clone git@github.com:bahlolab/mtDNA_annotation.git

cd mtDNA_annotation

# Install dependencies in an isolated Python environment
python -m venv venv
source venv/bin/activate
python -m pip install -r requirements.txt

# generagte input files
# 4.1_make_input.R

# Step 1: merge base coverage
mkdir /vast/scratch/users/$USER/mtDNA_annotation/1_annotate_coverage/output
mkdir /vast/scratch/users/$USER/mtDNA_annotation/1_annotate_coverage/temp

python /vast/scratch/users/$USER/mtDNA_annotation/scripts/annotate_coverage.py \
  --input-tsv /vast/scratch/users/$USER/mtDNA_annotation/1_annotate_coverage/input/input_files.tsv \
  --output-ht /vast/scratch/users/$USER/mtDNA_annotation/1_annotate_coverage/output/coverage_annotated.ht \
  --temp-dir /vast/scratch/users/$USER/mtDNA_annotation/1_annotate_coverage/temp \
  --chunk-size 100 \
  --overwrite

# Step 2: combine VCF
mkdir /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/output
mkdir /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/temp

source /vast/scratch/users/$USER/mtDNA_annotation/venv/bin/activate

python /vast/scratch/users/$USER/mtDNA_annotation/scripts/combine_vcfs.py \
  --participant-data /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/input/participant_vcf_paths.tsv \
  --coverage-mt-path /vast/scratch/users/$USER/mtDNA_annotation/1_annotate_coverage/output/coverage_annotated.mt \
  --vcf-col-name vcf_path_column \
  --artifact-prone-sites-path /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/input/artifact_prone_sites.bed \
  --output-bucket /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/output/ \
  --temp-dir /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/temp/ \
  --file-name vcf_combined \
  --overwrite

# Step 3: add annotation
mkdir /vast/scratch/users/$USER/mtDNA_annotation/3_add_annotations/output

export TMPDIR=/vast/scratch/users/$USER/tmp
mkdir $TMPDIR

### VEP
export VEP_CONFIG_URI=file:///vast/scratch/users/$USER/mtDNA_annotation/vep-files/vep101-GRCh38.json
module load apptainer
source /vast/scratch/users/$USER/mtDNA_annotation/venv/bin/activate

python /vast/scratch/users/$USER/mtDNA_annotation/scripts/add_annotations.py \
--mt-path /vast/scratch/users/$USER/mtDNA_annotation/2_combine_vcfs/output/vcf_combined.mt \
--output-dir /vast/scratch/users/$USER/mtDNA_annotation/3_add_annotations/output \
--participant-data /vast/scratch/users/$USER/mtDNA_annotation/3_add_annotations/input/participant_data.tsv \
--vep-results /vast/scratch/users/$USER/mtDNA_annotation/3_add_annotations/output/vep_results.mt \
--min-hom-threshold 0.95 \
--min-het-threshold 0.03 \
--vaf-filter-threshold 0.01 \
--keep-all-samples \
--run-vep \
--overwrite
