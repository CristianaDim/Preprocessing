#!/bin/bash

SUBDIR=../../B_Data/C_FSLPreproc
threshold_input=./Threshold_In_anat.txt
FSLDIR=../../../../Z_Tools/fsl
function rp {
    echo "Processing subject: $1 . "   

    if [ ! -d $SUBDIR/$1/DTI/A_BrainExtraction ]; then
        mkdir -p $SUBDIR/$1/DTI/A_BrainExtraction/ 
    fi

    if [ ! -f $SUBDIR/$1/DTI/A_BrainExtraction/anat_t1_brain.nii.gz ]; then
        $FSLDIR/bin/bet $SUBDIR/$1/DTI/Z_Original/anat_t1 $SUBDIR/$1/DTI/A_BrainExtraction/anat_t1_brain_$2 -B -f $2 -g 0.05 -o -m -s >> $3
    fi

    if [ ! -f $SUBDIR/$1/DTI/Z_Original/nodif.nii.gz ]; then
        $FSLDIR/bin/fslroi $SUBDIR/$1/DTI/Z_Original/data $SUBDIR/$1/DTI/Z_Original/nodif 0 1 >> $3
    fi

    if [ ! -f $SUBDIR/$1/DTI/A_BrainExtraction/nodif_brain.nii.gz ]; then
        $FSLDIR/bin/bet $SUBDIR/$1/DTI/Z_Original/nodif $SUBDIR/$1/DTI/A_BrainExtraction/nodif_brain -f 0.22 -g 0.0 -o -m -s >> $3
    fi

    if [ ! -f $$SUBDIR/1/DTI/A_BrainExtraction/fieldmap_magnitude_1_brain.nii.gz ]; then
        $FSLDIR/bin/bet $SUBDIR/$1/DTI/Z_Original/fieldmap_magnitude_1 $SUBDIR/$1/DTI/A_BrainExtraction/fieldmap_magnitude_1_brain -f 0.70 -g 0.15 -o -m -s >> $3
        $FSLDIR/bin/fslmaths $SUBDIR/$1/DTI/A_BrainExtraction/fieldmap_magnitude_1_brain -ero fieldmap_magnitude_1_brain_ero_$2 >> $3
    fi

    if [ ! -f $SUBDIR/$1/DTI/A_BrainExtraction/fieldmap_magnitude_2_brain.nii.gz ]; then
        $FSLDIR/bin/bet $SUBDIR/$1/DTI/Z_Original/fieldmap_magnitude_2 $SUBDIR/$1/DTI/A_BrainExtraction/fieldmap_magnitude_2_brain -f 0.70 -g 0.15 -o -m -s  >> $3  
        $FSLDIR/bin/fslmaths $SUBDIR/$1/DTI/A_BrainExtraction/fieldmap_magnitude_2_brain -ero fieldmap_magnitude_2_brain_ero >> $3
    fi

    echo "Brain extraction for $1 finished. "    
}

function pwait {
    while [ "$(jobs -p | wc -l)" -ge $1 ]; do	#jobs -p specifies the PID of the jobs executed at the moment. wc -l returns the number of lines. 
        echo "Waiting to continue."
	sleep 10									#Delays the continuation for 10 seconds
    done
}

function brain_ex_qc_loop { 			#Takes file where pat_num and threshold are registered and runs brain_ex_qc on these. 
	echo "Brain extraction quality check has started. The input list of subjects and thresholds is saved under $1"
	threshold_output="$(echo $1 | sed 's/In/Out/')"		#Defines the output file were all thresholds are saved
	while IFS= read -r line; do
		if [ "$(echo $line | wc -w)" -gt 0 ]; then  
			subjpath="$(echo "$line" | cut -f 1)" 		#Takes the ith value of the first line.
			threshold="$(echo "$line" | cut -f 2)" 		#Takes the ith value of the last line. 
			rp $subjpath $threshold $threshold_output &
			pwait 15
		fi
	done < "$1"
}

brain_ex_qc_loop "$threshold_input"



