#! /bin/bash
#SBATCH --mem=5G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-26%26
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

phenos=(HLA.B.2 HLA.A.2 HLA.DPA1.0 HLA.A.3 HLA.DRB1.1 HLA.DQA1.0 HLA.DPB1.2 HLA.DRB1.0 HLA.A.0 HLA.C.1 HLA.DPA1.1 HLA.A.1 HLA.DQA1.1 HLA.C.0 HLA.DPB1.0 HLA.C.3 HLA.DQB1.0 HLA.B.1 HLA.DQB1.2 HLA.DQA1.2 HLA.C.2 HLA.DQB1.4 HLA.DQB1.3 HLA.B.0 HLA.DQB1.1 HLA.DPB1.1)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date

cd /cellar/users/mpagadal/projects/germline-immune3/data/conditional-hla/ase

awk '$12 < .0001 {print $0}' $pheno.GWAS.ADD > $pheno.plot.assoc


date
