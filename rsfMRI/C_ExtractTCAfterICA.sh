#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../Z_Tools/fsl
MSKDIR=../../../Z_Tools/AALMasks
function rp {
    
    if [ ! -d $1/rsfMRI/B_ExtractedTCs ]; then
        mkdir $1/rsfMRI/B_ExtractedTCs
        mkdir $1/rsfMRI/B_ExtractedTCs/A_AAL2SubjectSpace
    fi    
    dirname=$2
    result=${dirname%%+(/)}    # trim however many trailing slashes exist
    result=${result##*/}
    result=$(echo $result | sed 's:/*$::')

    if [ ! -f $1/rsfMRI/B_ExtractedTCs/$result.txt ]; then
        echo "Processing subject: $1 . area $2"
        flirt -in $2 -ref $1/rsfMRI/A_PreprocOutput.feat/example_func.nii.gz -init $1/rsfMRI/A_PreprocOutput.feat/reg/standard2example_func.mat -applyxfm -out $1/rsfMRI/B_ExtractedTCs/A_AAL2SubjectSpace/$result\_func.nii.gz
        fslmaths $1/rsfMRI/B_ExtractedTCs/A_AAL2SubjectSpace/$result\_func.nii.gz -thr 0.5 -bin $1/rsfMRI/B_ExtractedTCs/A_AAL2SubjectSpace/$result\_func.nii.gz 
        fslmeants -i $1/rsfMRI/A_PreprocOutput.feat/filtered_func_data_clean.nii.gz -o $1/rsfMRI/B_ExtractedTCs/$result.txt -m $1/rsfMRI/B_ExtractedTCs/A_AAL2SubjectSpace/$result\_func.nii.gz
        echo "Finished processing of subject $1 , area $2. "
    fi
}

function pwait() {
    while [ $(jobs -p | wc -l) -ge $1 ]; do
        sleep 1
    done
}

N=2

for subjpath in $SUBDIR/*
do
    for maskpath in $MSKDIR/*
    do        
    	rp $subjpath $maskpath &
        pwait 2
    done
done

