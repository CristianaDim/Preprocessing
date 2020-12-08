#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../../Z_Tools/fsl
function rp {
    if [ ! -f $1/DTI/D_Eddy ]; then
        mkdir $1/DTI/D_Eddy       
        echo "Processing subject: $1 . " 
        $FSLDIR/bin/eddy_openmp --imain=$1/DTI/C_Dtifit/data.nii.gz --mask=$1/DTI/A_BrainExtraction/nodif_brain_mask.nii.gz --bvals=$1/DTI/Z_Original/bvals --bvecs=$1/DTI/Z_Original/bvecs --acqp=$1/DTI/Z_Original/acqparams.txt --index=$1/DTI/Z_Original/index.txt --out=$1/DTI/D_Eddy/data --ref_scan_no=0 --ol_nstd=4 --verbose
        echo "Eddy correction for $1 finished. "  
    fi

}

for subjpath in $SUBDIR/*
do
    rp $subjpath &
done

