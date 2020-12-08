#!/bin/bash


SUBDIR=../../B_Data/C_FSLPreproc

ls $SUBDIR >> Threshold_In_SubjList.txt

sed -i '/Threshold_In_SubjList.txt/d' ./Threshold_In_SubjList.txt

INPUT=./Threshold_In_SubjList.txt

while IFS= read -r line; do
     
          for i in `seq 0.1 0.01 0.3`;
          do
               string="$line	$i"
               echo $string >> Threshold_In_anat.txt
          done
     
done < $INPUT

