#include<cuda.h>
#include<cuda_runtime.h>

__global__ void __multiply__(float *d_A,float *d_B,float *d_C,int N){

   int row=threadIdx.y+blockIdx.y*blockDim.y;
   int col=threadIdx.x+blockIdx.x*blockDim.y;


if(col<N && row<N){

            float sum=0;
        for(int i=0;i<N;i++){
       sum +=d_A[row*N+i]*d_B[i*N+col];
     
 }       
    d_C[row*N+col]=sum;
}

}

extern "C" void launch_multiply(float *d_A,float *d_B,float *d_C,int N)
{
  ,

}
