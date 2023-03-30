#! /bin/bash
#SBATCH --mem=10G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --partition=carter-compute

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME

date

# Covariate C1-10, Age, Sex

GENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/imputedv2_all/imputed
PHENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/phenos/total.pheno.responder.v2.txt
COVAR=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/covar/total.cov.age.sex.study.dummy.v2.txt
OUT=/cellar/users/mpagadal/projects/germline-immune/data/icb-response/prsice-associations
EXTRACT=/cellar/users/mpagadal/projects/germline-immune/snp-tables/extract-all-time-variants-proxy.txt
KEEP=/cellar/users/mpagadal/immunotherapy-trials/patients/melanoma.no.crist.liu.txt
pheno=response_crist_sd

cd $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name Age,Gender,C1-C10,vanallen,snyder,hugo --keep $KEEP --extract $EXTRACT --covar-variance-standardize --glm firth-fallback cols=+err --out $pheno.prsice

#get only ADD rows
head -1 $pheno.prsice.$pheno.glm.logistic.hybrid > $pheno.prsice.assoc
awk '{ if ($8 == "ADD") { print $0} }' $pheno.prsice.$pheno.glm.logistic.hybrid >> $pheno.prsice.assoc

date
