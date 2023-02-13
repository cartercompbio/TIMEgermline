#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-19%19
#SBATCH --partition=carter-compute


# Author: Meghana Pagadala
# Date: 11/21/2021
#
# Description:
# The following is a script using PLINK to run PLINK clumping on Sayaman associations
#
#
# Inputs:
# pheno: phenotype to run association on
# GENO: genotype file
# OUT: output directory
#
# Outputs:
# $pheno: plink association file 
#

phenos=(Sigs160.Bindea_T.helper.cells Sigs160.Wolf_IFN.21978456 Sigs160.Wolf_Interferon.19272155 Sigs160.Attractors_IFIT3 Sigs160.Bindea_CD8.T.cells Sigs160.Wolf_Module3.IFN.score Sigs160.Wolf_Interferon.Cluster.21214954 Sigs160.Senbabaoglu_APM1 Sigs160.Bindea_Tfh.cells Sigs160.Wolf_CD8.CD68.ratio Sigs160.Wolf_MHC2.21978456 Sigs160.Bindea_aDC Sigs160.Bindea_NK.cells Sigs160.Bindea_Cytotoxic.cells Sigs160.Wolf_LYMPHS.PCA.16704732 Core56.Cell.Proportion_Eosinophils_Binary.MedianLowHigh Sigs160.Bindea_Eosinophils Sigs160.Bindea_Tcm.cells Sigs160.Bindea_Th17.cells)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date


####################################
##### RUNNING PLINK CLUMPING #######
####################################

#Sayaman Clumping

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
OUT=/cellar/users/mpagadal/projects/germline-immune3/data/sayaman/supp-associations

cd $OUT

plink --bfile $GENO --clump $pheno.assoc --clump-p1 .000000070922 --clump-p2 0.00001 --clump-r2 0.50 --clump-kb 250 --out $pheno.clump

date
