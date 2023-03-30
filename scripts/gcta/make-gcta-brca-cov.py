import pandas as pd
import os
import numpy as np

cov=pd.read_csv("/cellar/users/mpagadal/gcta/covs/tcga.eur.sex.covar",header=None,sep="\t")
brca=pd.read_csv("/cellar/users/mpagadal/projects/er-brca/data/TCGA_BRCA_subtypes.csv")
cov["ER"]=np.where(cov[0].isin(brca[brca["breast_carcinoma_estrogen_receptor_status"]=="Positive"]["bcr_patient_barcode"].tolist()),1,0)
cov["PR"]=np.where(cov[0].isin(brca[brca["breast_carcinoma_progesterone_receptor_status"]=="Positive"]["bcr_patient_barcode"].tolist()),1,0)
cov["HER2"]=np.where(cov[0].isin(brca[brca["lab_proc_her2_neu_immunohistochemistry_receptor_status"]=="Positive"]["bcr_patient_barcode"].tolist()),1,0)
cov.to_csv("/cellar/users/mpagadal/gcta/covs/tcga.eur.brca.sex.receptor.covar",index=None,header=None,sep="\t")