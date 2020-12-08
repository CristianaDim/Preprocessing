#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../../Z_Tools/fsl
function rp {
    if [ ! -f $1/DTI/E_Dtifit ]; then
        mkdir $1/DTI/E_Dtifit        
        echo "Processing subject: $1 . "         
        $FSLDIR/bin/dtifit --data=$1/DTI/D_Eddy/data.nii.gz --out=$1/DTI/E_Dtifit/dti --mask=$1/DTI/A_BrainExtraction/nodif_brain_mask.nii.gz --bvecs=$1/DTI/D_Eddy/data.eddy_rotated_bvecs --bvals=$1/DTI/Z_Original/bvals --save_tensor
        echo "DTI fit for $1 finished. "  
    fi

}

for subjpath in $SUBDIR/*
do
    rp $subjpath &
done
