# mity

Describe how to install and use [mity](https://github.com/KCCG/mity). 

## Citation and data

This pipeline was released in this [manuscript](https://www.fortunejournals.com/articles/mity-a-highly-sensitive-mitochondrial-variant-analysis-pipeline-for-whole-genome-sequencing-data.html). If you use it in your work, please cite as:

```
Clare Puttick, Ryan L Davis, Kishore R Kumar, Julian MW Quinn, Trent Zeng, Christian Fares, Mark Pinese, David M Thomas, Marcel E Dinger, Carolyn M Sue, Mark J Cowley. mity: A Highly Sensitive Mitochondrial Variant Analysis Pipeline for Whole Genome Sequencing Data. Journal of Bioinformatics and Systems Biology. 7 (2024): 05-16.
```

## Installation and Usage

* Installation: [install_mity.sh](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/install_mity.sh)
  
* Run Instructions:
* 
  * Single sample: [run_single_sample.sh](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/run_single_sample.sh)
    
  * Multiple samples:
    
    1 - make a list of BAM/CRAM files, [1.make_list.R](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/1.make_list.R)
    
    2 - sbatch [2.run_multi_sample.sh](https://github.com/bahlolab/mtSwirl_HPC/blob/main/mity/2.run_multi_sample.sh)


