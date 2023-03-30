import pandas as pd
import os
import numpy as np

hla=pd.read_csv("/cellar/users/andreabc/Data/TCGA/hla_types/all_mhc_ii_types.csv")
drb1_15=hla[hla["DRB1_1"].str.startswith("DRB1_15")]["Unnamed: 0"].tolist()+hla[hla["DRB1_1.1"].str.startswith("DRB1_15")]["Unnamed: 0"].tolist()+hla[hla["DRB1_2"].str.startswith("DRB1_15")]["Unnamed: 0"].tolist()+hla[hla["DRB1_2.1"].str.startswith("DRB1_15")]["Unnamed: 0"].tolist()
drb1_16=hla[hla["DRB1_1"].str.startswith("DRB1_16")]["Unnamed: 0"].tolist()+hla[hla["DRB1_1.1"].str.startswith("DRB1_16")]["Unnamed: 0"].tolist()+hla[hla["DRB1_2"].str.startswith("DRB1_16")]["Unnamed: 0"].tolist()+hla[hla["DRB1_2.1"].str.startswith("DRB1_16")]["Unnamed: 0"].tolist()
pts=[x for x in set(drb1_15+drb1_16)]
keep=pd.DataFrame({"pts":pts,"pts2":pts})
keep.to_csv("keep_hla_drb1_15_15.txt",index=None,header=None,sep="\t")