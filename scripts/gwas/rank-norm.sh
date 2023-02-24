#! /bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-30%30
#SBATCH --partition=carter-compute

# Author: Meghana Pagadala
# Date: 10/23/2020
#
# Inputs:
# out: directory with unnormalized phenotypes
#
# Outputs:
# inverse-rank normalized phenotypes
#

cancers=(STAD HNSC LIHC COAD LUSC LUAD KIRC KIRP LGG THCA PAAD CHOL BLCA SARC PRAD GBM PCPG BRCA SKCM OV TGCT READ UCEC MESO KICH CESC ACC UCS ESCA UVM)
cancer=${cancers[$SLURM_ARRAY_TASK_ID-1]}

date

out=$1
cd $out

Rscript /cellar/users/mpagadal/scripts/run-rank-norm.R pheno_$cancer.unnorm.csv pheno_$cancer.rank.csv


date

