~/openmpinew/bin/mpicc -c code_new_matrx.c -o code_new_matrx_c.o
nvcc -c code_new_matrx.cu -o code_new_matrx_cu.o
~/openmpinew/bin/mpicc code_new_matrx_c.o code_new_matrx_cu.o -L/usr/local/cuda-6.5/lib64 -lcudart -o mpi_cuda
