#! /bin/bash
#SBATCH --mem=10G
#SBATCH -o ../out/%A.%x.%a.out # STDOUT
#SBATCH -e ../err/%A.%x.%a.err # STDERR
#SBATCH --array=2
#SBATCH --partition=carter-compute

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME


samples=(all.time drb5.cond)
sample=${samples[$SLURM_ARRAY_TASK_ID-1]}

date

raw=/cellar/users/mpagadal/projects/germline-immune/data/genotypes/$sample.raw
out=/cellar/users/mpagadal/projects/germline-immune/data/survival

cd $out

python -u /cellar/users/mpagadal/projects/germline-immune/scripts/survival/kaplan_meier.py --raw $raw --out $sample.os.pfi.survival.csv

date