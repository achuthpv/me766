#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {    
if (argc < 2) printf ("please enter right arguments");
int i, j, k, N;
int num_PE, num_slave, id_PE, rows_per_PE, dest, source;

// to avoid confusion always use i for rows and j for columns.
float **A, **B, **B_t; 
double **C, sum = 0,start,start_h2m[32],start_m2h, start_compute,start_B, end_B, end_h2m, end_m2h[32],end_compute, end;

// Initialize the MPI environment
MPI_Init(&argc, &argv);

// Get the number of processes
MPI_Comm_size(MPI_COMM_WORLD, &num_PE);
num_slave = num_PE - 1;

// Get the rank of the process
MPI_Comm_rank(MPI_COMM_WORLD, &id_PE);
MPI_Request request;
MPI_Status status;
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
//if (id_PE == 0) start_compute = MPI_Wtime();

start_compute = MPI_Wtime();

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
start_B = MPI_Wtime();
for (i = 0 ; i < N ; i++){
MPI_Bcast(&B_t[i][0], N, MPI_FLOAT,0,MPI_COMM_WORLD);
}
end_B = MPI_Wtime();
printf("time taken in host %d to broadcast is %f\n",id_PE, (end_B-start_B));
if (id_PE == 0){
	
		// send parts of A to different processors
		for (dest=1; dest<=num_slave; dest++)
		      {
			start_h2m[dest] = MPI_Wtime();
			printf("start of sending A to host %d at %f\n",dest, start_h2m[dest]);
			for (i = ((dest -1) * rows_per_PE) ; i < (dest * rows_per_PE) ; i++){
			MPI_Send(&A[i][0], N, MPI_FLOAT, dest, i,MPI_COMM_WORLD);
							}
			}


		//perform Matrix Multiplication
		start = MPI_Wtime();
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
		end = MPI_Wtime();
		printf("end of computation in node %d at %f\n",id_PE, (end-start));
		//Receive parts of matrix from other processors
		for (source=1; source<=num_slave; source++)
		      {
			for (i = ((source -1) * rows_per_PE) ; i < (source * rows_per_PE) ; i++){
			MPI_Recv(&C[i][0], N, MPI_DOUBLE, MPI_ANY_SOURCE, i,MPI_COMM_WORLD, MPI_STATUS_IGNORE);
												}
			end_m2h[source] = MPI_Wtime();
			printf("end of sending C from host %d at %f\n",source, end_m2h[source]);
	        	}
//MPI_Wait(&request, &status);

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
				MPI_Recv(&A[i][0], N, MPI_FLOAT, 0, i,MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		}
		end_h2m = MPI_Wtime();
		printf("end of reception of A in host %d is %f\n",id_PE, end_h2m);
		//perform Matrix Multiplication
		start = MPI_Wtime();
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
		end= MPI_Wtime();
		printf("end of computation in node %d at %f\n",id_PE, (end-start));
		// send parts of C from different processors
		start_m2h = MPI_Wtime();
			for (i = ((id_PE -1) * rows_per_PE) ; i < (id_PE * rows_per_PE) ; i++){
			MPI_Send(&C[i][0], N, MPI_DOUBLE, 0, i,MPI_COMM_WORLD);
							}

	printf("start of sending C in host %d is %f\n",id_PE, start_m2h);

}
MPI_Barrier(MPI_COMM_WORLD);
if(id_PE==0) printf("%f\n", C[N-1][N-1]);
end_compute = MPI_Wtime();
printf("For N= %d,  in Process %d Time (MPI) taken for computation  is %f \n",N,id_PE, (end_compute - start_compute));
//}

// Finalize the MPI environment.
MPI_Finalize();
}
