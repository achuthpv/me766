#!/bin/bash
exec > ani.txt

#compile code serially and execute
mpicc -o matrix_mul_serial matrix_mul.c
echo "For matrix multiplication without transposes"
echo ""
echo "timings for serial code"

./matrix_mul_serial 100 500 1000 

#compile code with openmp
export OMP_NUM_THREADS=4

mpicc -fopenmp -o matrix_mul_openmp matrix_mul.c
echo ""
echo ""
echo "timings for code with openemp"
echo ""
echo ""
./matrix_mul_openmp 100 500 1000
printenv | grep OMP_NUM_THREADS

#compile code serially and execute
mpicc -o matrix_mul_transpose_serial matrix_mul_transpose.c
echo "For matrix multiplication with transposes"
echo ""
echo "timings for serial code"
./matrix_mul_transpose_serial 100 500 1000
#compile code with openmp
export OMP_NUM_THREADS=4
mpicc -fopenmp -o matrix_mul_transpose_openmp matrix_mul_transpose.c
echo ""
echo ""
echo "timings for code with openemp"
echo ""
echo ""
./matrix_mul_transpose_openmp 100 500 1000
printenv | grep OMP_NUM_THREADS

