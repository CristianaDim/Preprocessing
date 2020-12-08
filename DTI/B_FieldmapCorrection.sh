#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../../Z_Tools/fsl
function rp {
    if [ ! -d $1/DTI/B_FieldmapCorrection.feat ]; then
        # Transform T1 image to radiological orientation (same orientation as all other images)
        $FSLDIR/bin/fslswapdim $1/DTI/A_BrainExtraction/anat_t1_brain -x y z $1/DTI/A_BrainExtraction/anat_t1_brain
        $FSLDIR/bin/fslorient -swaporient $1/DTI/A_BrainExtraction/anat_t1_brain
        $FSLDIR/bin/fslswapdim $1/DTI/A_BrainExtraction/anat_t1_brain_mask -x y z $1/DTI/A_BrainExtraction/anat_t1_brain_mask
        $FSLDIR/bin/fslorient -swaporient $1/DTI/A_BrainExtraction/anat_t1_brain_mask
        $FSLDIR/bin/fslswapdim $1/DTI/A_BrainExtraction/anat_t1_brain_overlay -x y z $1/DTI/A_BrainExtraction/anat_t1_brain_overlay
        $FSLDIR/bin/fslorient -swaporient $1/DTI/A_BrainExtraction/anat_t1_brain_overlay
        $FSLDIR/bin/fslswapdim $1/DTI/A_BrainExtraction/anat_t1_brain_skull -x y z $1/DTI/A_BrainExtraction/anat_t1_brain_skull
        $FSLDIR/bin/fslorient -swaporient $1/DTI/A_BrainExtraction/anat_t1_brain_skull

        $FSLDIR/bin/fsl_prepare_fieldmap SIEMENS $1/DTI/Z_Original/fieldmap_phase $1/DTI/A_BrainExtraction/fieldmap_magnitude_1_brain $1/DTI/Z_Original/fieldmap_rads 2.46
        \cp tmpDesign.fsf $1_design.fsf
        or='../../B_Data/C_FSLPreproc/subj/'
        rp=$1 
        echo "Processing subject: $1 . " 
        sed -i "s~$or~$rp/~" $1_design.fsf
        $FSLDIR/bin/feat $1_design.fsf
        echo "Fieldmap correction for $1 finished. "  
        echo "Create and extract b0 image"
        $FSLDIR/bin/fslroi $1/DTI/B_FieldmapCorrection.feat/filtered_func_data $1/DTI/Z_Original/nodif 0 1
        $FSLDIR/bin/bet $1/DTI/Z_Original/nodif $1/DTI/A_BrainExtraction/nodif_brain -f 0.22 -g 0.0 -o -m -s
    fi

}

for subjpath in $SUBDIR/*
do
    rp $subjpath &
done
