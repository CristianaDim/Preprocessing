#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../../Z_Tools/fsl
function rp {
    if [ ! -d $1/DTI/C_Dtifit ]; then
        mkdir $1/DTI/C_Dtifit        
        echo "Processing subject: $1 . " 
        \cp $1/DTI/B_FieldmapCorrection.feat/filtered_func_data.nii.gz $1/DTI/C_Dtifit/data.nii.gz
        $FSLDIR/bin/dtifit --data=$1/DTI/C_Dtifit/data.nii.gz --out=$1/DTI/C_Dtifit/dti --mask=$1/DTI/A_BrainExtraction/nodif_brain_mask.nii.gz --bvecs=$1/DTI/Z_Original/bvecs --bvals=$1/DTI/Z_Original/bvals --save_tensor
        echo "DTI fit for $1 finished. "  
    fi

}

for subjpath in $SUBDIR/*
do
    rp $subjpath &
done
