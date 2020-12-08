#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
FSLDIR=../../../../Z_Tools/fsl
function rp {
    if [ ! -d $1/DTI/G_ProbtrackX ]; then
        mkdir $1/DTI/G_ProbtrackX
    fi
    if [ ! -d $1/DTI/G_ProbtrackX/seed_$2 ]; then
        mkdir $1/DTI/G_ProbtrackX/seed_$2
        \cp ../../masks.txt $1/DTI/G_ProbtrackX/seed_$2/masks.txt

        echo "Processing subject: $1 , seed $2 " 
        $FSLDIR/bin/probtrackx2 --network -x $1/DTI/G_ProbtrackX/seed_$2/masks.txt -l --onewaycondition --omatrix1 -c 0.2 -S 2000 --steplength=0.5 -P 50 --rseed=$2 --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --xfm=$1/DTI/F_BedpostX/A_Input.bedpostX/xfms/standard2diff.mat --forcedir --opd --ompl -s $1/DTI/F_BedpostX/A_Input.bedpostX/merged -m $1/DTI/F_BedpostX/A_Input.bedpostX/nodif_brain_mask --dir=$1/DTI/G_ProbtrackX/seed_$2 
           
        echo "ProbtrackX for $1, seed $2 finished. "  
    fi

}

N=35 #Number of processes to run at a time

for subjpath in $SUBDIR/*
do
    for seed in {1..100}
    do
        ((i=i%N)); ((i++==0)) && wait
        rp $subjpath $seed &        
    done
done
