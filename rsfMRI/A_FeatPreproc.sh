#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../Z_Tools/fsl
function rp {
    if [ ! -d $1/rsfMRI/A_PreprocOutput.feat ]; then
        #mkdir $1/rsfMRI/A_PreprocOutput
        dirname=$1
        result=${dirname%%+(/)}    # trim however many trailing slashes exist
        result=${result##*/}
        result=$(echo $result | sed 's:/*$::')        

        \cp rsfMRI.fsf $result\_design.fsf
        or='../../B_Data/C_FSLPreproc/subj/'
	#string to replace
        rp=$1 
        echo "Processing subject: $1 . " 
        sed -i "s~$or~$rp/~" $result\_design.fsf
        feat $result\_design.fsf
        echo "rsfMRI preprocessing for $1 finished. "  
        #rm $1/rsfMRI/A_PreprocOutput
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
