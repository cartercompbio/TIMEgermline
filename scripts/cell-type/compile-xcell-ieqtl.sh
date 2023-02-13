#! /bin/bash
#SBATCH --mem=35G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-3%3
#SBATCH --partition=carter-compute


date

interactions=(cell age sex)
interaction=${interactions[$SLURM_ARRAY_TASK_ID-1]}

cd /cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/results

# OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/xcell/$interaction

# python /cellar/users/mpagadal/projects/germline-immune3/scripts/compile-xcell-ieqtl.py --dir $OUT --cov ADDx --out xcell.$interaction.csv

OUT=/cellar/users/mpagadal/projects/germline-immune3/data/x-cell-interaction/ciber/$interaction

python /cellar/users/mpagadal/projects/germline-immune3/scripts/compile-xcell-ieqtl.py --dir $OUT --cov ADDx --out ciber.$interaction.csv


date
