#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-5%5
#SBATCH --partition=carter-compute


# Author: Meghana Pagadala
# Date: 08/31/2020
#
# Description:
# The following is a script using PLINK to run PLINK glm method on IP components identified 
#
#
# Inputs:
# pheno: phenotype to run association on
# PHENO: phenotype file with column of phenotype values
# GENO: genotype file
# COVAR: covariate file
# OUT: output directory
#
# Outputs:
# $pheno: plink association file 
#

phenos=(TIGIT CTLA4 LAG3 APOE PDCD1)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date


###########################
##### RUNNING PLINK #######
###########################

#PANCAN Atlas Associations

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/projects/germline-immune/data/plink-associations/io_phenotypes/pancanatlas/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune/data/plink-associations/cov/immune.filt.cov
ASSOC=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/io_associations

cd $ASSOC

# /cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm firth-fallback sex cols=+err --out $ASSOC/$pheno

# ######################
# ##### CLUMPING #######
# ######################

# #get only ADD rows
# head -1 $ASSOC/$pheno.$pheno.glm.linear > $pheno.assoc
# awk '{ if ($7 == "ADD") { print $0} }' $ASSOC/$pheno.$pheno.glm.linear >> $pheno.assoc

# #replace ID column name with SNP for clumping method
# sed -i -e '1s/ID/SNP/' $pheno.assoc

# plink --bfile $GENO --clump $pheno.assoc --clump-p1 .000000070922 --clump-p2 0.00001 --clump-r2 0.50 --clump-kb 500 --out $pheno.clump

########################################
##### run cancer type #######
########################################

for canc in ACC BLCA BRCA CESC CHOL COAD ESCA GBM HNSC KICH KIRC KIRP LGG LIHC LUAD LUSC MESO OV PAAD PCPG PRAD READ SARC SKCM STAD TGCT THCA UCEC UCS UVM

do

keep=/cellar/users/mpagadal/data/tcga/phenotypes/cancer-ids/$canc
extract=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --keep $keep --extract $extract --glm firth-fallback sex cols=+err --out $ASSOC/$pheno\_$canc

done

date
