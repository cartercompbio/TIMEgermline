#! /bin/bash
#SBATCH --mem=35G
#SBATCH --array=1-154%40
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

phenos=(HAUS1 AMPD3 OAS3 RNF41 MS4A4A MNDA ENTPD1 SEC22B PSMD11 IL2RA FCGR2A IFIT1 APITD1 CPVL TPRKB GNPTAB CD163 LILRB2 CTSS CAPZB ALOX5AP FAM216A DYNLT1 CD209 SH3BP5L COX17 CD68 IFI44L PLEK DBNDD1 GGH ERAP1 ITGB2 CTSL PSMB7 CTSW RNASE6 MARCH1 LNPEP FAM167A FPR1 GSTCD SLC25A40 MYO1F TLR2 C3AR1 VAMP3 CD14 DCK CCBL2 TREX1 TNFSF13B GPNMB ERAP2 IL10RA EIF2AK1 MRTO4 KLRD1 EP300 FCGR3B PLOD2 NOTCH2 GPLD1 DHFR SNRPA1 SLC11A1 IL18 DCTN5 VAMP8 LYZ SIGLEC5 FCGR2B OAS1 HLA.H HLA.DRB5 BTN3A2 HLA.B HLA.DRB1 HLA.F MICB PSMB9 HLA.DQB1 HLA.DQB2 HLA.A HLA.DQA1 HLA.DQA2 TAP2 MICA HLA.C HLA.G HLA.DPB1 FGFR4 CTLA4 IRF5 CXCR3/CCR5 NKT Monocytes cDC iDC CD4_Tcm Macrophages Th2_cells Class.switched_memory_B.cells Plasma_cells Eosinophils Memory_B.cells Th1_cells pDC NK_cells Th17 Tfh APOE PDCD1 PD.L1 Sigs160.Wolf_IFN.21978456 Sigs160.Wolf_MHC2.21978456 Sigs160.Bindea_Tfh.cells Sigs160.Bindea_aDC Sigs160.Wolf_Interferon.Cluster.21214954 Sigs160.Wolf_Module3.IFN.score Core56.Cell.Proportion_Eosinophils_Binary.MedianLowHigh Sigs160.Wolf_CD8.CD68.ratio Sigs160.Bindea_Cytotoxic.cells Sigs160.Bindea_Th17.cells Sigs160.Wolf_Interferon.19272155 Sigs160.Attractors_IFIT3)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date

GENO=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean
PHENO=/cellar/users/mpagadal/projects/germline-immune/data/plink-associations/phenotypes/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune/data/plink-associations/cov/immune.xcell.cov
EXTRACT=/cellar/users/tsears/projects/germline-immune/data/fig3/LASSO_snp_list_fwd_rev.txt
OUT=/cellar/users/tsears/projects/germline-immune/xcell_V2

mkdir $OUT

for cell in aDC Adipocytes Astrocytes B.cells Basophils CD4..memory.T.cells CD4..naive.T.cells CD4..T.cells CD4..Tcm CD4..Tem CD8..naive.T.cells CD8..T.cells CD8..Tcm CD8..Tem cDC Chondrocytes Class.switched.memory.B.cells CLP CMP DC Endothelial.cells Eosinophils Epithelial.cells Erythrocytes Fibroblasts GMP Hepatocytes HSC iDC Keratinocytes ly.Endothelial.cells Macrophages Macrophages.M1 Macrophages.M2 Mast.cells Megakaryocytes Melanocytes Memory.B.cells MEP Mesangial.cells Monocytes MPP MSC mv.Endothelial.cells Myocytes naive.B.cells Neurons Neutrophils NK.cells NKT Osteoblast pDC Pericytes Plasma.cells Platelets Preadipocytes pro.B.cells Sebocytes Skeletal.muscle Smooth.muscle Tgd.cells Th1.cells Th2.cells Tregs
do

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age,$cell --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-13,25,27 --out $OUT/$pheno\_$cell

done

OUT=/cellar/users/tsears/projects/germline-immune/xcell/sex
mkdir -p $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-12,24,25 --out $OUT/$pheno\_sex

OUT=/cellar/users/tsears/projects/germline-immune/xcell/age
mkdir -p $OUT

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm interaction firth-fallback sex cols=+err --parameters 1-12,23,25 --out $OUT/$pheno\_age


date
