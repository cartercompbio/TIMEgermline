#! /bin/bash
#SBATCH --mem=10G
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --partition=carter-compute
#SBATCH --time=1-00:00:00

date

# Rscript ~/scripts/ldlink.R extract-vanderbilt-phewas.txt

# cd /cellar/users/mpagadal/projects/germline-immune3/data/ldlink

cd /cellar/users/mpagadal/projects/germline-immune3/data/ldlink/time-proxy

# Rscript ~/scripts/ldlink.R /cellar/users/mpagadal/projects/germline-immune3/snp-tables/lit-not-found.txt

# Rscript ~/scripts/ldlink.R /cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract_all_time_rsid_proxy.txt

cd /cellar/users/mpagadal/projects/germline-immune3/data/ldlink/chatrath

Rscript ~/scripts/ldlink.R /cellar/users/mpagadal/projects/germline-immune3/snp-tables/extract-chatrath-rsid.txt

date
