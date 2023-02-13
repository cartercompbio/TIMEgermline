#! /bin/bash
#SBATCH -J SNP_retrieval 
#SBATCH --mem=32000
#SBATCH -o ../out/SNP_retrieval.out
#SBATCH -e ../err/SNP_retrieval.err
#SBATCH --partition=carter-compute

##############################################################################################
#
#
#   Name: snp_retriever_UKB_bgen_dosage.v4.sh
#
#   Description: Used for SNP retrieval from UKB BGEN format imputed files. 
#
#   Usage: bash snp_retriever_UKB_bgen_dosage.v4.sh [xNAME] [xSAMPLE] [xSNPLIST]
#
#   Example: bash snp_retriever_UKB_bgen_dosage.v4.sh UKB SAMPLE1 snp.txt 
#
#   Output Plink files, dosage file and sample files will have the following format:
#   xNAME_xSAMPLE_subset.[fam/bed/bim/dosage/sample]
#
#   By: Rany Salem and Steven Cao
#
#   Date: 3/18/2020
#
##############################################################################################
# Version 4 new : This version uses cat-bgen instead of qctools to merge bgen files together, which 
# is much faster. Also we are using a new python script "/data/nrnb03/REF/SOFTWARE/PYTHONCode/impute2calcDosage.v2.py".
# This updated script allows for us to incorporate an extra column (column 1 which is the chr column) in the dosage
# calculations.  



# SNP Retrieval Script for UK Biobank imputed Genotypes (uses QCTools rather than Gtools for primary retrieval)
# Definining/Reading user specified script parameters/variables/values

        
        # 3 InPut Parameters (path to UKB imputed genotypes hard coded)
        xNAME=$1        # Short Study Name (matches name of imputation genotype files)
        xSAMPLE=$2      # Short Name of SNP Sample/Subset (used to indicate file name)
        xSNPLIST=$3     # List of SNPs to extract from imputed files (FORMAT: SNP CHR)
        random=$RANDOM


        # Dealing With Potential Duplicates (or more) in SNP list
        awk '{print $1}' $xSNPLIST | sort | uniq -c | awk '{print $2}' > tmp_"$random"_zSNPLIST

        echo "Generating List-File of CHRs info to update (from SNPLIST)"
        awk '{print $1, $2}' $xSNPLIST | sort | uniq -c | awk '{print $2, "\t", $3}' > tmp_"$random"_CHRupdate.txt


# Step 1: Generating list of Chrs to Loop through (note non-autosomal chrs ignored)

        chrlist=`awk '{print $2}' tmp_"$random"_CHRupdate.txt | grep -iv Y | grep -iv MT | sort | uniq`
        chrlistX=`awk '{print $2}' tmp_"$random"_CHRupdate.txt | grep -iv Y | grep -iv MT | sort | uniq | tr '\n' ' '`
        NX=`awk '{print $2}' tmp_"$random"_CHRupdate.txt | grep -iv Y | grep -iv MT | sort | uniq | wc | awk '{print $1}'`

        awk '{print $2}' tmp_"$random"_CHRupdate.txt | grep -iv Y | grep -iv MT | sort | uniq > tmp_"$random"_chrs.txt

        # Printing list of Chrs to Loop over
        echo "$chrlist"
        echo -e
        echo "$chrlistX"
        echo -e
        echo "$NX"
        echo -e
        echo "$xNAME"

        # Random Number (1-100) to track jobs
        XZ=`shuf -i1-100 -n1`


# Step 2: Writing out shell scrip to Loop through autosomal Chromosomes & Extract SNPs - using subset command via gtools

            xline="#SBATCH --array=1-$NX"            

            echo "#!/bin/bash"                                   > tmp_"$random"_job"$XZ".sh
            echo "#SBATCH -J SNPRet_$XZ"                           >> tmp_"$random"_job"$XZ".sh
            echo "#SBATCH --mem=32000"                              >> tmp_"$random"_job"$XZ".sh
            echo "#SBATCH -o ../out/job_retrieval$XZ.out"                    >> tmp_"$random"_job"$XZ".sh
            echo "#SBATCH --partition=carter-compute"                    >> tmp_"$random"_job"$XZ".sh
            echo "$xline"                                        >> tmp_"$random"_job"$XZ".sh 
            echo -e                                              >> tmp_"$random"_job"$XZ".sh
            echo "chrlistZ=($chrlistX)"                          >> tmp_"$random"_job"$XZ".sh
            echo "CHR=\${chrlistZ[\$(expr \$SLURM_ARRAY_TASK_ID - 1)]}"  >> tmp_"$random"_job"$XZ".sh
            echo -e                                              >> tmp_"$random"_job"$XZ".sh
            echo -e                                              >> tmp_"$random"_job"$XZ".sh
            echo "inBGEN=/cellar/controlled/ukb-genetic/imputation/ukb_imp_chr\"\$CHR""\"_v3.bgen" >> tmp_"$random"_job"$XZ".sh          
            echo "inSAMPLE=/cellar/controlled/ukb-genetic/imputation/ukb_imp_chr\"\$CHR""\"_v3.sample" >> tmp_"$random"_job"$XZ".sh          
            echo "outGEN=tmp_"$random"_x_\$CHR.bgen"                        >> tmp_"$random"_job"$XZ".sh 
            echo "outSAMPLE=tmp_"$random"_x_\$CHR.sample"                  >> tmp_"$random"_job"$XZ".sh 
            echo -e                                              >> tmp_"$random"_job"$XZ".sh  
            echo -e                                              >> tmp_"$random"_job"$XZ".sh  
            echo -e                                              >> tmp_"$random"_job"$XZ".sh  
            echo "/cellar/users/mpagadal/Programs/qctool_v2.0.1-Ubuntu14.04-x86_64/qctool -g \$inBGEN -s \$inSAMPLE -og \$outGEN -os \$outSAMPLE -incl-rsids tmp_"$random"_zSNPLIST " >> tmp_"$random"_job"$XZ".sh 

            sbatch tmp_"$random"_job"$XZ".sh

# STEP 3: Wait Point: checks if jobs are complete test if all jobs have finished
        c=1
        while [ $c -ne 0 ]
                do
                c=` squeue -o "%.50j" | grep -i  SNPRET_$XZ | wc -l`
                sleep 30
                done
        echo "Jobs Completed"

# NEW_STEP: Use cat-bgen to merge unlike previous method of using qctools

    sample_ar=$(ls tmp_"$random"_x_*.sample | sort | tr '\n' ',')

    bgen_ar=$(ls tmp_"$random"_x_*.bgen | sort | tr '\n' ',')


    IFS=', ' read -r -a sample_array <<< "$sample_ar"

    IFS=', ' read -r -a bgen_array <<< "$bgen_ar"

    cat_bg=$(ls tmp_"$random"_x_*.bgen | sort | tr '\n' ' ')

    # Check : to see if there is more than two array elements, if not, don't need to merge, but need to rename
    if [ ${#bgen_array[@]} == 1 ]
        then
        
        #rename sample and bgen array to final name
        echo "Only one chromosome input, no need to merge"
        cp "${bgen_array[0]}" "$xNAME"_"$xSAMPLE"_subset.bgen
        cp "${sample_array[0]}" "$xNAME"_"$xSAMPLE"_subset.sample

    else
        echo -e
        echo "Merging bgen files with cat-bgen"
        echo -e    
        
        /cellar/users/mpagadal/Programs/bgen_v1.1.4-Ubuntu16.04-x86_64/cat-bgen -g $cat_bg -og "$xNAME"_"$xSAMPLE"_subset.bgen
        cp "${sample_array[0]}" "$xNAME"_"$xSAMPLE"_subset.sample
    fi


    echo -e
    echo "------------------------Converting merged bgen to gen format and writing final files-----------------------------"
    echo -e

    /cellar/users/mpagadal/Programs/qctool_v2.0.1-Ubuntu14.04-x86_64/qctool -g "$xNAME"_"$xSAMPLE"_subset.bgen \
    -s "$xNAME"_"$xSAMPLE"_subset.sample \
    -og "$xNAME"_"$xSAMPLE"_subset.gen



# STEP 5X: REPEAT Compressing *gen & *sample format - ensures files are in consistent format/structure (avoid potential issues with gtool)

                echo "REPEAT Compressing *gen & *sample format, in consistent format for gtool  (avoid potential issues)"
                gzip "$xNAME"_"$xSAMPLE"_subset.sample
                gzip "$xNAME"_"$xSAMPLE"_subset.gen
                echo -e

# STEP 6: Converting impute2 dosages into single dosage value (follows structure of impute2 *gen file)
        echo "Converting impute2 dosages into single dosage value (follows structure of impute2 *gen file)"
	    python /cellar/users/mpagadal/scripts/impute2calcDosage.v2.py "$xNAME"_"$xSAMPLE"_subset.gen.gz   "$xNAME"_"$xSAMPLE"_subset.dosage.gz


# STEP 7: Convert to Plink formats 

        echo "Convert files to plink format"

        # Need to gunzip sample file first
        gunzip "$xNAME"_"$xSAMPLE"_subset.sample.gz

        /cellar/users/mpagadal/Programs/plink2 \
        --bgen  "$xNAME"_"$xSAMPLE"_subset.bgen ref-first \
        --sample "$xNAME"_"$xSAMPLE"_subset.sample \
        --make-bed \
        --out "$xNAME"_"$xSAMPLE"_subset


# STEP 8: gzip the files that are not already gzipped


        gzip "$xNAME"_"$xSAMPLE"_subset.sample 
        gzip "$xNAME"_"$xSAMPLE"_subset.bgen        


# STEP 9: Remove Intermediate Files   
# rm tmp_"$random"* 

