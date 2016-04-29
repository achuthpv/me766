//#define		N	1000
#define		UL	10		       /* Max size of the float point number */
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h> 
int main(int argc,char *argv[])
{
  if (argc < 2) printf ("please enter right arguments");
  int h,i, j, k, N;
// to avoid confusion always use i for rows and j for columns.
  float **A, **B_transpose; 
  double **C, sum = 0 ,start,start_compute, end_compute, end;
  for (h=1; h< argc; h++){
  N = atoi(argv[h]);
  printf("\nFor N = %d\n", N);
  //scanf("%d", &N);
  // timer start for entire program
  start = MPI_Wtime(); 
  
  //dynamic memory alloctaion for all the matrices  
  A = (float **)malloc(N * sizeof(float));
  for (i = 0; i < N; i ++)
	A[i] = (float *)malloc(N * sizeof(float));

  B_transpose = (float **)malloc(N * sizeof(float));
  for (i = 0; i < N; i ++)
	B_transpose[i] = (float *)malloc(N * sizeof(float));

  C = (double **)malloc(N * sizeof(double));
  for (i = 0; i < N; i ++)
	C[i] = (double *)malloc(N * sizeof(double));

//random matrix generation 
  for (i = 0; i < N; i++)
    for (j = 0; j < N; j++)
     	A[i][j] = i+j+2;//(float)rand()/(float)(RAND_MAX/UL);
	
    //printf("Enter the elements of second matrix\n");
 
    for (i = 0; i < N; i++)
      for (j = 0; j < N; j++)
// Matrix generated and saved as transpose for easier multiplication
        B_transpose[i][j] =(i+1)(j+1) ;//(float)rand()/(float)(RAND_MAX/UL);

    //MPI timer for computation started at this point
    start_compute = MPI_Wtime();
    
//perform Matrix Multiplication
   #pragma omp parallel for private(j,k,sum) 
   for (i = 0; i < N; i++) {
      for (j = 0; j < N; j++) {
        for (k = 0; k < N; k++)
          sum = sum + A[i][k]*B_transpose[j][k];
	C[i][j] = sum;
        sum = 0;
      }
   }
    end_compute = MPI_Wtime();
   printf("Product of entered matrices:-\n");
 
    for (i = 0; i < N; i+=(N/10)) {
      for (j = 0; j < N; j++)
        printf("%f\t", C[N-1][N-1]);
 
      printf("\n");
   }
	end = MPI_Wtime();

     printf("Time (MPI) taken for computation  is %f \n",(end_compute - start_compute));
     printf("Time (MPI) taken for entire program (Compute + allocate) is %f \n",(end - start));
//freeing the memory

free(A);
free(B_transpose);
free(C);
}
 
  return 0;
}
