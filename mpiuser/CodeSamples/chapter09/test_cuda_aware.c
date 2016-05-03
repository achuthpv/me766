#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <sys/time.h>
#include <mpi.h>

#define NREPEAT 10
#define NBYTES 10.e6

int main (int argc, char *argv[])
{
int rank, size, n, len, numbytes;
void *a_h, *a_d;
struct timeval time[2];
double bandwidth;
char name[MPI_MAX_PROCESSOR_NAME];
MPI_Status status;

MPI_Init (&argc, &argv);
MPI_Comm_rank (MPI_COMM_WORLD, &rank);
MPI_Comm_size (MPI_COMM_WORLD, &size);

MPI_Get_processor_name(name, &len);
printf("Process %d is on %s\n", rank, name);

printf("Using regular memory \n");
a_h = malloc(NBYTES);

cudaMalloc( (void **) &a_d, NBYTES);

/* Test host -> device bandwidth. */
MPI_Barrier(MPI_COMM_WORLD);

gettimeofday(&time[0], NULL);
for (n=0; n<NREPEAT; n )
{
cudaMemcpy(a_d, a_h, NBYTES, cudaMemcpyHostToDevice);
}
gettimeofday(&time[1], NULL);

bandwidth = time[1].tv_sec - time[0].tv_sec;
bandwidth = 1.e-6*(time[1].tv_usec - time[0].tv_usec);
bandwidth = NBYTES*NREPEAT/1.e6/bandwidth;

printf("Host->device bandwidth for process %d: %f MB/sec\n",rank,bandwidth);

/* Test MPI send/recv bandwidth. */
MPI_Barrier(MPI_COMM_WORLD);

gettimeofday(&time[0], NULL);
for (n=0; n<NREPEAT; n )
{
if (rank == 0)
MPI_Send(a_h, NBYTES/sizeof(int), MPI_INT, 1, 0, MPI_COMM_WORLD);
else
MPI_Recv(a_h, NBYTES/sizeof(int), MPI_INT, 0, 0, MPI_COMM_WORLD, &status);
}
gettimeofday(&time[1], NULL);

bandwidth = time[1].tv_sec - time[0].tv_sec;
bandwidth = 1.e-6*(time[1].tv_usec - time[0].tv_usec);
bandwidth = NBYTES*NREPEAT/1.e6/bandwidth;

if (rank == 0)
printf("MPI send/recv bandwidth: %f MB/sec\n", bandwidth);

cudaFree(a_d);
free(a_h);

MPI_Finalize();
return 0;
} 