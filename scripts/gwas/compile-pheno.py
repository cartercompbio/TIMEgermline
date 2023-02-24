import argparse
import pandas as pd
import os
import numpy as np
import json

def main(args):
    compiled=pd.DataFrame()
    for x in [x for x in os.listdir(args.dir) if "rank" in x]:
        df=pd.read_csv(args.dir+x,delimiter="\t")
        df["cancer"]=x.split("_")[1].split(".")[0]
        compiled=compiled.append(df)

#     x="FGR"
#     #plot rna expression by cancer type
#     sns.set(style="whitegrid", font_scale = 1)
#     plt.figure(figsize=(20,5))
#     sns.set_style("whitegrid", {'axes.grid' : False})
#     ax = sns.boxplot(x="cancer", y=x, data=compiled)
#     ax.set(xlabel="cancer", ylabel='rank norm FGR')
#     plt.xticks(rotation=30)
#     plt.title(x)
#     plt.savefig(args.data+".pheno.pdf")
    
    del compiled["cancer"]
    compiled["IID"]=compiled["FID"]
    cols=["FID","IID"]+compiled.columns.tolist()[1:-1]
    compiled=compiled[cols]
    compiled.columns=[x.replace("-",".") for x in compiled.columns]
    compiled=compiled.fillna(-9)
    
    compiled.to_csv(args.out,index=None,sep="\t")
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', type=str, help='directory name')
    parser.add_argument('--out', type=str, help='output file name')
    args = parser.parse_args()
    main(args)
