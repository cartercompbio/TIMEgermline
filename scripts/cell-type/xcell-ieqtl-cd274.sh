#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1
#SBATCH --partition=carter-compute

# Author: Meghana Pagadala
# Date: 08/31/2020
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

phenos=(CD274)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/projects/germline-immune2/data/plink-associations/io_phenotypes/pancanatlas/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cov/immune.xcell.cov
EXTRACT=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-pdl1-snps.txt
OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell-cd274/cell
KEEP=/cellar/users/mpagadal/data/tcga/phenotypes/cancer-ids/LUAD

mkdir $OUT

for cell in aDC Adipocytes Astrocytes B.cells Basophils CD4..memory.T.cells CD4..naive.T.cells CD4..T.cells CD4..Tcm CD4..Tem CD8..naive.T.cells CD8..T.cells CD8..Tcm CD8..Tem cDC Chondrocytes Class.switched.memory.B.cells CLP CMP DC Endothelial.cells Eosinophils Epithelial.cells Erythrocytes Fibroblasts GMP Hepatocytes HSC iDC Keratinocytes ly.Endothelial.cells Macrophages Macrophages.M1 Macrophages.M2 Mast.cells Megakaryocytes Melanocytes Memory.B.cells MEP Mesangial.cells Monocytes MPP MSC mv.Endothelial.cells Myocytes naive.B.cells Neurons Neutrophils NK.cells NKT Osteoblast pDC Pericytes Plasma.cells Platelets Preadipocytes pro.B.cells Sebocytes Skeletal.muscle Smooth.muscle Tgd.cells Th1.cells Th2.cells Tregs


do

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age,$cell --keep $KEEP --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-13,25,27 --out $OUT/$pheno\_$cell

done

OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell-cd274/sex
mkdir $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age --keep $KEEP --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-12,24,25 --out $OUT/$pheno\_sex

OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell-cd274/age
mkdir $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age --keep $KEEP --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-12,23,25 --out $OUT/$pheno\_age


date
