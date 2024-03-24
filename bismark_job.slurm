#!/bin/bash

#SBATCH --job-name=bismark_job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16GB
#SBATCH --time=3-00:00:00
#SBATCH --output=~/papanu/BMoutput/bismark_job_%j.out
#SBATCH --error=~/papanu/BMoutput/bismark_job_%j.err

bismark --genome ~/papanu/refgenome --bowtie2 ~/papanu/NuGENoutput/*_trimmed.fq_trimmed.fq.gz


