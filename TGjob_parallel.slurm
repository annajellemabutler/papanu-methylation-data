#!/bin/bash

#SBATCH --job-name=trimgalore_job
#SBATCH --output=/home/annajellema/papanu/TGoutput/trimgalore_job_%j.out
#SBATCH --error=/home/annajellema/papanu/TGoutput/trimgalore_job_%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --mail-user=jellema-butler@ucsb.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Specify output directory
output_dir="/home/annajellema/papanu/TGoutput"

# Run Trim Galore in parallel
ls *.fastq.gz | parallel -j+0 trim_galore --output_dir "$output_dir" {}

