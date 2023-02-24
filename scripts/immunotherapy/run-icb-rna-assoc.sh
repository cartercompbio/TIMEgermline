#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ../out/%A.%x.%a.out # STDOUT
#SBATCH -e ../err/%A.%x.%a.err # STDERR
#SBATCH --array=1-7
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

studies=(hugo miao riaz rizvi snyder vanallen melanoma.no.crist.liu)
study=${studies[$SLURM_ARRAY_TASK_ID-1]}

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME
echo $study 

date

#pheno Associations

GENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/imputedv2_all/imputed
PHENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/phenos/pheno.rna.cibersortx.rank.norm.study.tsv
COVAR=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/covar/total.cov.age.sex.study.pc.infiltrate2.txt
#EXTRACT=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-icb-fdr-50.txt
EXTRACT=/cellar/users/mpagadal/projects/germline-immune/snp-tables/extract.icb.txt
# OUT=/cellar/users/mpagadal/projects/germline-immune/data/icb-associations
OUT=/cellar/users/mpagadal/projects/germline-immune/data/icb-rna-associations
KEEP=/cellar/users/mpagadal/immunotherapy-trials/patients/$study.txt

cd $OUT

if [ $study == "melanoma.no.crist.liu" ]

    then
    
        for pheno in CD274 PDCD1 CTLA4 CTSS CTSW FAM216A LYZ C3AR1 DCTN5 DBNDD1 FPR1 TREX1 DHFR ERAP1 ERAP2 DYNLT1 GPLD1 PSMD11
        
        do
        
        /cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --keep $KEEP --covar $COVAR --covar-name Age,Gender,C1-C10,vanallen,hugo --covar-variance-standardize --glm firth-fallback sex cols=+err --out $study.$pheno

        done
        
        PHENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/phenos/pheno.tmb.txt
        pheno=TMB
        
        /cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --keep $KEEP --covar $COVAR --covar-name Age,Gender,C1-C10 --covar-variance-standardize --glm firth-fallback sex cols=+err --out $study.$pheno
    
        

    else


        for pheno in CD274 PDCD1 CTLA4 CTSS CTSW FAM216A LYZ C3AR1 DCTN5 DBNDD1 FPR1 TREX1 DHFR ERAP1 ERAP2 DYNLT1 GPLD1 PSMD11

        do

        /cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --keep $KEEP --covar $COVAR --covar-name Age,Gender,C1-C10 --covar-variance-standardize --glm firth-fallback sex cols=+err --out $study.$pheno

        done


        PHENO=/cellar/controlled/users/mpagadal/immunotherapy-trials/normal_wxs/phenos/pheno.tmb.txt
        OUT=/cellar/users/mpagadal/projects/germline-immune2/data/icb-associations/tmb
        pheno=TMB


        /cellar/users/mpagadal/Programs/plink2 --bfile $GENO --pheno $PHENO --pheno-name $pheno --extract $EXTRACT --keep $KEEP --covar $COVAR --covar-name Age,Gender,C1-C10 --covar-variance-standardize --glm firth-fallback sex cols=+err --out $study.$pheno

    fi


date
