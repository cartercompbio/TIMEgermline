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


pheno=response_crist_sd 
test=v1.effect

out=/cellar/users/mpagadal/projects/germline-immune/data/icb-response/metal/output/$pheno/$test
in=/cellar/users/mpagadal/projects/germline-immune/data/icb-response/metal/input/$pheno
script=/cellar/users/mpagadal/projects/germline-immune3/scripts

mkdir -p $out
cd $out

scp -r $in/*add .

/cellar/users/mpagadal/Programs/metal/effect-sizes/metal $script/metal.$test.sh

rm *add

done



date
