#include <mpi.h>
int main( int argc, char *argv[] )
{
  int rank,npes;
  float *ptr = NULL;
  float *pt=NULL;
  const size_t elements = 32;
  MPI_Status status;

  MPI_Init( &argc, &argv );
  MPI_Comm_rank( MPI_COMM_WORLD, &rank );
  cudaMalloc( (void**)&ptr, elements * sizeof(float) );
  cudaMalloc( (void**)&pt, elements * sizeof(float) );
  if( rank == 0 ){
    MPI_Send( ptr, elements, MPI_FLOAT, 1, 0, MPI_COMM_WORLD );
    MPI_Recv( pt, elements, MPI_FLOAT, 1, 0, MPI_COMM_WORLD, &status );
  }
  if( rank == 1 ){
    MPI_Recv( ptr, elements, MPI_FLOAT, 0, 0, MPI_COMM_WORLD, &status );
    MPI_Send( pt, elements, MPI_FLOAT, 0, 0, MPI_COMM_WORLD );
  }
  cudaFree( ptr );
  cudaFree(pt);
  MPI_Finalize();

  return 0;
}
