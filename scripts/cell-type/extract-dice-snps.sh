#! /bin/bash
#SBATCH --mem=10G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --array=1-15%15
#SBATCH --partition=carter-compute

echo $SLURM_ARRAY_TASK_ID
echo $HOSTNAME


dices=(CD4_STIM NK CD4_NAIVE TREG_MEM MONOCYTES TH1 TFH CD8_NAIVE CD8_STIM TH17 THSTAR TREG_NAIVE TH2 M2 B_CELL_NAIVE)
dice=${dices[$SLURM_ARRAY_TASK_ID-1]}

date

snp_lst=/cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-cancer-time-rsid-proxy.txt
out=/cellar/users/mpagadal/projects/germline-immune3/data/dice

grep -w -f $snp_lst /cellar/users/mpagadal/data/dice/vcf/significant/$dice.vcf > $out/$dice.snps.txt

date
