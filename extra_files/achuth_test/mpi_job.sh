#!/bin/bash


#SBATCH --ntasks-per-node=1
#SBATCH --error=test.%J.err
#SBATCH --output=test.%J.out
#SBATCH -n 2 
# Spread the tasks evenly among the nodes
#echo " program started"
cd /home/sgopalak/133079005/achuth_test
#sleep 5
##Importing variable for openmpi####
export I_MPI_CPUINFO=proc
export PATH=/opt/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi/lib:$LD_LIBRARY_PATH
export INCLUDE=/opt/openmpi/include:$INCLUDE

MACHINE_FILE=hostfile;
echo $SLURM_JOB_NODELIST   >>  MACHINE_FILE;
#/usr/local/slurm/bin/scontrol show hostname $SLURM_JOB_NODELIST &> $SLURM_NODE_FILE;

echo `scontrol show hostnames $SLURM_NODELIST`
mpiexec.hydra  -hostfile $MACHINE_FILE /home/sgopalak/133079005/achuth_test/a.out 1000
echo  `hostname`
#echo `cat $MACHINE_FILE`
#echo "My test is done"
