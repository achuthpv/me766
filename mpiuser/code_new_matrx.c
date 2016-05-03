#include <stdio.h>
#include <mpi.h>
#include <string.h>
#include <time.h>
#define SERVER_NODE 0

void CUDA_stuff(int *D, int *E, int *F, int N);

int main ( int argc, char ** argv ) {
	int my_rank, world_size, destination, tag, source, length;
	char message[256], name[80];
      double start_send_AB,stop_send_AB,start_recv_C,stop_recv_C,start=0,stop=0,Time_elapsed=0;
	// Standard MPI startup stuff	
	MPI_Status status;
	MPI_Init ( &argc, &argv );
	MPI_Comm_rank (MPI_COMM_WORLD, &my_rank);
	MPI_Comm_size (MPI_COMM_WORLD, &world_size);
	int N;
	N= atoi(argv[1]);
//	scanf("%d",&N);
	        start=MPI_Wtime();
	
	// Declare variables
	
//	int N=10000; // Make it an even number.  
	int i, j, k;
	int *A, *B, *C;
	int *A0, *A1, *B0, *B1, *C00, *C01, *C10, *C11;
	int *D, *E, *F;
	
	// Allocate memory for three matrices on the CPU
	
	A = (int*)malloc(N*N*sizeof(int));
	B = (int*)malloc(N*N*sizeof(int));
	C = (int*)malloc(N*N*sizeof(int));
	
	// Allocate memory for the parts of matrices
	
	// A0 is the top half of A, an N/2 x N matrix
	// A1 is the bottom half of A
	// B0 is the left half of B, an N x N/2 matrix
	// B1 is the right half of B
	A0 = (int*)malloc((N)*(N/2)*sizeof(int));
	A1 = (int*)malloc((N)*(N/2)*sizeof(int));
	B0 = (int*)malloc((N)*(N/2)*sizeof(int));
	B1 = (int*)malloc((N)*(N/2)*sizeof(int));
	C00 = (int*)malloc((N/2)*(N/2)*sizeof(int));
	C01 = (int*)malloc((N/2)*(N/2)*sizeof(int));
	C10 = (int*)malloc((N/2)*(N/2)*sizeof(int));
	C11 = (int*)malloc((N/2)*(N/2)*sizeof(int));
	D = (int*)malloc((N)*(N/2)*sizeof(int));
	E = (int*)malloc((N)*(N/2)*sizeof(int));
	F = (int*)malloc((N/2)*(N/2)*sizeof(int));
	
	// On the head node, generate the random matrix
	//    and slice it into pieces.
	
	
	if ( my_rank==0 ) {
	
		// Initialize the matrices with random integers
		
		for ( i=0; i<N; i++ ) {
			for ( j=0; j<N; j++ ) {
				A[i*N+j]=1;
				B[i*N+j]=1;
			}
		}
		
		// Slice A into upper and lower rectangles, 
		// slice B into left and right rectangles.  
		
		for ( i=0; i<N/2; i++ ) {
			for ( j=0; j<N; j++ ) {
				A0[i*(N)+j]=A[i*(N)+j];
				A1[i*(N)+j]=A[i+(N/2)*(N)+j];
			}
		}
		for ( i=0; i<N; i++ ) {
			for ( j=0; j<N/2; j++ ) {
				B0[i*(N/2)+j] = B[i*(N)+j];
				B1[i*(N/2)+j] = B[i*(N)+j+(N/2)];
			}
		}
}
start_send_AB=MPI_Wtime();
printf("start of sending A and B in process %d at %f\n",my_rank,start_send_AB);

	if ( my_rank==0 ) {
	
		
			
		// Send the pieces to the four work nodes

	
//    MPI_Send ( A0, (N/2)*(N), MPI_INT, 0, 0, MPI_COMM_WORLD );
//		MPI_Send ( B0, (N/2)*(N), MPI_INT, 0, 0, MPI_COMM_WORLD );
		MPI_Send ( A0, (N/2)*(N), MPI_INT, 1, 0, MPI_COMM_WORLD );
		MPI_Send ( B0, (N/2)*(N), MPI_INT, 1, 0, MPI_COMM_WORLD );
		MPI_Send ( A1, (N/2)*(N), MPI_INT, 2, 0, MPI_COMM_WORLD );
		MPI_Send ( B1, (N/2)*(N), MPI_INT, 2, 0, MPI_COMM_WORLD );
		MPI_Send ( A1, (N/2)*(N), MPI_INT, 3, 0, MPI_COMM_WORLD );
		MPI_Send ( B1, (N/2)*(N), MPI_INT, 3, 0, MPI_COMM_WORLD );
		printf("HELLO\n");
		// Tell all of the processors what N is.  
		
		MPI_Bcast ( &N, 1, MPI_INT, 0, MPI_COMM_WORLD );
	}
	
	// One processor on each node receives the half-matrices, 
	//  	now called D and E.  
	// Multiply on the GPU, 
	// 	and send the results to the head node.  
	       if(my_rank==0){
               


//         printf("Hello N is: %d\n",N);
		CUDA_stuff(A0, B0,F, N);
               for(i=0;i<(N/2);i++){
                 for(j=0;j<(N/2);j++){

                     C00[i*(N/2)+j]=F[i*(N/2)+j];
  //                  printf("C00=%d ",C00[i*(N/2)+j]);
}
//printf("\n");
}

//printf("\n\n\n");


//	MPI_Send ( F, (N/2)*(N/2), MPI_INT, 0,0 , MPI_COMM_WORLD );

	}
	if (  my_rank > 0 ) {
         
		MPI_Recv( D, (N/2)*(N), MPI_INT, 0, 0, MPI_COMM_WORLD, &status );
		MPI_Recv( E, (N/2)*(N), MPI_INT, 0, 0, MPI_COMM_WORLD, &status );
            stop_send_AB=MPI_Wtime();
	printf("End of receiving A and B in process %d is at %f\n",my_rank,stop_send_AB);
		CUDA_stuff(D, E, F, N);
            start_recv_C=MPI_Wtime();
	printf("start of sending C in process %d at %f\n",my_rank,start_recv_C);
		MPI_Send ( F, (N/2)*(N/2), MPI_INT, 0, my_rank, MPI_COMM_WORLD );
	}

	// The head node receives the results from the four work nodes, 
	// 	copies them to C, and 
	//	prints the result.  

	if ( my_rank==0 ) {
		//MPI_Recv ( C00, (N/2)*(N/2), MPI_INT, 0, 0, MPI_COMM_WORLD, &status );
		MPI_Recv ( C01, (N/2)*(N/2), MPI_INT, 1, 1, MPI_COMM_WORLD, &status );
		MPI_Recv ( C10, (N/2)*(N/2), MPI_INT, 2, 2, MPI_COMM_WORLD, &status );
		MPI_Recv ( C11, (N/2)*(N/2), MPI_INT, 3, 3, MPI_COMM_WORLD, &status );
		for ( i=0; i<N/2; i++ ) {
			for ( j=0; j<N/2; j++ ) {
				C[i*N+j] = C00[i*(N/2)+j];
				C[i*N+j+N/2] = C01[i*(N/2)+j];
				C[(i+N/2)*N+j] = C10[i*(N/2)+j];
				C[(i+N/2)*N+j+(N/2)] = C11[i*(N/2)+j];
			}
		}
}
stop_recv_C=MPI_Wtime();
printf("End of  receiving C of process %d is %f\n",my_rank,stop_recv_C);



		
stop=MPI_Wtime();
//printf("end of receiving C is %f\n",stop_recv_C);
 Time_elapsed=(stop-start);
//double TIME_ELAPSED_SEND=(stop_send_AB-start_send_AB);
//double TIME_ELAPSED_RECV=(stop_recv_C-start_recv_C);

printf("TIME ELAPSED BY TOTAL CODE: %f\n",Time_elapsed);
//printf("TIME ELAPSED IN SENDING:%f\n",TIME_ELAPSED_SEND);	
//printf("TIME ELAPSED IN RECEIVING C:%f\n",TIME_ELAPSED_RECV);
	
	free(A);free(B);free(C);free(A0);free(B0);free(C00);free(C01);free(C10);free(C11);
   free(A1);free(B1);
	
	MPI_Finalize();
	
}
