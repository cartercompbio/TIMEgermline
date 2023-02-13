#! /bin/bash
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --mem-per-cpu=15G
#SBATCH -c 8
#SBATCH --partition=carter-compute
#SBATCH --time=14-00:00:00
#SBATCH --array=1-2%2

date
hostname

phenos=(/cellar/users/mpagadal/data/ukbb/plato_input/immune_cancer_lev1_pheno.txt /cellar/users/mpagadal/data/ukbb/plato_input/immune_cancer_lev2.txt)
names=(/cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time/results/plato_lev1_results /cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time/results/plato_lev2_results)

PHENO=${phenos[$SLURM_ARRAY_TASK_ID-1]}
NAME=${names[$SLURM_ARRAY_TASK_ID-1]}

GENO=/cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time/dosage/UKBB_TIME_subset

COV1=AGE,SEX,PC1,PC2
COV2=PC3,PC4,PC5,PC6
COV3=PC7,PC8
COV4=PC9,PC10

plato --logfile $NAME.log load-data --bfile $GENO load-trait --file $PHENO regress-auto --odds-ratio --phewas --covariates $COV1 --covariates $COV2 --covariates $COV3 --covariates $COV4 --threads 4 --correction Bonferroni,FDR --output $NAME.txt  

date