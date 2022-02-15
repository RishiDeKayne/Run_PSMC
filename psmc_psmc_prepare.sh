#!/bin/bash

#De-Kayne 2022
#first make sure reference fasta and bam are copied to current directory
#usage: psmc_psmc_prepare.sh genome bamlist current_dir output_dir
# e.g. psmc_psmc_prepare.sh Dchry2.2.fa bam.list /data/martin/genomics/analyses/Danaus_popgen/StHelena_project/psmc /scratch/rdekayne/psmc_full

#run after loading genomics_general conda env with 'sconda genomics_general'

#--------------------------------
GENOME=$1
BAM_LIST=$2
OUT_DIR=$3
WORK_DIR=$4

cat ${BAM_LIST} | while read line
do
        echo 'processing' ${line}
        #get sample name
        echo ${line} > name.txt
        sed -i 's/\/data\/martin\/genomics\/analyses\/Danaus_mapping\///g' name.txt
                                                                                        
        cat name.txt | while read name
do
        #get psmcfa
        echo '/data/martin/genomics/analyses/Danaus_popgen/psmc/test/psmc/psmc -N20 -t15 -r5 -p "4+25*2+4+6" -o '${WORK_DIR}'/'${name}'.psmc '${WORK_DIR}'/'${name}'.psmcfa && rsync '${WORK_DIR}'/'${name}'.psmc '${OUT_DIR} >> ${OUT_DIR}/Get.all.psmc.txt
done
done
