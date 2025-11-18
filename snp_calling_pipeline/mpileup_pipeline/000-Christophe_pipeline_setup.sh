
MAIN=/gpfs01/home/mbzcp2/code/Github/RepAdapt/data
# Name of directory where snp calling is happening
DATASET=stickleback
SPECIES_DIR=$MAIN/$DATASET
# Create main species directory if it does not exist
mkdir -p $SPECIES_DIR
# Change to species directory
cd $SPECIES_DIR

# Create all needed subfolders
mkdir 00_archive  01_scripts  02_info_files  03_genome  04_raw_data  05_trimmed_data  06_bam_files  07_raw_VCFs  08_filtered_VCFs  09_final_vcf  98_log_files  99_metrics  99_metrics_merged

# Sample meta data in person format
BIGDATA=/gpfs01/home/mbzcp2/code/Github/stickleback-Uist-species-pairs/bigdata_Christophe_header_2025-04-28.csv

# Draft genome
dgname=GAculeatus_UGA_version5_genomic_chromosomes.fna
dgpath=/gpfs01/home/mbzcp2/data/sticklebacks/genomes/$dgname

# Create symlink to genome in 03_genome folder
ln -s $dfpath $SPECIES_DIR/03_genome/$dgname
sbatch /gpfs01/home/mbzcp2/code/Github/RepAdapt/snp_calling_pipeline/mpileup_pipeline/prepare_genome.sh $SPECIES_DIR/03_genome/$dgname

## Create datatable file
echo -e '#SRA\t\t\tploidy\tR1_file\tR2_file\t\t\t\tRG\t\tinstrument\t\tindividual\tr1_ftp\tr2_ftp\tr1_md5' > $SPECIES_DIR/02_info_files/datatable.txt
awk 'NR>1 {print $0}' $BIGDATA | tr ',' '\t' | awk -F '\t' -v dgvar="$dgname" 'BEGIN {OFS = "\t"} {print "NA","","","2", $2, $3,"","","",dgvar,"",$1,"","",""}' >> $SPECIES_DIR/02_info_files/datatable.txt

## Location of raw data
RAWDATA_DIR=/gpfs01/home/mbzcp2/data/sticklebacks/seq/seq_data

# Change to raw data directory
cd $SPECIES_DIR/04_raw_data

# Create symlinks to raw data files
tail -n +2 "$SPECIES_DIR/02_info_files/datatable.txt" | while IFS=$'\t' read -r SRA ploidy R1_file R2_file RG instrument individual r1_ftp r2_ftp r1_md5; do
    #echo "$R1_file"
    #echo "$R2_file"
    ln -s "$RAWDATA_DIR/$R1_file" .
    ln -s "$RAWDATA_DIR/$R2_file" .
done

# Return to species directory
cd $SPECIES_DIR
