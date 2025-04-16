# mtSwirl HPC

We implemented the [mtSwirl](https://github.com/rahulg603/mtSwirl) pipeline, originally designed for the Terra cloud platform, on our local HPC, specifically for internal use in routine whole-genome sequencing (WGS) mtDNA analysis.

Please contact the authors, Longfei Wang wang.lo@wehi.edu.au and Michael Milton milton.m@wehi.edu.au, if you would like to report any issues, feedback or feature requests.

## Citation and data

This pipeline was released as part of the manuscript: `Nuclear genetic control of mitochondrial DNA copy number and heteroplasmy in humans`, which can be found at [Nature](https://www.nature.com/articles/s41586-023-06426-5). If you use these resources in your work, please cite as `Gupta et al. 2023 Nature`:

```
Gupta, R., Kanai, M., Durham, T.J. et al. Nuclear genetic control of mtDNA copy number and heteroplasmy in humans. Nature, in press. https://doi.org/10.1038/s41586-023-06426-5.
```

## Installation

* Clone the repo:
  ```bash
  cd /vast/scratch/users/$USER/
  git clone git@github.com:bahlolab/mtSwirl_HPC.git
  ```

* Install miniWDL in the environment
  ```bash
  cd mtSwirl_HPC
  python -m venv miniwdl_env
  source miniwdl_env/bin/activate
  pip install git+https://github.com/miniwdl-ext/miniwdl-slurm@develop
  ```

* Set your `~/.config/miniwdl.cfg`
  1. Disable `fail_fast` mode, whereby all tasks get cancelled whenever one task fails.
  2. Include `run_options` to aviod SIGBUS error. The miniwdl default options contain options to run as a fake root, which is not available on most clusters.
  3. Set `maxRetries` as 3, which will retry any task up to 3 times.
     
  ```
  [scheduler]
  container_backend=slurm_singularity
  fail_fast = false

  [singularity]
  exe = ["apptainer"]
  run_options = [ "--containall", "--bind",  "/tmp" ]

  [task_runtime]
  defaults = {
    "maxRetries": 3,
    "docker": "ubuntu:20.04"
    }
  ```
## Run Instructions

To run on WEHI Milton HPC:

### Single sample

* Redirecting Apptainer temporary files and cached containers:
  ```bash
  export APPTAINER_TMPDIR=/vast/scratch/users/$USER/tmp 
  export APPTAINER_CACHEDIR=/vast/scratch/users/$USER/scache 
  [ ! -d $APPTAINER_TMPDIR ] && mkdir $APPTAINER_TMPDIR # creates the tmp folder on vast scratch if it doesn't exist 
  [ ! -d $APPTAINER_CACHEDIR ] && mkdir $APPTAINER_CACHEDIR # same as above, except for cached containers
  ```

* Edit the input [config file](https://github.com/bahlolab/mtSwirl_HPC/blob/main/input.json), by updating the first three lines with the sample name, the path to the CRAM/BAM file, and the path to the corresponding CRAI/BAI file. 
  ```bash
  nano input.json
  ```
  If you are using BAM files generated from the in-house GATK pipeline, please use the [input_noalt.json](https://github.com/bahlolab/mtSwirl_HPC/blob/main/input_noalt.json) configuration file.
  ```bash
  nano input_noalt.json
  ```
  
* Run the pipeline:

  ```bash
  # screen
  module load apptainer/1.3.5
  source miniwdl_env/bin/activate
  miniwdl run WDL/v2.5_MongoSwirl_Single/fullMitoPipeline_v2_5_Single.wdl --input input.json
  ```

If the run is successful, the output JSON ([example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/outputs.json)) will be printed to the terminal, listing all output files.

### Multiple samples

It is recommended to submit a maximum of 50 jobs per run due to the per-user CPU limit.

* **STEP 1** - Create an input JSON file for each sample: [example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/multisample/1_generate_input.R)

* **STEP 2** - Generate a script file for each sample: [example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/multisample/2_generate_script.R)

* **STEP 3** - Re-run any failed jobs as needed: [example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/multisample/3_rerun.R)

## FAQ

### Disk quota exceeded

**Error message**: "FATAL: While making image from oci registry: ... write /home/users/allstaff/wang.lo/.apptainer/cache/...: disk quota exceeded"

**Solution**: Delete .apptainer and redirecting Apptainer temporary files and cached containers:
  ```bash
  cd ~/
  rm -r .apptainer

  export APPTAINER_TMPDIR=/vast/scratch/users/$USER/tmp 
  export APPTAINER_CACHEDIR=/vast/scratch/users/$USER/scache 
  [ ! -d $APPTAINER_TMPDIR ] && mkdir $APPTAINER_TMPDIR # creates the tmp folder on vast scratch if it doesn't exist 
  [ ! -d $APPTAINER_CACHEDIR ] && mkdir $APPTAINER_CACHEDIR # same as above, except for cached containers
  ```

### Reference difference

**Error message**: "task SubsetBamToChrM ... failed :: error: "CommandFailed", exit_status: 2"

**Solution**: The in-house GATK pipeline use 'no_alt', which is all hg38 sequences minus those ending in '_alt' as these cause problems for some mappers. If you are using BAM files generated from the in-house GATK pipeline, please use the [input_noalt.json](https://github.com/bahlolab/mtSwirl_HPC/blob/main/input_noalt.json) configuration file, in which the references are

```
"MitochondriaPipeline.ref_dict": "/stornext/Bioinf/data/lab_bahlo/ref_db/human/hg38/GATK/fasta_no_alt/hg38.no_alt.dict",
"MitochondriaPipeline.ref_fasta": "/stornext/Bioinf/data/lab_bahlo/ref_db/human/hg38/GATK/fasta_no_alt/hg38.no_alt.fasta",
"MitochondriaPipeline.ref_fasta_index": "/stornext/Bioinf/data/lab_bahlo/ref_db/human/hg38/GATK/fasta_no_alt/hg38.no_alt.fasta.fai",
"MitochondriaPipeline.mt_interval_list": "/stornext/Bioinf/data/lab_bahlo/ref_db/human/mtDNA/mtSwirl_HPC/chrM.hg38.noalt.interval_list",
"MitochondriaPipeline.nuc_interval_list": "/stornext/Bioinf/data/lab_bahlo/ref_db/human/mtDNA/mtSwirl_HPC/NUMTv3_all385.hg38.noalt.interval_list",
```

### Memory insufficient While submitting slurm jobs

**Error message**: "srun: error: Unable to create step for job 21227175: Memory required by task is not available"

**Solution**: MiniWDL requires that the parent job has sufficient resources to accommodate all child jobs (i.e. set the memory and CPUs to the maximum of all the child jobs). This issue has now been fixed by the maintainer. Please reinstall MiniWDL in your environment.

```bash
cd mtSwirl_HPC
python -m venv miniwdl_env
source miniwdl_env/bin/activate
pip install git+https://github.com/miniwdl-ext/miniwdl-slurm@develop
```
