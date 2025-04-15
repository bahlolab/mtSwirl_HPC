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

* Create an input JSON file for each sample: [example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/multisample/1_generate_input.R)

* Generate a script file for each sample: [example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/multisample/2_generate_script.R)

* Re-run any failed jobs as needed: [example](https://github.com/bahlolab/mtSwirl_HPC/blob/main/example/multisample/3_rerun.R)

## FAQ
