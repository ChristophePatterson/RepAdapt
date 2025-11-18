#!/bin/bash
#SBATCH -J prepare_genome
#SBATCH -o %x.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=0-12:00:00
#SBATCH -D .
#SBATCH --mail-type=ALL
#SBATCH --mail-user=christophe.patterson@nottingham.ac.uk

module load bwa-uoneasy samtools-uoneasy picard-uoneasy

GENOME=$1

cd $(dirname $GENOME)

# bwa index
bwa index $GENOME

# samtools index
samtools faidx $GENOME

# gatk dictionary with picard
java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R=$GENOME O=${GENOME%.*}.dict

