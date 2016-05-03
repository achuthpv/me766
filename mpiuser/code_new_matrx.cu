#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#define ThreadSize 16
__global__ void MatMulKernel( int *dD, int *dE, int *dF, int N ) {
	int Fvalue = 0;
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;

	if ( row < (N/2) && col < (N/2) ) {
	

	for ( int i=0; i<(N); i++ ) {
          Fvalue+= dD[(row)*(N)+i] * dE[i*(N/2)+col];
	}

	dF[row*(N/2)+col]=Fvalue;
	}
}

extern "C" int CUDA_stuff(int *D, int *E, int *F, int N )
{

	int i, j;
	
cudaEvent_t start, stop;
cudaEventCreate(&start);
cudaEventCreate(&stop);
	cudaError_t err;
//	printf ( "N = %d\n", N );
	
	int *dD, *dE, *dF;
//	if(my_rank==0){
/* printf("E Matrix is");
        
        for(i=0;i<(N/2);i++){
             for(j=0;j<(N/2);j++){
                  printf("~%d ",E[i*(N/2)+j]);
                }
                  printf("\n");
                }

printf("D Matrix is");
	        for(i=0;i<(N/2);i++){
                     for(j=0;j<(N/2);j++){
                        printf("~%d ",D[i*(N/2)+j]);
                        }
                          printf("\n");
                        }
//}*/
// Allocate the memory on the GPU
   cudaEventRecord(start,0);
	
	err = cudaMalloc ( (void**) &dD, (N/2)*(N)*sizeof(int));
//	printf ( "CUDA malloc dD: %s\n", cudaGetErrorString(err));
	err = cudaMalloc ((void**) &dE, (N/2)*(N)*sizeof(int));
//	printf ( "CUDA malloc dE: %s\n", cudaGetErrorString(err));
	err = cudaMalloc ((void**) &dF, (N/2)*(N/2)*sizeof(int));
//	printf ( "CUDA malloc dF: %s\n", cudaGetErrorString(err));
	
	// Copy the memory to the GPU.
	err = cudaMemcpy(dD, D, (N/2)*(N)*sizeof(int), cudaMemcpyHostToDevice );
//	printf ( "Copy D to device: %s\n", cudaGetErrorString(err));
	err = cudaMemcpy(dE, E, (N/2)*(N)*sizeof(int), cudaMemcpyHostToDevice );
//	printf ( "Copy E to device: %s\n", cudaGetErrorString(err));
	err = cudaMemcpy(dF, F, (N/2)*(N/2)*sizeof(int), cudaMemcpyHostToDevice );
//	printf ( "Copy F to device: %s\n", cudaGetErrorString(err));
/*         
        for(i=0;i<(N/2);i++){
          for(j=0;j<(N/2);j++){
         printf("%d ",D[i*(N/2)+j]);
}
printf("\n");
}*/
	dim3 dimBlock(ThreadSize,ThreadSize,1);
	dim3 dimGrid(((N/ThreadSize)+1),((N/ThreadSize)+1),1);
	
	// Perform the operation on the GPU
	
	MatMulKernel <<< dimGrid, dimBlock >>> (dD, dE, dF, N);
	
	// Copy back the results from the GPU to the CPU
	
	err = cudaMemcpy ( F, dF, (N/2)*(N/2)*sizeof(int), cudaMemcpyDeviceToHost );
//	printf ( "Copy F off of device %s\n", cudaGetErrorString(err) );

		

cudaEventRecord(stop,0);
cudaEventSynchronize(stop);
float GPUelapsed;
cudaEventElapsedTime(&GPUelapsed,start,stop);

//printf("\n\nGPU Elapsed time:%f\n\n",GPUelapsed);




/*	for ( i=0; i<N/2; i++ ) {
		for ( j=0; j<N/2; j++ ) {
			printf ( "%3d ", F[i*N/2+j] );
		}
		printf ( "\n" );
	}
	printf ( "\n" );
*/
	printf ( "Success!\n" );
	
	return(0);
}



