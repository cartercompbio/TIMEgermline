#! /bin/bash
#SBATCH --mem=50G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-5%5
#SBATCH --partition=carter-compute

date

studies=(miao rizvi cristescu_melanoma cristescu_hnscc liu)
study=${studies[$SLURM_ARRAY_TASK_ID-1]}

prsice=/cellar/users/mpagadal/Programs/PRSICE/PRSice_linux
prsicer=/cellar/users/mpagadal/Programs/PRSICE/PRSice.R
geno=/nrnb/users/mpagadal/immunotherapy-trials/normal_wxs/imputedv2_all/imputed
pheno=/nrnb/users/mpagadal/immunotherapy-trials/normal_wxs/phenos/total.pheno.responder.v2.txt
patient=/cellar/users/mpagadal/immunotherapy-trials/patients/$study.txt
cov=/nrnb/users/mpagadal/immunotherapy-trials/normal_wxs/covar/total.cov.age.sex.study.v2.txt
# extract=/cellar/users/mpagadal/projects/germline-immune/snp-tables/extract-all-time-variants-proxy.txt
extract=/cellar/users/mpagadal/projects/germline-immune/snp-tables/extract-rand-icb-fdr-50.txt
pheno_col=response_crist_sd

out=/cellar/users/mpagadal/projects/germline-immune3/data/prsice/rand_11_icb_variants/$pheno_col
mkdir -p $out
base=/cellar/users/mpagadal/projects/germline-immune3/data/icb-response/prsice-associations/$pheno_col.prsice.assoc

cmd="Rscript $prsicer -b $base --snp ID --target $geno --score sum --pheno $pheno --pheno-col $pheno_col --cov $cov --cov-col Age,Gender,@C[1-10] --extract $extract --memory 100000000 --keep $patient --quantile 20 --out $out/$study --print-snp --all-score --prsice $prsice --binary-target T"
echo $cmd
$cmd


date