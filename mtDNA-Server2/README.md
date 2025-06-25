# Running mtDNA-Server 2 Nextflow

## Set up your working directory

```bash
cd /vast/scratch/users/$USER

# Create a folder for this run
mkdir mtdna-server-2
cd mtdna-server-2
```

## Download a test BAM file

```bash
wget https://github.com/genepi/mtdna-server-2/raw/refs/heads/main/tests/data/bam/mitohpc/sample_S.bam
```

## Create the configuration file
Create a file named `mtdna-server-2.config` with the following content:

```
params {
    project         = "test-job"
    files           = "*.bam"
    output          = "results/"
    detection_limit = 0.02    
    mode            = "fusion"
    coverage_estimation    = "on"
    subsampling            = "off"
}

singularity {
    singularity.enabled               = true
    singularity.autoMounts            = true
    docker.enabled                    = false
    singularity.runOptions = '-B /vast -B /stornext'
}

process {
  withName: 'MTDNA_SERVER_2:COVERAGE_ESTIMATION' {
    memory = '12 GB'   // increase to 12 GB or 16 GB if needed
    cpus = 1
  }
}

```
💡 You may also modify the default config at
/home/users/allstaff/$USER/.nextflow/assets/genepi/mtdna-server-2/nextflow.config
(not recommended — use local override files where possible)

## Run the pipeline
Load required modules:
```bash
module load nextflow
module load apptainer
```

Set up Apptainer cache (to avoid home quota issues):
```bash
mkdir -p /vast/scratch/users/$USER/apptainer_cache
export APPTAINER_CACHEDIR=/vast/scratch/users/$USER/apptainer_cache
```

Run the pipeline:
```bash
cd /vast/scratch/users/$USER/mtdna-server-2

nextflow run genepi/mtdna-server-2 -r v2.1.16 \
  -c mtdna-server-2.config \
  -profile singularity

```

Resume the pipeline:
```bash
cd /vast/scratch/users/$USER/mtdna-server-2

nextflow run genepi/mtdna-server-2 -r v2.1.16 \
  -c mtdna-server-2.config \
  -profile singularity \
  -resume

```
