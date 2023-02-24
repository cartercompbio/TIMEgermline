import pandas as pd
import os
import numpy as np
import json
import argparse

def filter_zeros(df,threshold):
    '''
    inputs:
    df: dataframe of rna values
    threshold: % of zero values by which to exclude phenotypes
    
    output:
    dataframe with rna values < threshold of zero values
    '''
    
    keep=[]
    remove=[]
    
    for x in df.columns:
        if len(df[df[x]==0])>threshold*len(df):
            remove.append(x)
        else:
            keep.append(x)
    
    print("{} phenotypes with > {} zeroes were removed".format(len(remove),threshold))
    return(df[keep])

def filter_genotyped(df,fam):
    '''
    inputs:
    df: dataframe of rna values
    fam: PLINK fam file of genotyped individuals
    
    output:
    dataframe with rna values of only GENOTYPED individuals
    '''
    geno=pd.read_csv(fam,header=None,sep=" ")[0].tolist()
    df=df[df.index.isin(geno)]
    df=df.reset_index()
    df=df.rename(columns={"index":"FID"})
    return(df)


def main(args):
    
    #get phenotypes
    pheno=pd.read_csv(args.pheno,header=None,index_col=0)
    phenos=pheno[1].tolist()
    
    rna=pd.read_csv(args.rna,delimiter="\t",index_col=0)
    
    #convert aliases
    mp_ids={"CMC2":"C16orf61","ADGRE5":"CD97","SPRYD7":"C13orf1","JCHAIN":"IGJ","CTSL":"CTSL1","CTSV":"CTSL2","TEX30":"C13orf27","CENPU":"MLF1IP","CMSS1":"C3orf26","FAM216A":"C12orf24","HACD2":"PTPLB"}
    mp_ids= {v: k for k, v in mp_ids.items()}
    
    rna=rna.rename(columns=mp_ids)
    
    rna.columns=[x.replace("-",".") for x in rna.columns]
        
    final_genes=[x for x in set(phenos) if x in rna.columns]
    rna=rna[final_genes]
    
    rna=filter_zeros(rna,0.1)
    rna=rna.reset_index().rename(columns={"index":"FID"})
    print(rna.shape)
        
    #get cibersortx data
    ciber_lm22=pd.read_csv(args.ciber,delimiter="\t")
    ciber_lm22["id"]=ciber_lm22["SampleID"].str.replace(".","-")
    ciber_lm22["code"]=ciber_lm22["id"].str.rsplit("-",4).str[1]
    ciber_lm22["id"]=ciber_lm22["id"].str.rsplit("-",4).str[0]
    ciber_lm22=ciber_lm22[ciber_lm22["code"].str.contains("01")]
    ciber_lm22.index=ciber_lm22["id"]
    ciber_lm22=ciber_lm22[ciber_lm22.columns[2:-5].tolist()]
    ciber_lm22=ciber_lm22.groupby(ciber_lm22.index).mean()
    ciber_lm22=ciber_lm22.reset_index().rename(columns={"id":"FID"})
    ciber=filter_zeros(ciber_lm22,0.1)
    
    #get immune landscape data
    landscape=pd.read_csv(args.landscape,delimiter="\t")
    landscape=landscape.replace(-9, np.nan)
    del landscape["IID"]

    #combine phenotypes
    total=pd.merge(rna,landscape,on=["FID"],how="outer")
    total=pd.merge(total, ciber,on=["FID"],how="outer")
    total=total.set_index("FID")
    
    #filter for genotypes individuals
    tcga_df=filter_genotyped(total,args.geno)
    
    #export unnormalized phenotype dataframes by cancer type
    canc = pd.read_csv("/cellar/controlled/dbgap-genetic/phs000178_TCGA/birdseed-processing/gtype.meta", delimiter="\t", header=None)
    mp = canc.set_index(2)[0].to_dict()
    tcga_df["cancer"]=tcga_df["FID"].map(mp)
    
    #export unnormalized data
    for x in tcga_df["cancer"].unique():
        try:
            tumor=tcga_df[tcga_df["cancer"]==x]
            del tumor["cancer"]
            tumor.to_csv(args.out+"/pheno_"+x+".unnorm.csv",index=None,sep="\t")
            
        except:
            pass


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--rna', type=str, help='firebrowse, pancanatlas, sailfish rna file')
    parser.add_argument('--pheno', type=str, help='dataframe of phenotypes (csv)')
    parser.add_argument('--ciber', type=str, help='dataframe of CIBERSORTx results')
    parser.add_argument('--landscape', type=str, help='dataframe of Thorssen et al results')
    parser.add_argument('--geno', type=str, help='FAM file of genotypes individuals')
    parser.add_argument('--out', type=str, help='output file name')
    args = parser.parse_args()
    main(args)
