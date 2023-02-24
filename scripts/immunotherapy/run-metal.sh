#! /bin/bash
#SBATCH --mem-per-cpu=10G
#SBATCH -n 4
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-4%4
#SBATCH --partition=carter-compute

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME

date

phenos=(response_crist_sd response_crist_sd_surv response_crist_partial response_crist_complete)
pheno=${phenos[$SLURM_ARRAY_TASK_ID-1]}


# for test in sample.size effect sample.size.no.liu effect.no.liu
for test in v1.sample.size v1.sample.size.no.weight

do

out=/cellar/users/mpagadal/projects/germline-immune3/data/icb-response/metal/output/$pheno/$test
in=/cellar/users/mpagadal/projects/germline-immune3/data/icb-response/metal/input/$pheno
script=/cellar/users/mpagadal/projects/germline-immune3/scripts

mkdir -p $out
cd $out

scp -r $in/*add .

/cellar/users/mpagadal/Programs/metal/effect-sizes/metal $script/metal.$test.sh

rm *add

done



date
