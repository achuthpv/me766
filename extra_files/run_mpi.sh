#!/bin/bash
exec > ani_mpi.txt
mpicc -o matrix_mul_mpi matrix_mul_mpi.c
echo "For matrix multiplication with transposes"
echo ""
echo "timings for  code"
mpirun -n 2 ./matrix_mul_mpi 100 
mpirun -n 2 ./matrix_mul_mpi 500 
mpirun -n 2 ./matrix_mul_mpi 1000 
mpirun -n 2 ./matrix_mul_mpi 5000 
mpirun -n 2 ./matrix_mul_mpi 10000

mpirun -n 4 ./matrix_mul_mpi 100 
mpirun -n 4 ./matrix_mul_mpi 500 
mpirun -n 4 ./matrix_mul_mpi 1000 
mpirun -n 4 ./matrix_mul_mpi 5000 
mpirun -n 4 ./matrix_mul_mpi 10000

mpirun -n 8 ./matrix_mul_mpi 100 
mpirun -n 8 ./matrix_mul_mpi 500 
mpirun -n 8 ./matrix_mul_mpi 1000 
mpirun -n 8 ./matrix_mul_mpi 5000 
mpirun -n 8 ./matrix_mul_mpi 10000
