#! /bin/bash
#SBATCH --mem=15G
#SBATCH -o ../out/%A.%x.%a.out # STDOUT
#SBATCH -e ../err/%A.%x.%a.err # STDERR
#SBATCH --array=1
#SBATCH --partition=carter-compute

date

##################
# DO ASSOCIATION #
##################

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/projects/germline-immune/data/plink-associations/phenotypes/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune/data/plink-associations/cov/immune.filt.cov
OUT=/cellar/users/mpagadal/projects/germline-immune/data/conditional-hla/hla_ref_drb5
KEEP=/cellar/users/mpagadal/projects/germline-immune/scripts/gcta/keep_hla_drb1_15_15.txt
cd $OUT

phenos=(HLA.DRB5 HLA.F MICB HLA.DQA2 HLA.C HLA.DQB1 HLA.DQA1 HLA.A HLA.G BTN3A2 HLA.DRB1 HLA.DQB2 HLA.B PSMB9 MICA TAP2 HLA.H)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

ind=0

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --chr 6 --keep $KEEP --glm firth-fallback sex cols=+err --out $pheno.$ind

awk '{ if ($7 == "ADD") { print $0} }' $pheno.$ind.$pheno.glm.linear > $pheno.$ind.GWAS.ADD

touch $pheno.extract #set up extract file
touch $pheno.assoc #set up association file

iter=0 #will change to 1 

while [ $iter -eq 0 ]

do

python -u /cellar/users/mpagadal/projects/germline-immune/scripts/gwas/get-highest-peak.py --assoc_file $pheno.$ind.GWAS.ADD --pheno $pheno

plink --bfile $GENO --extract $pheno.extract --recode A --out $pheno.add

python -u /cellar/users/mpagadal/projects/germline-immune/scripts/gwas/combine-raw.py --cov $COVAR --add_cov $pheno.add.raw --pheno $pheno

lst=$(paste -sd, $pheno.extract)

ind=$((ind+1))

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --keep $KEEP --pheno-name $pheno --covar $pheno.compiled.cov --covar-name C1-C10,age,$lst --covar-variance-standardize --glm firth-fallback sex cols=+err --chr 6 --out $pheno.$ind


awk '{ if ($7 == "ADD") { print $0} }' $pheno.$ind.$pheno.glm.linear > $pheno.$ind.GWAS.ADD

iter=$(paste -sd, $pheno.done.txt)

done


date
