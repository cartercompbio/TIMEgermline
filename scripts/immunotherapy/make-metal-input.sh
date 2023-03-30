#! /bin/bash
#SBATCH --mem=10G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-9%9
#SBATCH --partition=carter-compute

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME

date

phenos=(hugo miao riaz rizvi snyder vanallen)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

# Covariate C1-10, Age, Sex

GENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/imputedv2_all/imputed
PHENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/phenos/total.pheno.responder.v2.txt
COVAR=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/covar/total.cov.age.sex.study.v2.txt
# EXTRACT=/cellar/users/mpagadal/projects/germline-immune/snp-tables/extract-all-variants.txt
# EXCLUDE=/cellar/users/mpagadal/projects/germline-immune2/data/icb-genotypes/time_snps/high.mismatch.snps.txt
DIR=/cellar/users/mpagadal/projects/germline-immune3/data/icb-response
KEEP=/cellar/users/mpagadal/immunotherapy-trials/patients/$pheno.txt

# FULL SNPs
y=response_crist_sd
OUT=$DIR/$y
mkdir $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $y --covar $COVAR --covar-name Age,Gender,C1-C10 --keep $KEEP --covar-variance-standardize --glm firth-fallback cols=+err --out $OUT/$pheno

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --keep $KEEP --freq --out $OUT/$pheno.freq

head -1 $OUT/$pheno.$y.glm.logistic.hybrid > $OUT/$pheno.assoc.logistic.add
awk '{ if ($8 == "ADD") { print $0} }' $OUT/$pheno.$y.glm.logistic.hybrid >> $OUT/$pheno.assoc.logistic.add


date
