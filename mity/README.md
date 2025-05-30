# mity

Describe how to install and use [mity](https://github.com/KCCG/mity). 

## Installation
```bash
module load apptainer
apptainer pull docker://drmjc/mity
```

## Run
```bash
data_dir=/vast/scratch/users/wang.lo/1000G/data/WGS
apptainer exec --bind $data_dir:/data mity_latest.sif bash

# mity call and normalise
mkdir mity # make output directory
mity call --reference hg38 --prefix HG00446 --output-dir mity --normalise /data/HG00446.final.cram

# mity report
cd mity
mity report --prefix HG00446 --min_vaf 0.01 --contig chrM HG00446.normalise.vcf.gz
```

## Scripts

* Installation: [install_mity.sh](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/install_mity.sh)
  
* Run Instructions:
  
  * Single sample: [run_single_sample.sh](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/run_single_sample.sh)
    
  * Multiple samples:
    
    1 - make a list of BAM/CRAM files, [1.make_list.R](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/1.make_list.R)
    
    2 - sbatch [2.run_multi_sample.sh](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/2.run_multi_sample.sh)


## Citation

This pipeline was released in this [manuscript](https://www.fortunejournals.com/articles/mity-a-highly-sensitive-mitochondrial-variant-analysis-pipeline-for-whole-genome-sequencing-data.html). If you use it in your work, please cite as:

```
Clare Puttick, Ryan L Davis, Kishore R Kumar, Julian MW Quinn, Trent Zeng, Christian Fares, Mark Pinese, David M Thomas, Marcel E Dinger, Carolyn M Sue, Mark J Cowley. mity: A Highly Sensitive Mitochondrial Variant Analysis Pipeline for Whole Genome Sequencing Data. Journal of Bioinformatics and Systems Biology. 7 (2024): 05-16.
```
