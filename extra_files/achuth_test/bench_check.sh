#!/bin/bash

#SBATCH --nodes=2
#SBATCH --time=20:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --error=test.%J.err
#SBATCH --output=test.%J.out


echo " program started"
cd /home/sgopalak/133079005/
sleep 5
##Importing variable for openmpi####
export PATH=/usr/mpi/gcc/openmpi-1.8.1-qlc/bin:$PATH
export LD_LIBRARY_PATH=/usr/mpi/gcc/openmpi-1.8.1-qlc/lib:$LD_LIBRARY_PATH
export INCLUDE=/usr/mpi/gcc/openmpi-1.8.1-qlc/include:$INCLUDE

MACHINE_FILE=hostfile;
echo $SLURM_JOB_NODELIST   >>  MACHINE_FILE;
/usr/local/slurm/bin/scontrol show hostname $SLURM_JOB_NODELIST &> $SLURM_NODE_FILE;


mpirun /home/sgopalak/133079005/a.out 2000

echo "My test is done"
