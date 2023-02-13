#! /bin/bash
#SBATCH --mem=15G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --partition=carter-compute


date

#extract snps from old, new tcga

for chr in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22

do 

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/immunotherapy-trials/chr$chr
extract=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt
NEW_TCGA=/cellar/users/mpagadal/projects/germline-immune3/data/icb-geno-qc/mismatch/new_tcga/

mkdir -p $OUT

plink --bfile $GENO --extract $extract --out $NEW_TCGA/chr$chr --recode A

done

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
OLD_TCGA=/cellar/users/mpagadal/projects/germline-immune3/data/icb-geno-qc/mismatch/old_tcga/

mkdir -p $OUT

plink --bfile $GENO --extract $extract --out $OLD_TCGA/tcga --recode A

#calculate mismatch frequency

python extract-high-mismatch-snps.py --new_tcga $NEW_TCGA --old_tcga $OLD_TCGA --out /cellar/users/mpagadal/projects/germline-immune3/data/icb-geno-qc/mismatch/tcga.mismatch.csv

date