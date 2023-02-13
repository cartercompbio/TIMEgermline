#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-5%5
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

# phenos=(CD84 IL10RA CD209 CD86 MARCH1 IFIT1 OAS3 NCF1 RAB35 LYZ ITGAV SLAMF7 PSMD12 FPR1 BSG RNASE6 IL2RA PIK3CG VAMP8 CSF1R CTSW IL21R LSM3 SNRPA FYB OAS1 CYBB COL8A1 OAS2 CD14 CD80 TNFRSF14 IL7R FCGR2B DHFR DCK DYNLT1 BCCIP SIGLEC5 COX17 BCAP31 NCF2 SKIL EP300 PLOD2 CSF3R PSMC1 CBX1 ICAM1 PA2G4 IL10 MS4A4A SH3BP5L EVI2B IGF2R CAPZB FCGR3B SNRPD1 TRAF6 VSIG4 ALOX5AP CTNNB1 IDE SAMHD1 DCTN5 LILRB2 TLR2 MNDA CD68 ISG15 IL1B AMPD3 HCK ENTPD1 TAB1 STAT1 NPL MYO1F ITGB2 LNPEP IL18 SEC24A HAUS1 FAM167A GNPTAB HACD2 VAMP3 FPR3 CPA3 CHUK CD163 SLC11A1 FAM216A GGH CLEC4A CD53 KIF2A TREX1 CPEB4 TPRKB IFI44L PLEK TCEB1 PSMD11 SEC31A FCGR2A HAVCR2 TNFSF13B ERAP2 EIF2AK1 MRTO4 GPLD1 SNRPA1 UQCR10 DBNDD1 CTSL C3AR1 SMAD4 CCBL2 KLRD1 ERAP1 PSMA4 PSMB7 APITD1 RNF41 LILRB4 FCGR3A PSMD4 NOTCH2 NUTF2 SEC22B CTSS IFI6 NUDT1 SMURF2 ADCY7 SLC25A40 GSTCD GPNMB CPVL)
# phenos=(LILRB4 LILRB2 LAIR1)
phenos=(TIGIT CTLA4 LAG3 APOE PDCD1)
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
# PHENO=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/phenotypes_intersect/pancanatlas/pheno_all_zcancer
PHENO=/cellar/users/mpagadal/projects/germline-immune2/data/plink-associations/io_phenotypes/pancanatlas/pheno_all_zcancer
COVAR=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/cov/immune.filt.cov
# ASSOC=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/associations_intersect
ASSOC=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/io_associations

cd $ASSOC

# /cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --glm firth-fallback sex cols=+err --out $ASSOC/$pheno

# ######################
# ##### CLUMPING #######
# ######################

# #get only ADD rows
# head -1 $ASSOC/$pheno.$pheno.glm.linear > $pheno.assoc
# awk '{ if ($7 == "ADD") { print $0} }' $ASSOC/$pheno.$pheno.glm.linear >> $pheno.assoc

# #replace ID column name with SNP for clumping method
# sed -i -e '1s/ID/SNP/' $pheno.assoc

# plink --bfile $GENO --clump $pheno.assoc --clump-p1 .000000070922 --clump-p2 0.00001 --clump-r2 0.50 --clump-kb 500 --out $pheno.clump

########################################
##### run cancer type #######
########################################

for canc in ACC BLCA BRCA CESC CHOL COAD ESCA GBM HNSC KICH KIRC KIRP LGG LIHC LUAD LUSC MESO OV PAAD PCPG PRAD READ SARC SKCM STAD TGCT THCA UCEC UCS UVM

do

keep=/cellar/users/mpagadal/data/tcga/phenotypes/cancer-ids/$canc
extract=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt

/cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --covar $COVAR --covar-name C1-C10,age --covar-variance-standardize --keep $keep --extract $extract --glm firth-fallback sex cols=+err --out $ASSOC/$pheno\_$canc

done

date
