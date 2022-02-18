# Run_PSMC

This repo has a set of scripts to run and plot a PSMC run from a genome and list of bam files
The scripts will produce a number of .txt files which can be exectued on a cluster in parallel using `parallel`

First make sure `psmc` is installed or install `psmc`:  
```
git clone https://github.com/lh3/psmc  
cd psmc && make; (cd utils; make)
```

Part 1: Get consensus `.fq` files - `psmc_fq_prepare.sh`  
Part 2: Get `.psmcfa` files - `psmc_psmcfa_prepare.sh`  
Part 3: Run psmc to get `.psmc` output - `psmc_psmc_prepare.sh`  

____

A typical run will look something like:  

Get a list of `.bam` files (i.e. one per line - example provided):  
```
ls *.bam > bam.test.list  
```

#load conda environment  
```
sconda /ceph/users/rdekayne/.conda/envs/genomics_general/
```

#check queue
```
qstat -f -u "*"
```  

#first move onto a node with no jobs e.g. c2
```
ssh c2
```  

#make a folder here for psmc
```
mkdir -p /scratch/$USER/psmc && cd /scratch/$USER/psmc
```  

#copy genome here
```
cp /data/martin/genomics/analyses/Danaus_genome/Dchry2/Dchry2.2.fa .
cp /data/martin/genomics/analyses/Danaus_genome/Dchry2/Dchry2.2.fa.fai .
```  

#now exit the cluster  
```
exit
```  

#to deactivate conda env for any reason use `dconda`

1. Prepare `.fq` files by specifying the `genome`, `list of bam files`, `current dir`, and `outpur dir`:  
```
#this command will run the .sh script and will produce a .txt file that includes commands to make the .fq files
./psmc_all_prepare.sh /scratch/rdekayne/psmc_full/Dchry2.2.fa bam.test.list /data/martin/genomics/analyses/Danaus_popgen/StHelena_project/psmc /scratch/rdekayne/psmc_full  

#take a look in the Get.all.fq.txt to see what these commands look like:
head Get.all.fq.txt

#this command will then use parallel to submit this list of commands, running one job for each of the bam files in the list in parallel - producing .fq files for each
parallel -j 1 'qsub -cwd -N psmc_prep -V -pe smp64 1 -l h=c2 -b yes {}' :::: Get.all.fq.txt  
```  

2. Next prepare `.psmcfa` files from these `.fq` files:  
```
./psmc_psmcfa_prepare.sh /scratch/rdekayne/psmc_full/Dchry2.2.fa bam.test.list /data/martin/genomics/analyses/Danaus_popgen/StHelena_project/psmc /scratch/rdekayne/psmc_full

parallel -j 1 'qsub -cwd -N psmc_prep -V -pe smp64 1 -l h=c2 -b yes {}' :::: Get.all.psmcfa.txt  
```  

3. Run psmc and get `.psmc` files which can be plotted:  
```
./psmc_psmc_prepare.sh /scratch/rdekayne/psmc_full/Dchry2.2.fa bam.test.list /data/martin/genomics/analyses/Danaus_popgen/StHelena_project/psmc /scratch/rdekayne/psmc_full

parallel -j 1 'qsub -cwd -N psmc_run -V -pe smp64 1 -l h=c2 -b yes {}' :::: Get.all.psmc.txt
```
