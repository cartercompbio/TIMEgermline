import numpy as np
import pandas as pd
import os
import argparse
import subprocess


def get_data(directory,cov_name):
    files=[x for x in os.listdir(directory) if ".glm.linear" in x]
    compiled=pd.DataFrame()
    for x in files:
        df=pd.read_csv(directory+"/"+x,delimiter="\t")
        df=df[df["TEST"].str.contains(cov_name)]
        df["pheno"]=x.split("_")[0]
        df["P"]=pd.to_numeric(df["P"])
        compiled=compiled.append(df)
    return(compiled)

def main(args):
    ieqtl=get_data(args.dir, args.cov)
    ieqtl.to_csv(args.out)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', type=str, help='directory with ieqtl results')
    parser.add_argument('--cov', type=str, help='covariate string to filter for')
    parser.add_argument('--out', type=str, help='name of output file')
    args = parser.parse_args()
    main(args)
