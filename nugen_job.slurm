#!/bin/bash
#SBATCH --job-name=nugentrim_job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16GB
#SBATCH --time=3-00:00:00
#SBATCH --mail-user=anna.jellemabutler@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=~/papanu/NuGENoutput/nugentrim_job_%j.out
#SBATCH --error=~/papanu/NuGENoutput/nugentrim_job_%j.err

# Move to the directory containing the input files
cd ~/papanu/TGoutput

# Iterate over each file with the pattern (*trimmed.fq.gz) and execute the Python script
for file in *trimmed.fq.gz; do
    echo "Processing file: $file"
    python2 ~/papanu/scripts/nugen_adaptor.py -1 "$file"
done

