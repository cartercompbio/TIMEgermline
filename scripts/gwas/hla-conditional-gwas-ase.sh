#! /bin/bash
#SBATCH --mem=15G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-8%8
#SBATCH --partition=carter-compute

date

##################
# DO ASSOCIATION #
##################

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/hla-ase-phenotype/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cov/immune.filt.cov
OUT=/cellar/users/mpagadal/projects/germline-immune3/data/conditional-hla/hla_ase

cd $OUT

phenos=(HLA.A HLA.B HLA.C HLA.DPA1 HLA.DPB1 HLA.DRB1 HLA.DQA1 HLA.DQB1)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

ind=0


/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --chr 6 --glm firth-fallback sex cols=+err --out $pheno.$ind

awk '{ if ($7 == "ADD") { print $0} }' $pheno.$ind.$pheno.glm.linear > $pheno.$ind.GWAS.ADD

touch $pheno.extract #set up extract file
touch $pheno.assoc #set up association file

iter=0 #will change to 1 

while [ $iter -eq 0 ]

do

python -u /cellar/users/mpagadal/projects/germline-immune3/scripts/get-highest-peak.py --assoc_file $pheno.$ind.GWAS.ADD --pheno $pheno

plink --bfile $GENO --extract $pheno.extract --recode A --out $pheno.add

python -u /cellar/users/mpagadal/projects/germline-immune3/scripts/combine-raw.py --cov $COVAR --add_cov $pheno.add.raw --pheno $pheno

lst=$(paste -sd, $pheno.extract)

ind=$((ind+1))


/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $pheno.compiled.cov --covar-name C1-C10,age,$lst --covar-variance-standardize --glm firth-fallback sex cols=+err --chr 6 --out $pheno.$ind


awk '{ if ($7 == "ADD") { print $0} }' $pheno.$ind.$pheno.glm.linear > $pheno.$ind.GWAS.ADD

iter=$(paste -sd, $pheno.done.txt)

done


date
