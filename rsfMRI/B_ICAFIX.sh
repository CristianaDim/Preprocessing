#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../Z_Tools/fsl
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FSLDIR
function rp {
    if [ ! -f $1/rsfMRI/A_PreprocOutput.feat/fix4melview_Standard_thr20.txt ]; then
        
        echo "Processing subject: $1 . " 

        /opt/fix/fix -c $1/rsfMRI/A_PreprocOutput.feat/ /opt/fix/training_files/Standard.RData 20
        /opt/fix/fix -a $1/rsfMRI/A_PreprocOutput.feat/fix4melview_Standard_thr20.txt
        echo "rsfMRI preprocessing for $1 finished. "  

    fi

}

function pwait() {
    while [ $(jobs -p | wc -l) -ge $1 ]; do
        sleep 1
    done
}

for subjpath in $SUBDIR/*
do
    rp $subjpath &
    pwait 2
done

