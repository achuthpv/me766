#!/bin/bash


#SBATCH --error=mva.%J.err
#SBATCH --output=mva.%J.out
# Spread the tasks evenly among the nodes
#echo " program started"
cd /home/sgopalak/133079005/achuth_test
#sleep 5
##Importing variable for openmpi####
export I_MPI_CPUINFO=proc
export PATH=/home/sgopalak/mvapich2new/bin:/opt/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/opt/openmpi/lib:/home/sgopalak/mvapich2new/lib:$LD_LIBRARY_PATH
export INCLUDE=/opt/openmpi/include:/home/sgopalak/mvapich2new/include:$INCLUDE

#MACHINE_FILE=hostfile;
echo $SLURM_JOB_NODELIST   >  MACHINE_FILE;
/usr/local/slurm/bin/scontrol show hostname $SLURM_JOB_NODELIST &> $SLURM_NODE_FILE;

#echo `scontrol show hostnames $SLURM_NODELIST`
/home/sgopalak/mvapich2new/bin/mpirun -np 3  --host compute07 /home/sgopalak/133079005/achuth_test/mvapich.out 1000

#echo  `hostname`
#echo `cat $MACHINE_FILE`
#echo "My test is done"
