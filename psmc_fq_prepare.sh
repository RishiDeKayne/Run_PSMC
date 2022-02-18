#!/bin/bash

#De-Kayne 2022

#usage: psmc_fq_prepare.sh genome bam.list current_dir output_dir
# e.g. psmc_fq_prepare.sh Dchry2.2.fa bam.list /data/martin/genomics/analyses/Danaus_popgen/StHelena_project/psmc /scratch/rdekayne/psmc_full

#run after loading genomics_general conda env with 'sconda genomics_general'
#also run chmod+x and the script name to make executible

#--------------------------------
#this line defines a number of variables based on the 'values' provided when you execute the command
GENOME=$1
BAM_LIST=$2
OUT_DIR=$3
WORK_DIR=$4

#this command will run a loop which goes through the list of bam files - extracts things like the bam name and location
#and then 'echos' these and a number of commands into a text file which we can then run on the cluster in parallel - one job per bam file
cat ${BAM_LIST} | while read line
do
        echo 'processing' ${line}
        #get sample name
        echo ${line} > name.txt
        sed -i 's/\/data\/martin\/genomics\/analyses\/Danaus_mapping\///g' name.txt
        
        cat name.txt | while read name
do
        #get fq
        echo 'samtools mpileup -C50 -u -f '${GENOME}' '${line}' | bcftools call -c | vcfutils.pl vcf2fq -d 5 -D 350 > '${WORK_DIR}'/'${name}'.fq' >> ${OUT_DIR}/Get.all.fq.txt
done
done
