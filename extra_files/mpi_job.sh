#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --error=ani.%J.err
#SBATCH --output=ani.%J.out

echo " program started"
cd /home/sgopalak/133079005/
sleep 5
##Importing variable for openmpi####
export I_MPI_CPUINFO=proc
export PATH=/opt/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi/lib:$LD_LIBRARY_PATH
export INCLUDE=/opt/openmpi/include:$INCLUDE

MACHINE_FILE=hostfile;
echo $SLURM_JOB_NODELIST   >  MACHINE_FILE;
/usr/local/slurm/bin/scontrol show hostname $SLURM_JOB_NODELIST &> $SLURM_NODE_FILE;

mpirun -hostfile MACHINE_FILE /home/sgopalak/133079005/a.out 1000
cat MACHINE_FILE
echo "My test is done"
