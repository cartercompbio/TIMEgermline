#!/usr/bin/env python
# coding: utf-8

# In[2]:


library(data.table)
library(DescTools)


# In[1]:


df=read.table("/cellar/users/tsears/projects/germline-immune/data/icb.pd1.pdl1.tmb.germline.tsv",sep="\t",header=TRUE)


# In[3]:


unique(df$study)[0:8]


# In[4]:


head(df)


# In[5]:


df_results = data.frame(study = character(), model = character(), r2=numeric())

for (study in unique(df$study)){

    print(study)
    df_study=df[df$study==study,]
    
    if (nrow(df_study)>10){
    df_study=merge(df_study[c("FID","study","response")],scale(df_study[c("PDCD1","CD274","TMB","CTLA4","LASSO_burden")],center=T), by.x=0,by.y=0)
    
    tryCatch({
    #germline PRS alone
    study_prs<-glm(response ~ LASSO_burden, data = df_study,family = "binomial")
    print(PseudoR2(study_prs))
    df_results=rbind(df_results,data.frame(study=study,model="germline PRS only",r2=PseudoR2(study_prs,which="all")))
        }
    )

    tryCatch({
    #TMB/PDL1/PD1 
    study_prs<-glm(response ~ TMB, data = df_study,family = "binomial")
    print(PseudoR2(study_prs))
    df_results=rbind(df_results,data.frame(study=study,model="TMB",r2=PseudoR2(study_prs,which="all")))
                }, error=function(e){print("ERROR")})
        
    tryCatch({
    #TMB/PDL1/PD1 
    study_prs<-glm(response ~ TMB + PDCD1 + CD274 + CTLA4, data = df_study,family = "binomial")
    print(PseudoR2(study_prs))
    df_results=rbind(df_results,data.frame(study=study,model="TMB/PD1/PDL1/CTLA4",r2=PseudoR2(study_prs,which="all")))
                }, error=function(e){print("ERROR")})
        
    tryCatch({
    #TMB/PDL1/PD1 + germline PRS
    study_prs<-glm(response ~ TMB + PDCD1 + CD274 +CTLA4 + LASSO_burden, data = df_study,family = "binomial")
    print(PseudoR2(study_prs))
    df_results=rbind(df_results,data.frame(study=study,model="TMB/PD1/PDL1/CTLA4+germline",r2=PseudoR2(study_prs,which="all")))
                }, error=function(e){print("ERROR")})
    
}

}


# In[6]:


write.csv(df_results,"/cellar/users/tsears/projects/germline-immune/data/r2.results.csv")


# In[ ]:




