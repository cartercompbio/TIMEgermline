import numpy as np
import pandas as pd
import os
import argparse
import subprocess

def main(args):
    mapping=pd.read_csv("/cellar/controlled/ukb-salem/GenoInfo/UKBiobank_genoQC_allancestry_linker.txt",delim_whitespace=True)
    mp_mapping=dict(zip(mapping["FID_Salem"],mapping["FID"]))
    
    x_fam=pd.read_csv(args.fam,header=None,delim_whitespace=True)
    x_fam["FID"]=x_fam[0].map(mp_mapping)
    x_fam[["FID","FID",2,3,4,5]].to_csv(args.fam,index=None,header=None,sep="\t")

        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--fam', type=str, help='UKBB fam file - excluded')
    args = parser.parse_args()
    main(args)
