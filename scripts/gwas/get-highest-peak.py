import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import argparse
import subprocess

def main(args):
    #get snp
    file2 = open(args.pheno+".done.txt", "w")
    file2.write("0")
    file2.close()
    
    df=pd.read_csv(args.assoc_file,delimiter="\t",header=None)
    df[11]=df[11].astype(float)
    df=df.sort_values(by=11)
    snp=df[2].tolist()[0]
    beta=df[8].tolist()[0]
    p=df[11].tolist()[0]
    a1=df[5].tolist()[0]
    
    if df[11].tolist()[0] > .000001:
        print("no snps below suggestive threshold remaining....")
        file2 = open(args.pheno+".done.txt", "w")
        file2.write("1")
        file2.close()
    
    print("running association with {} snp at {} p value".format(snp,df[11].tolist()[0]))
    
    if os.stat(args.pheno+".extract").st_size == 0:
        print("extract file is empty...")
    else:
        if snp in pd.read_csv(args.pheno+".extract",header=None)[0].tolist():
            print("there are duplicated ids...")
            for x in df[2].tolist():
                if x not in pd.read_csv(args.pheno+".extract",header=None)[0].tolist():
                    snp=x
                    break
        
    file1 = open(args.pheno+".extract", "a")
    file1.write(snp+"\n")
    file1.close()
    
    file2 = open(args.pheno+".assoc", "a")
    file2.write(snp+"\t"+str(beta)+"\t"+str(p)+"\t"+str(a1)+"\n")
    file2.close()

        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--assoc_file', type=str, help='assoc name file')
    parser.add_argument('--pheno', type=str, help='assoc name file')
    args = parser.parse_args()
    main(args)
