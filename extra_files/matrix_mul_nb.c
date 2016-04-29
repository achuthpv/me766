#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {    
if (argc < 2) printf ("please enter right arguments");
int i, j, k, N;
int num_PE, num_slave, id_PE, rows_per_PE, dest, source;

// to avoid confusion always use i for rows and j for columns.
float **A, **B, **B_t; 
double **C, sum = 0 ,start,start_compute, end_compute, end;

// Initialize the MPI environment
MPI_Init(&argc, &argv);

// Get the number of processes
MPI_Comm_size(MPI_COMM_WORLD, &num_PE);
num_slave = num_PE - 1;

// Get the rank of the process
MPI_Comm_rank(MPI_COMM_WORLD, &id_PE);
MPI_Request request1, request2, request3;
MPI_Status status1, status2;
//for (h=1; h< argc; h++){
	N = atoi(argv[1]);
	//printf("\nFor N = %d\n", N);
	rows_per_PE = N/num_PE;
	//reminder_PE = N%num_PE;

//dynamic memory alloctaion for all the matrices  
A = (float **)malloc(N * sizeof(float*));
for (i = 0; i < N; i ++)
A[i] = (float *)malloc(N * sizeof(float));

B= (float **)malloc(N * sizeof(float*));
for (i = 0; i < N; i ++)
B[i] = (float *)malloc(N * sizeof(float));

B_t = (float **)malloc(N * sizeof(float*));
for (i = 0; i < N; i ++)
B_t[i] = (float *)malloc(N * sizeof(float));

C = (double **)malloc(N * sizeof(double*));
for (i = 0; i < N; i ++)
C[i] = (double *)malloc(N * sizeof(double));
if (id_PE == 0) start_compute = MPI_Wtime();

if (id_PE == 0){
	 	  for (i = 0; i < N; i++)
		     for (j = 0; j < N; j++)
		     	A[i][j] = 1;//(float)rand()/(float)(RAND_MAX/UL);
	
		    //printf("Enter the elements of second matrix\n");
		 
		    for (i = 0; i < N; i++)
		      for (j = 0; j < N; j++)
		// Matrix generated and saved as transpose for easier multiplication
			B[i][j] = 1;//(float)rand()/(float)(RAND_MAX/UL);
		    
		    for (i = 0; i < N; i++)
		      for (j = 0; j < N; j++)
			B_t[i][j] = B[j][i];

}

//Broadcast B transpose
for (i = 0 ; i < N ; i++){
MPI_Ibcast(&B_t[i][0], N, MPI_FLOAT,0,MPI_COMM_WORLD, &request3);
}

if (id_PE == 0){
	
		// send parts of A to different processors
		for (dest=1; dest<=num_slave; dest++)
		      {
			for (i = ((dest -1) * rows_per_PE) ; i < (dest * rows_per_PE) ; i++){
			MPI_Isend(&A[i][0], N, MPI_FLOAT, dest, i,MPI_COMM_WORLD, &request1);
							}
			}

		//perform Matrix Multiplication
		    for (i = (num_slave * rows_per_PE); i < N; i++) {
		      for (j = 0; j < N; j++) {
			for (k = 0; k < N; k++)
			  sum = sum + A[i][k]*B_t[j][k];
			C[i][j] = sum;
			//printf("%f\t", B_t[i][j]);
			sum = 0;
		      }
		   //printf ("\n");
			}
		//Receive parts of matrix from other processors
		for (source=1; source<=num_slave; source++)
		      {
			for (i = ((source -1) * rows_per_PE) ; i < (source * rows_per_PE) ; i++){
			MPI_Irecv(&C[i][0], N, MPI_DOUBLE, MPI_ANY_SOURCE, i,MPI_COMM_WORLD, &request2);
												}
			}
MPI_Wait(&request2,MPI_STATUS_IGNORE);

//printf("Product of entered matrices:-\n");
 
  //  for (i = 0; i < N; i++) {
    //  for (j = 0; j < N; j++)
        printf("%f\t", C[N-1][N-1]);
 
      printf("\n");
   //}

//MPI_Barrier(MPI_COMM_WORLD);
}
else if (id_PE > 0){
		// Receive parts of A from master
		for (i = ((id_PE -1) * rows_per_PE) ; i < (id_PE * rows_per_PE) ; i++){
				MPI_Irecv(&A[i][0], N, MPI_FLOAT, 0, i,MPI_COMM_WORLD,&request1);
		}
		//perform Matrix Multiplication
		    for (i = ((id_PE -1) * rows_per_PE) ; i < (id_PE * rows_per_PE) ; i++) {
		      for (j = 0; j < N; j++) {
			for (k = 0; k < N; k++)
			  sum = sum + A[i][k]*B_t[j][k];
			C[i][j] = sum;
			//printf("%f\t", B_t[i][j]);
			sum = 0;
		      }
		   //printf ("\n");
			}
		// send parts of C from different processors
			for (i = ((id_PE -1) * rows_per_PE) ; i < (id_PE * rows_per_PE) ; i++){
			MPI_Isend(&C[i][0], N, MPI_DOUBLE, 0, i,MPI_COMM_WORLD,&request2);
							}


}
MPI_Barrier(MPI_COMM_WORLD);
end_compute = MPI_Wtime();
     printf("For N= %d, Time (MPI) taken for computation  is %f \n",N,(end_compute - start_compute));
//}


// Finalize the MPI environment.
MPI_Finalize();


}
