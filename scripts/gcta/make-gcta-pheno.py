import pandas as pd
import os
import argparse

def main(args):
    pheno=pd.read_csv(args.pheno,delimiter="\t")
    
    for x in pheno.columns[2:]:
        df=pheno[["FID","IID",x]].copy()
        df[x].replace(-9.0,"NA",inplace=True)
        df.to_csv(args.out+x+".phen",header=None,index=None, sep="\t")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--pheno', type=str, help='rank-normalized PLINK phenotype file')
    parser.add_argument('--out', type=str, help='output directory')
    args = parser.parse_args()
    main(args)

    
