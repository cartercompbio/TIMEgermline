#! /bin/bash
#SBATCH --mem=40G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-23%23
#SBATCH --partition=carter-compute


#############################

# Name: pre-dataloader.sh
# Description: used to extract snps from imputed snp data as input into dataloader.py
# Date: 06/07/2021

#############################


date

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X)
chrom=${chroms[$SLURM_ARRAY_TASK_ID-1]}


# # ELLIPSE

geno=/cellar/controlled/dbgap-genetic/phs001120.v1.p1_ellipse/genotypes/all/imputed/all_chrom_files/chr$chrom.nodups.maf
extract=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt
out=/cellar/users/mpagadal/projects/germline-immune3/data/genotypes/ellipse

# plink --bfile $geno --extract $extract --make-bed --out $out/chr$chrom

# # DRIVE

# geno=/cellar/controlled/dbgap-genetic/phs001265_DRIVE/imputed/chr$chrom
# out=/cellar/users/mpagadal/projects/germline-immune3/data/genotypes/drive

# plink --bfile $geno --extract $extract --recode A --out $out/chr$chrom

# GENEVA

geno=/cellar/controlled/dbgap-genetic/phs000187v1_geneva_melanoma/imputed/chr$chrom
out=/cellar/users/mpagadal/projects/germline-immune3/data/genotypes/geneva_melanoma

plink --bfile $geno --extract $extract --make-bed --out $out/chr$chrom


date
