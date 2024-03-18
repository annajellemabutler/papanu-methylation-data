## Baboon DNA methylation changes with age
##### Winter 2024 Rotation Project: Soojin Yi Lab

Pipeline for the recreation of the results of a [chapter of Hyeonsoo Jeong's thesis](https://docs.google.com/document/d/1TZFuVnaIoU6e3bUsUtpBu0H6r37STyjj/edit), including: (1) DNA methylation data analysis from anubis baboons, (2) development of an aging CpG clock, and (3) further exploratory analysis relating to the relationship between epigenetic aging and early life rearing experience. 

The document is written from the perspective of someone with no experience working on an HPC and, therefore, may include extraneous details. 

## Steps 
0. Preparations
1. Quality control with Trim Galore
2. Bismark read alignment and methylation calling
3. De-duplication
4. Methylation extraction

## 0. Preparations
- Log in to the cluster using ssh
- Downloaded miniconda to my home directory using [this](https://github.com/um-dang/conda_on_the_cluster?tab=readme-ov-file) tutorial 
- Created a custom conda environment specification for the project (saved as environment.yml)
- Create the environment using `conda env create --file environment.yml` (this downloads and installs the packages)
- Activate the environment using `source activate dnamanubis`
- Install the relevant packages
  -   `conda install trim-galore`

## 1. Quality control with Trim Galore
Trim Galore v.0.4.1 was used for read trimming. Additional NuGEN adaptor sequences (from the use of the NuGEN library preparation kit) were removed using the [NuGEN python script](https://github.com/nugentechnologies/NuMetRRBS). 

A bash script automates this process:

`#!/bin/bash

#SBATCH 
#SBATCH things

module load tools/trimgalore

#Start trim galore
trim_galore [options] <filename(s)>`

In the job's directory, run the sbatch command to submit the job: `sbatch ./trimgalore-test.sh`

## 2. Mapping with Bismark 
Bismark v 0.14. was used to align sequencing reads to the baboon papAnu4 reference genome and perform methylation calling. There are two main steps to running Bismark: (a) genome preparation and (b) read alignment. 

### (a) Genome preparation 
`bismark_genome_preparation --verbose <path to papAnu4 ref genome`. Bismark creates two folders (C->T and G->A converted genomes) within this directory. These will be indexed in parallel using bowtie2. 

### (b) Run Bismark with Bowtie2
`bismark --genome <path_to_prepared_genome_folder --bowtie2 sequence_file.trim.gz`. For each sequence file, Bismark produces one alignment and methylation call output file. 

## 3. De-duplication
De-duplication was performed to remove PCR duplicates. The script works by checking whether the start and end co-ordinate of the mapped read coincides with any other read. If it does, it gets discarded. 

`~/tools/bismark_v0.17.0/deduplicate_bismark --bam -p blah_R1.trim_bismark_bt2_pe.bam`

## 4. Methylation extraction
This is an optional step. The number of methylated and unmethylated reads on a per-position basis can be called using `~/tools/bismark_v0.17.0/bismark_methylation_extractor -p --bedGraph --counts --scaffolds --multicore 8 blah_R1.trim_bismark_bt2_pe.deduplicated.bam`.

3. Exploratory analysis 

(A) Elastic net regression 
- Removed CpGs with a mean methylation level < 0.1 or > 0.9 and with a coverage < 5 and with missing data
- The DNA methylation clock was built using elastic net regression, using the R package glmnet. 
- The optimal regularization parameter, lambda, was determined by 10-fold cross-validation on the data using cv.glmnet. 
- Estimated the DNA methylation age of each individual using the leave-one-out cross-validation approach

(B) Functional enrichment
- Looked at the genomic distribution of the clock CpG sites
- Occurences of CpGs for each genomic feature were compared with those in random control sets (G+C content-matched)
- Genomic co-ordinates of functional genomic regions were downloaded from UCSC Genome Browser. 

(C) Identification of differentially-methylated CpGs
- For each site, we fitted a linear model to estimate the interaction effect of age and rearing experience. 
- Generalized linear models were created with the DSS (2.4) Bioconductor package. 
- Sex and bisulfite conversion rates were considered covariates. 
- Conducted a hypothesis test of the interaction effect using Wald test (based on the estimated co-efficient and standard error from the fitted model). Used the Benjamini-Hochberg method for multiple-testing correction. 
