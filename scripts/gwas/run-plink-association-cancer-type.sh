#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-30%30
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

phenos=(ACC BLCA BRCA CESC CHOL COAD ESCA GBM HNSC KICH KIRC KIRP LGG LIHC LUAD LUSC MESO OV PAAD PCPG PRAD READ SARC SKCM STAD TGCT THCA UCEC UCS UVM)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date


###########################
##### RUNNING PLINK #######
###########################

# Cancer Type associations

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
COVAR=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cov/immune.filt.cov
PHENO=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/phenotypes/pheno.cancer.type.txt
ASSOC=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cancer_associations
EXTRACT=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --extract $EXTRACT --covar-name C1-C10,age --covar-variance-standardize --glm firth-fallback sex cols=+err --out $ASSOC/time.$pheno

EXTRACT=/cellar/users/mpagadal/projects/germline-immune2/snp-tables/extract.sayaman.snps.txt

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --extract $EXTRACT --covar-name C1-C10,age --covar-variance-standardize --glm firth-fallback sex cols=+err --out $ASSOC/sayaman.$pheno

date
