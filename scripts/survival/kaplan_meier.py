import pandas as pd
import numpy as np
import sys
sys.path.insert(0, "/cellarold/users/mpagadal/Programs/anaconda3/lib/python3.7/site-packages")
import lifelines

from lifelines import KaplanMeierFitter
from lifelines import CoxPHFitter
from lifelines.statistics import logrank_test
from scipy.stats import pearsonr, spearmanr, mannwhitneyu

### STATS ###
import statsmodels.stats.multitest as multi
from matplotlib.collections import PatchCollection

import argparse

def fdr(df,P):
    probabilities = df[P].to_numpy()
    report = multi.multipletests(probabilities,
                alpha=0.05,
                method="fdr_bh",
                is_sorted=False,
            )
    discoveries = report[1]
    df["fdr"]=discoveries
    df["fdr"]=pd.to_numeric(df["fdr"])
    df["-log10(fdr)"]=-np.log10(df["fdr"])
    
    return(df)
    
def make_df(surv,surv_type,raw):
    #get survival dataframe
    surv=pd.read_csv(surv,index_col=0)
    surv=surv.rename(columns={"bcr_patient_barcode":"FID"})
    #get genotypes
    snps=pd.read_csv(raw,delimiter=" ")
    cols=[x for x in snps.columns if x not in ["IID","PAT","MAT","SEX","PHENOTYPE"]]
    snps=snps[cols]
    #combine dataframes
    full_surv=pd.merge(surv[["FID",surv_type,surv_type+".time"]],snps,on="FID")
    print(full_surv.shape)
    full_surv=full_surv[full_surv[surv_type+".time"]<1825]
    return(full_surv)

def run_surv(df,surv_type,rsid,cancers):
    snp=[]
    logrank=[]
    cancer=[]
    min_group=[]
    maj_group=[]

    for y in cancers:
        for x in rsid:
            try:
                full_surv_canc=df[df["cancer"]==y]
            
                rs=x.rsplit(":",2)[0]
                allele=x.split(":")[3]
                minor=allele.split("_")[1]
                major=allele.split("_")[0]
            
                groups = full_surv_canc[x]
                ix0 = (groups == 0)
                ix1 = (groups == 1)
                ix2 = (groups == 2)

                results = logrank_test(full_surv_canc[surv_type+'.time'][ix0], full_surv_canc[surv_type+'.time'][ix2],event_observed_A=full_surv_canc[surv_type][ix0], event_observed_B=full_surv_canc[surv_type][ix2], alpha=.95) 
        
                snp.append(x)
                logrank.append(results.p_value)
                cancer.append(y)
                min_group.append(len(full_surv_canc[surv_type+'.time'][ix2]))
                maj_group.append(len(full_surv_canc[surv_type+'.time'][ix0]))
        
            except:
                pass
        
    kaplan=pd.DataFrame({"snps":snp,"logrank":logrank,"cancer":cancer,"min":min_group,"maj":maj_group})
    return(kaplan)
    
def main(args):
    # map to cancer type
    canc = pd.read_csv("/cellar/controlled/dbgap-genetic/phs000178_TCGA/birdseed-processing/gtype.meta", delimiter="\t", header=None)
    mp_canc = canc.set_index(2)[0].to_dict()
    
    #overall survival
    os_surv=make_df(args.survival,"OS",args.raw)
    os_surv["cancer"]=os_surv["FID"].map(mp_canc)
    rsid_lst=os_surv.columns[3:-1]

    # make list of cancer types
    cancers=os_surv["cancer"].unique().tolist()
    print("conducting OS survival analysis with {0} variants and {1} cancers".format(len(rsid_lst),len(cancers)))
    
    os=run_surv(os_surv,"OS",rsid_lst,cancers)
    os["sum"]=os["min"]+os["maj"]
    os["freq"]=os["min"]/os["sum"]
    
    # progression-free survival
    
    pfi_surv=make_df(args.survival,"PFI",args.raw)
    pfi_surv["cancer"]=pfi_surv["FID"].map(mp_canc)
    print("conducting PFI survival analysis with {0} variants and {1} cancers".format(len(rsid_lst),len(cancers)))
    
    pfi=run_surv(pfi_surv,"PFI",rsid_lst,cancers)
    pfi["sum"]=pfi["min"]+pfi["maj"]
    pfi["freq"]=pfi["min"]/pfi["sum"]
    
    
    os["survival"]="OS"
    pfi["survival"]="PFI"
    
    results=os.append(pfi)
    results.to_csv(args.out)
    
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--survival', type=str, help='survival dataframe', default="/cellar/users/mpagadal/resources/from-labmembers/andrea/Liu2018.TCGA_survival.csv")
    parser.add_argument('--raw', type=str, help='raw dataframe')
    parser.add_argument('--out', type=str, help='name of output file')
    
    args = parser.parse_args()
    main(args) 

    
    
    
