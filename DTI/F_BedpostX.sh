#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../../Z_Tools/fsl
function rp {
    if [ ! -f $1/DTI/F_BedpostX ]; then
        mkdir $1/DTI/F_BedpostX
        mkdir $1/DTI/F_BedpostX/A_Input
        \cp $1/DTI/D_Eddy/data.nii.gz $1/DTI/F_BedpostX/A_Input/data.nii.gz       
        \cp $1/DTI/D_Eddy/data.eddy_rotated_bvecs $1/DTI/F_BedpostX/A_Input/bvecs
        \cp $1/DTI/Z_Original/bvals $1/DTI/F_BedpostX/A_Input/bvals
        \cp $1/DTI/D_Eddy/data.nii.gz $1/DTI/F_BedpostX/A_Input/data.nii.gz
        \cp $1/DTI/A_BrainExtraction/nodif_brain_mask.nii.gz $1/DTI/F_BedpostX/A_Input/nodif_brain_mask.nii.gz
        echo "Processing subject: $1 . "    
        $FSLDIR/bin/bedpostx $1/DTI/F_BedpostX/A_Input --nf=3 --fudge=1  --bi=1000
        echo "BedpostX for $1 finished. "  

        echo "Running registration for $1"
        \cp $1/DTI/A_BrainExtraction/nodif_brain.nii.gz $1/DTI/F_BedpostX/A_Input.bedpostX/nodif_brain.nii.gz
        $FSLDIR/bin/flirt -in $1/DTI/F_BedpostX/A_Input.bedpostX/nodif_brain -ref $1/DTI/A_BrainExtraction/anat_t1_brain.nii.gz -omat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/diff2str.mat -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12 -cost corratio
        $FSLDIR/bin/convert_xfm -omat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/str2diff.mat -inverse $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/diff2str.mat
        $FSLDIR/bin/flirt -in $1/DTI/A_BrainExtraction/anat_t1_brain.nii.gz -ref $FSLDIR/data/standard/MNI152_T1_2mm_brain -omat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/str2standard.mat -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12 -cost corratio
        $FSLDIR/bin/convert_xfm -omat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/standard2str.mat -inverse $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/str2standard.mat
        $FSLDIR/bin/convert_xfm -omat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/diff2standard.mat -concat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/str2standard.mat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/diff2str.mat
        $FSLDIR/bin/convert_xfm -omat $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/standard2diff.mat -inverse $1/DTI/F_BedpostX/A_Input.bedpostX/xfms/diff2standard.mat

        echo "Registration for $1 finished"
    fi

}

for subjpath in $SUBDIR/*
do
    rp $subjpath &
done
