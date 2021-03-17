.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2


    mv a1 s0 
    li a2 0

    jal ra, fopen 

    li t1 -1
    beq a0 t1, file_open_error
    mv s6, a0 # The file descriptor
    j file_matrix_size_read


file_open_error:
    li a1 50
    j exit2

read_file_error:
    li a1 51


file_matrix_size_read:
    li a0, 8
    jal ra malloc
    mv s3 a0 # The pointer points to the buffer

    slti t1 a0 1
    beq t1 x0 read_file_continue


    li a1 48
    j exit2

read_file_continue:
    mv a1 s6
    mv a2 s3
    li a3 8

    jal ra fread
    slti t0 a0 0
    li t1 1
    beq t0 t1 read_file_error 

    lw s4 0(s3) # The number of rows of the matrix 
    lw s5 4(s3) # The number of columns of the matrix

    mul a0 s4 s5 # The size of the matrix
    slli a0 a0 2
    addi a0 a0 8

    
    jal ra malloc

    addi t0 a0 8 
    mv s3 t0 
    sw s4 0(a0) # Put the number of rows of the matrix to the buffer
    sw s5 4(a0) # columns

    #mv t0 a0
    #mv a1 s4
    #jal ra print_int
    #mv a0 t0

    mv a1 s6
    mv a2 s3
    mul t0 s4 s5
    slli t0 t0 2
    mv a3 t0

    jal ra fread
    slti t0 a0 0
    li t1 1
    beq t0 t1 read_file_error 
    # Epilogue
    
    mv a0 s6
    jal ra fclose

    mv a0 s3
    addi s3 s3 -8
    mv a1 s3
    addi a2 s3 4 

    #mv t0 a0
    #lw a1 0(a2) 
    #jal ra print_int
    #mv a0 t0


    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32


    ret