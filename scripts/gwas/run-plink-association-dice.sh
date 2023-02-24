#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-129%10
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

phenos=(HAUS1 AMPD3 OAS3 RNF41 TCEB1 MS4A4A MNDA ENTPD1 SEC22B PSMD11 IL2RA FCGR2A IFIT1 APITD1 CPVL TPRKB GNPTAB CD163 LILRB2 CTSS CAPZB ALOX5AP FAM216A DYNLT1 CD209 SH3BP5L COX17 CD68 IFI44L PLEK DBNDD1 GGH ERAP1 ITGB2 CTSL PSMB7 CTSW RNASE6 HAVCR2 MARCH1 LNPEP FAM167A FPR1 GSTCD SLC25A40 MYO1F TLR2 C3AR1 VAMP3 CD14 DCK CCBL2 TREX1 TNFSF13B GPNMB ERAP2 IL10RA EIF2AK1 MRTO4 KLRD1 EP300 FCGR3B PLOD2 NOTCH2 GPLD1 DHFR SNRPA1 SLC11A1 IL18 DCTN5 VAMP8 LYZ SIGLEC5 FCGR2B OAS1 HLA.H HLA.DRB5 BTN3A2 HLA.B HLA.DRB1 HLA.F MICB PSMB9 HLA.DQB1 HLA.DQB2 HLA.A HLA.DQA1 HLA.DQA2 TAP2 MICA HLA.C HLA.G HLA.DPB1 FGFR4 CTLA4 IRF5 CXCR3/CCR5 NKT Monocytes cDC iDC CD4_Tcm Macrophages Th2_cells Class.switched_memory_B.cells Plasma_cells Eosinophils Th1_cells Memory_B.cells pDC NK_cells DC Th17 Tfh APOE PDCD1 PD.L1 Sigs160.Wolf_IFN.21978456 Sigs160.Wolf_MHC2.21978456 Sigs160.Bindea_Tfh.cells Sigs160.Bindea_aDC Sigs160.Wolf_Interferon.Cluster.21214954 Sigs160.Wolf_Module3.IFN.score Core56.Cell.Proportion_Eosinophils_Binary.MedianLowHigh Sigs160.Wolf_CD8.CD68.ratio Sigs160.Bindea_Cytotoxic.cells Sigs160.Bindea_Th17.cells Sigs160.Wolf_Interferon.19272155 Sigs160.Attractors_IFIT3)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $pheno

date


###########################
##### RUNNING PLINK #######
###########################

# DICE associations

GENO=/cellar/controlled/dbgap-genetic/phs001703_dice/imputed/dice
EXTRACT=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt 
ASSOC=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/dice
COVAR=/cellar/controlled/dbgap-genetic/phs001703_dice/cov/dice.cov

cd $ASSOC

for cell in TREG_NAIVE TH1 CLASSICAL_MONOCYTES CD4_NAIVE CD8_N_STIM TH2 CD4_N_STIM CD8_NAIVE TFH NONCLASSICAL_MONOCYTES TREG_MEMORY TH17 NK_CD16POS TH1_17 B_NAIVE

do

PHENO=/cellar/controlled/dbgap-genetic/phs001703_dice/plink-rna/$cell.pheno

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age,sex --covar-variance-standardize --extract $EXTRACT --glm firth-fallback cols=+err --out $ASSOC/$cell.$pheno

done

date
