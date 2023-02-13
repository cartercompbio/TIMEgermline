import pandas as pd
import os
import argparse

def Merge(dict1, dict2):
    res = {**dict1, **dict2}
    return res


def main(args):
    mp_bim=pd.read_csv(args.map_ukbb,delim_whitespace=True,header=None)
    mp_bim[0]=mp_bim[0].astype(str)
    mp_bim[0]=mp_bim[0].str.replace("23","X")
    mp_bim["variant"]=mp_bim[0].astype(str)+":"+mp_bim[3].astype(str)+":"+mp_bim[5]+":"+mp_bim[4]
    mp_bim["variant2"]=mp_bim[0].astype(str)+":"+mp_bim[3].astype(str)+":"+mp_bim[4]+":"+mp_bim[5]
    
    
    mp_bim=Merge(dict(zip(mp_bim["variant"],mp_bim[1])),dict(zip(mp_bim["variant2"],mp_bim[1])))

    bim=pd.read_csv(args.bim,header=None,delim_whitespace=True)
    bim[1]=bim[1].map(mp_bim)
    bim.to_csv(args.bim,header=None,sep="\t",index=None)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--map_ukbb', type=str, help='ukbb bim with rsid and variant mapping')
    parser.add_argument('--bim', type=str, help='bim file to map')
    args = parser.parse_args()
    main(args)
