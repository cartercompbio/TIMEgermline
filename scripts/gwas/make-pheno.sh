#! /bin/bash
#SBATCH --mem=20G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-3%3
#SBATCH --partition=carter-compute

datas=(pancanatlas sailfish firebrowse)
data=${datas[$SLURM_ARRAY_TASK_ID-1]}

date


###########################
## MAKE PHENOTYPE FILES  ##
###########################

ciber=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/phenotypes/TCGA.Kallisto.fullIDs.cibersort.relative.tsv
landscape=/cellar/users/mpagadal/projects/germline-immune2/data/downloaded_phenos/pheno-immune-landscape-comp
fam=/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.final.noimmunecancers.clean.fam
# rna=/cellar/users/mpagadal/data/tcga/rna/tpm/compiled/$data/all.tumor.rna.tsv
rna=/cellar/users/mpagadal/data/tcga/rna/tpm/compiled/$data/all.tumor.intersect.rna.tsv
out=/cellar/users/mpagadal/projects/germline-immune3/data/plink-associations/phenotypes_intersect/$data
pheno=/cellar/users/mpagadal/projects/germline-immune3/data/supplemental/Supplemental_Table_1.csv

# make RNA files

#################
# IP components #
#################

mkdir $out

python /cellar/users/mpagadal/projects/germline-immune3/scripts/make-pheno.py --rna $rna --pheno $pheno --ciber $ciber --landscape $landscape --geno $fam --out $out

source activate r-env

sbatch /cellar/users/mpagadal/projects/germline-immune/bin/rank-norm.sh $out

wait

cd $out

python /cellar/users/mpagadal/projects/germline-immune3/scripts/compile-pheno.py --dir $out --out pheno_all_zcancer

# rm /cellar/users/mpagadal/projects/germline-immune/discovery/data/plink-associations/phenotypes/$data/*.unnorm.csv

##############
# IO targets #
##############

# source activate baseold

# out=/cellar/users/mpagadal/projects/germline-immune2/data/plink-associations/io_phenotypes/$data/

# mkdir -p $out

# python /cellar/users/mpagadal/projects/germline-immune2/scripts/make-pheno.py --rna $rna --pheno ../data/ip_components/io_targets.csv --ciber $ciber --landscape $landscape --geno $fam --out $out

# conda deactivate
# source activate r-env

# sbatch /cellar/users/mpagadal/projects/germline-immune2/scripts/rank-norm.sh $out

# wait

# conda deactivate

# cd $out
# source activate baseold

# python /cellar/users/mpagadal/projects/germline-immune2/scripts/compile-pheno.py --dir $out --out pheno_all_zcancer

# rm /cellar/users/mpagadal/projects/germline-immune/discovery/data/plink-associations/phenotypes/$data/*.unnorm.csv



date




