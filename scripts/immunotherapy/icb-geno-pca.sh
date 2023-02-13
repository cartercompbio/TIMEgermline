#! /bin/bash
#SBATCH --mem=15G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --partition=carter-compute


date

GENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/imputedv2_all/imputed
extract=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants.txt
OUT=/cellar/users/mpagadal/projects/germline-immune3/data/icb-geno-qc/pca

cd $OUT

#full pca

plink --bfile $GENO --extract $extract --make-bed --out time

~/Programs/flashpca_x86-64 --bfile icb.time -d 10

#icb pca

extract=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract.icb.sd.fdr.5.txt

plink --bfile $GENO --extract $extract --make-bed --out icb.time

~/Programs/flashpca_x86-64 --bfile icb.time -d 10

date