#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-65%40
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

phenos=(AMPD3 RNF41 ENTPD1 PSMD11 IL2RA IFIT1 CPVL GNPTAB CTSS FAM216A CD209 IFI44L DBNDD1 GGH ERAP1 CTSW MARCH1 LNPEP FAM167A FPR1 GSTCD C3AR1 VAMP3 CCBL2 TREX1 ERAP2 FCGR3B GPLD1 DHFR IL18 DCTN5 VAMP8 LYZ FCGR2B OAS1 HLA.H HLA.DQA2 HLA.G HLA.DQA1 MICA MICB HLA.A HLA.DQB2 HLA.B HLA.DQB1 HLA.DRB5 HLA.DRB1 BTN3A2 TAP2 HLA.C CTLA4 iDC Th2_cells Monocytes pDC APOE PDCD1 Sigs160.Wolf_IFN.21978456 Sigs160.Wolf_MHC2.21978456 Sigs160.Bindea_Tfh.cells Sigs160.Wolf_Interferon.Cluster.21214954 Sigs160.Wolf_Module3.IFN.score Sigs160.Bindea_Th17.cells Sigs160.Wolf_Interferon.19272155 Sigs160.Attractors_IFIT3)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/phenotypes/pancanatlas/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cov/immune.xcell.cov
EXTRACT=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-cancer-time-proxy.txt
OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell/cell

mkdir $OUT

for cell in aDC Adipocytes Astrocytes B.cells Basophils CD4..memory.T.cells CD4..naive.T.cells CD4..T.cells CD4..Tcm CD4..Tem CD8..naive.T.cells CD8..T.cells CD8..Tcm CD8..Tem cDC Chondrocytes Class.switched.memory.B.cells CLP CMP DC Endothelial.cells Eosinophils Epithelial.cells Erythrocytes Fibroblasts GMP Hepatocytes HSC iDC Keratinocytes ly.Endothelial.cells Macrophages Macrophages.M1 Macrophages.M2 Mast.cells Megakaryocytes Melanocytes Memory.B.cells MEP Mesangial.cells Monocytes MPP MSC mv.Endothelial.cells Myocytes naive.B.cells Neurons Neutrophils NK.cells NKT Osteoblast pDC Pericytes Plasma.cells Platelets Preadipocytes pro.B.cells Sebocytes Skeletal.muscle Smooth.muscle Tgd.cells Th1.cells Th2.cells Tregs


do

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age,$cell --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-13,25,27 --out $OUT/$pheno\_$cell

done

OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell/sex
mkdir $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-12,24,25 --out $OUT/$pheno\_sex

OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell/age
mkdir $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-12,23,25 --out $OUT/$pheno\_age


date
