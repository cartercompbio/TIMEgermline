#! /bin/bash
#SBATCH --mem=10G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --partition=carter-compute

date

cd /cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time-snp/dosage-multi

# sbatch /cellar/users/mpagadal/scripts/ukbb/snp_retriever_UKB_bgen_dosage.v4.sh UKBB time extract_all_time_rsid_ukbb_proxy.txt

# wait

#autosomal variants

plink --bfile UKBB_time_subset --make-bed --out UKBB_time_subset_map

python ~/scripts/germline/format_bim.py --bim UKBB_time_subset_map.bim --type chr_bp_ref_alt --out UKBB_time_subset_map.bim

plink --bfile UKBB_time_subset_map --extract /cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt --make-bed --out UKBB_time_subset_biallelic

python /cellar/users/mpagadal/projects/germline-immune3/scripts/remap_ukbb.py --map_ukbb /cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time-snp/dosage-multi/UKBB_time_subset_map.bim --bim /cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time-snp/dosage-multi/UKBB_time_subset_biallelic.bim

# X chromosome

plink2 --bgen /cellar/controlled/ukb-salem/GenoImpute/ukb_impute_chrX_v3.bgen ref-first --sample /cellar/controlled/ukb-salem/GenoImpute/ukb_impute_chrX_v3.sample --extract ../../../../snp-tables/extract_all_time_rsid_proxy.txt --make-bed --out chrX

plink --bfile chrX --remove ~/data/ukbb/mapping/exclude.x.individuals.txt --make-bed --out chrX.clean

python ../../../../scripts/remap_ukbb_fam.py --fam chrX.clean.fam

plink --bfile chrX.clean --output-chr MT --make-bed --out chrX_map

python ~/scripts/germline/format_bim.py --bim chrX_map.bim --type chr_bp_ref_alt --out chrX_map.bim

plink --bfile chrX_map --extract /cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-all-time-variants-proxy.txt --make-bed --out chrX_biallelic

python /cellar/users/mpagadal/projects/germline-immune3/scripts/remap_ukbb.py --map_ukbb /cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time-snp/dosage-multi/chrX.clean.bim --bim /cellar/users/mpagadal/projects/germline-immune3/data/ukbb/time-snp/dosage-multi/chrX_biallelic.bim


date