import numpy as np
import pandas as pd
import os
import argparse
import subprocess


def main(args):
    files = [x for x in os.listdir(args.new_tcga) if "raw" in x]
    new_tcga=pd.read_csv(args.new_tcga+files[0],delim_whitespace=True)

    for x in files[1:]:
        raw=pd.read_csv(args.new_tcga+x,delim_whitespace=True)
        new_tcga=pd.merge(new_tcga, raw, on=["FID","IID","PAT","MAT","SEX","PHENOTYPE"])
    
    old_tcga=pd.read_csv(args.old_tcga+"tcga.raw",delim_whitespace=True)
    snps=old_tcga.columns[6:].tolist()

    snps_test=[]

    for x in snps:
        try:
            new_tcga[x]
            snps_test.append(x)
        except:
            snp=x.rsplit(":",2)[0]
            minor=x.split("_")[-1]
            try:
                new_x=[x for x in new_tcga.columns if snp in x][0]
                snps_test.append(x)
            except:
                print("missing {}".format(snp))
            if new_x.split("_")[-1]==minor:
                new_tcga[x]=new_tcga[new_x]
            else:
                print(x)
                print(new_x)
                new_tcga[x]=new_tcga[new_x].map({2:0,1:1,0:2})
            
    old_tcga.columns=old_tcga.columns.tolist()[0:6]+["org "+x for x in old_tcga.columns.tolist()[6:]]
    new_tcga.columns=new_tcga.columns.tolist()[0:6]+["new "+x for x in new_tcga.columns.tolist()[6:]]

    all_tcga=pd.merge(old_tcga,new_tcga,on=new_tcga.columns.tolist()[0],how="left")

    snps=[]
    mismatch=[]

    for x in snps_test:
        snps.append(x)
        mismatch.append(len(all_tcga[all_tcga["org "+x]!=all_tcga["new "+x]])/len(all_tcga))

    df=pd.DataFrame({"snps":snps,"impute mismatch":mismatch})
    df["snps"]=df["snps"].str.split("_").str[0]


    #map to minor allele frequency
    maf=pd.read_csv("/cellar/controlled/dbgap-genetic/phs000178_TCGA/imputation/michigan-imputation/HRC/european.maf.frq",delim_whitespace=True)
    mp_maf=dict(zip(maf["SNP"],maf["MAF"]))
    df["maf"]=df["snps"].map(mp_maf)
    df.to_csv(args.out)

    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--new_tcga', type=str, help='directory with new tcga  genotype results')
    parser.add_argument('--old_tcga', type=str, help='directory with old tcga  genotype results')
    parser.add_argument('--out', type=str, help='name of output file')
    args = parser.parse_args()
    main(args)
