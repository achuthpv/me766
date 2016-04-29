#!/bin/bash
#sbatch --job-name=osu_test
#sbatch --output=osu_test-%j.out
#sbatch --error=osu_test-%j.err
#sbatch --nodes=2
#sbatch --ntasks-per-node=1
#sbatch --partition=debug

cd /home/sgopalak/133079005/achuth_test
MACHINE_FILE=hostfile;
echo $SLURM_JOB_NODELIST   >>  MACHINE_FILE;
/usr/local/slurm/bin/scontrol show hostnames $SLURM_JOB_NODELIST &> $SLURM_NODELIST;

#source /lscratch/intel/bin/compilervars.sh intel64
#source /lscratch/intel/bin/iccvars.sh intel64
#source /lscratch/intel/impi/5.0.1.035/bin64/mpivars.sh intel64
export PATH=/usr/mpi/gcc/mvapich2-1.8.1-qlc/bin:/usr/mpi/gcc/mvapich2-1.8.1-qlc/tests/osu_benchmarks-3.1.1/:$PATH
export LD_LIBRARY_PATH=/usr/mpi/gcc/mvapich2-1.8.1-qlc/lib:$LD_LIBRARY_PATH
export INCLUDE=/usr/mpi/gcc/mvapich2-1.8.1-qlc/include:$INCLUDE

#MACHINE_FILE=hostfile;
#echo $SLURM_JOB_NODELIST   >>  MACHINE_FILE;
#/usr/local/slurm/bin/scontrol show hostname $SLURM_JOB_NODELIST &> $SLURM_NODE_FILE;


#mpirun /home/sgopalak/133079005/a.out 2000

#time mpiexec -np 192 --machinefile $SLURM_NODE_FILE  /lscratch/benchmark/run/wrf.
mpirun -np 2 ibcompute11 ibcompute12 /usr/mpi/gcc/mvapich2-1.8.1-qlc/tests/osu_benchmarks-3.1.1/osu_latency
