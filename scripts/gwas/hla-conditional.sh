#! /bin/bash
#SBATCH --mem=15G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-17%17

date

##################
# DO ASSOCIATION #
##################

GENO=/nrnb/users/mpagadal/tcga-genotypes/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/Data/projects/germline-immune/discovery/phenotypes/processed_phenos/pancanatlas/tumor/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/Data/plink-associations/covs/immune.filt.cov
OUT=/cellar/users/mpagadal/Data/projects/germline-immune/hla-deep-dive/associations/raw/hla-conditional/pancanatlas

cd $OUT

phenos=(HLA.DRB5 MICB HLA.A HLA.F HLA.DQA1 BTN3A2 HLA.DQB1 HLA.C HLA.DQA2 PSMB9 TAP2 HLA.DRB1 MICA HLA.B HLA.G HLA.H HLA.DQB2)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

ind=0

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm firth-fallback sex cols=+err --out $pheno.$ind

awk '{ if ($7 == "ADD") { print $0} }' $pheno.$ind.$pheno.glm.linear > $pheno.$ind.GWAS.ADD

touch $pheno.extract #set up extract file
touch $pheno.assoc #set up association file

iter=0 #will change to 1 

while [ $iter -eq 0 ]

do

python -u /cellar/users/mpagadal/Data/projects/germline-immune/hla-deep-dive/scripts/get-highest-peak.py --assoc_file $pheno.$ind.GWAS.ADD --pheno $pheno

/cellar/users/mpagadal/Programs/anaconda3/bin/plink --bfile $GENO --extract $pheno.extract --recode A --out $pheno.add

python -u /cellar/users/mpagadal/Data/projects/germline-immune/hla-deep-dive/scripts/combine-raw.py --cov $COVAR --add_cov $pheno.add.raw --pheno $pheno

lst=$(paste -sd, $pheno.extract)

ind=$((ind+1))

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $pheno.compiled.cov --covar-name C1-C10,age,$lst --covar-variance-standardize --glm firth-fallback sex cols=+err --out $pheno.$ind

awk '{ if ($7 == "ADD") { print $0} }' $pheno.$ind.$pheno.glm.linear > $pheno.$ind.GWAS.ADD

iter=$(paste -sd, $pheno.done.txt)

done


date
