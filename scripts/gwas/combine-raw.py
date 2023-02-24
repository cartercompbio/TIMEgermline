import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import argparse
import subprocess

def main(args):
    #get snp
    cov=pd.read_csv(args.cov,delimiter=" ")
    del cov["Unnamed: 64"]
    add=pd.read_csv(args.add_cov,delimiter=" ")
    add.columns=[x.split("_")[0] for x in add.columns]
    total=pd.merge(cov,add[[x for x in add.columns if x not in ["PAT","MAT","SEX","PHENOTYPE"]]])
    total=total.fillna(-9)
    total.to_csv(args.pheno+".compiled.cov",index=None,sep="\t")

        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--cov', type=str, help='covariate file')
    parser.add_argument('--add_cov', type=str, help='new covariate file')
    parser.add_argument('--pheno', type=str, help='new covariate file')
    
    args = parser.parse_args()
    main(args)
