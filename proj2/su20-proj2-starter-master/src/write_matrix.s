.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -24 
    sw s0 0(sp)  
    sw s1 4(sp)
    sw s2 8(sp) 
    sw s3 12(sp)
    sw s4 16(sp)
    sw ra 20(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3

    mv a1 s0
    li a2 1 
    jal ra fopen
    mv s4 a0


    li t0 -1
    beq s4 t0 file_open_fail
    j file_write

file_open_fail:
    li a1 53
    j exit2

file_write_fail:
    li a1 54
    j exit2

file_close_fail:
    li a1 55
    j exit2

malloc_error:
    li a1 51
    j exit2

file_write:
    mv a1 s4
    addi s1 s1 -8
    sw s2 0(s1)
    sw s3 4(s1)
    mv a2 s1
    mul a3 s2 s3 
    addi a3 a3 2
    li a4 4 


    jal ra fwrite
    blt a0 a3 file_write_fail
    

    mv a0 s4
    jal ra fclose
    li t0 -1
    beq t0 a0 file_close_fail

    # Epilogue
    lw s0 0(sp)  
    lw s1 4(sp)
    lw s2 8(sp) 
    lw s3 12(sp)
    lw s4 16(sp)
    lw ra 20(sp)
    addi sp sp 24 


    ret
