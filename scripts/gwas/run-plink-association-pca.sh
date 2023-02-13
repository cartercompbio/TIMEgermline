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

phenos=(PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 PC13 PC14 PC15 PC16 PC17 PC18 PC19 PC20 PC21 PC22 PC23 PC24 PC25 PC26 PC27 PC28 PC29 PC30)
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
PHENO=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/phenotypes_pca/pheno_pca
COVAR=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cov/immune.filt.cov
ASSOC=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/associations_pca

cd $ASSOC

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm firth-fallback sex cols=+err --out $ASSOC/$pheno

######################
##### CLUMPING #######
######################

#get only ADD rows
head -1 $ASSOC/$pheno.$pheno.glm.linear > $pheno.assoc
awk '{ if ($7 == "ADD") { print $0} }' $ASSOC/$pheno.$pheno.glm.linear >> $pheno.assoc

#replace ID column name with SNP for clumping method
sed -i -e '1s/ID/SNP/' $pheno.assoc

plink --bfile $GENO --clump $pheno.assoc --clump-p1 .000000070922 --clump-p2 0.00001 --clump-r2 0.50 --clump-kb 500 --out $pheno.clump

########################################
##### Extract summary statistics #######
########################################

awk '{print $3}' $pheno.clump.clumped | grep ":" > $pheno.extract

grep -w -F -f $pheno.extract $pheno.assoc > $pheno.time.assoc


######################################
#### Extract significant variants ####
######################################

awk '$12 < .000000070922 { print $0}' $pheno.assoc > $pheno.sig.assoc

awk '$12 < .0001 {print $0}' $pheno.assoc > $pheno.plot.assoc

# # rm $pheno.assoc
# rm $ASSOC/$pheno.$pheno.glm.linear
# rm $ASSOC/$pheno.log

date
