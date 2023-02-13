#!/bin/bash
#SBATCH -J SNPRet_64
#SBATCH --mem=32000
#SBATCH -o ../out/job_retrieval64.out
#SBATCH --partition=carter-compute
#SBATCH --array=1-1

chrlistZ=(6 )
CHR=${chrlistZ[$(expr $SLURM_ARRAY_TASK_ID - 1)]}


inBGEN=/cellar/controlled/ukb-genetic/imputation/ukb_imp_chr"$CHR"_v3.bgen
inSAMPLE=/cellar/controlled/ukb-genetic/imputation/ukb_imp_chr"$CHR"_v3.sample
outGEN=tmp_4616_x_$CHR.bgen
outSAMPLE=tmp_4616_x_$CHR.sample



/cellar/users/mpagadal/Programs/qctool_v2.0.1-Ubuntu14.04-x86_64/qctool -g $inBGEN -s $inSAMPLE -og $outGEN -os $outSAMPLE -incl-rsids tmp_4616_zSNPLIST 
