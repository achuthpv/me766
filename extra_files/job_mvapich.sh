#!/bin/bash

#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --error=ani_mvapich.%J.err
#SBATCH --output=ani_mvapich.%J.out

echo " program started"
cd /home/sgopalak/133079005/
sleep 5
##Importing variable for openmpi####
export I_MPI_CPUINFO=proc
export PATH=/home/sgopalak/mvapich2new/bin:$PATH
export LD_LIBRARY_PATH=/home/sgopalak/mvapich2new/lib:$LD_LIBRARY_PATH
export INCLUDE=/home/sgopalak/mvapich2new/include:$INCLUDE

MACHINE_FILE=hostfile;
echo $SLURM_JOB_NODELIST  >  MACHINE_FILE;
#/usr/local/slurm/bin/scontrol show hostname $SLURM_JOB_NODELIST &> $SLURM_NODE_FILE;

mpirun -np 2 -hostfile MACHINE_FILE /home/sgopalak/133079005/a.out 2000
cat MACHINE_FILE
echo "My test is done"
