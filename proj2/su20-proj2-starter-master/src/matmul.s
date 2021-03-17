.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    addi t1, x0, 1
    slti t0, a1, 1
    slti t0, a2, 1
    beq t0, t1, dimensions_of_m1_handler

    slti t0, a4, 1
    slti t0, a5, 1 
    beq t0, t1, dimensions_of_m2_handler

    beq a2, a4, initialization 
    j dimension_match_handler

    beq t0, x0, outer_loop_start

dimensions_of_m1_handler:
    addi a1, x0, 2
    jal exit2

dimensions_of_m2_handler:
    addi a1, x0, 3
    jal exit2

dimension_match_handler:
    addi a1, x0, 4
    jal exit2

initialization:
    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)
    mv s0, a0 # pointer to the first matrix
    mv s1, a1 # the number of rows in the first matrix
    mv s2, a2 # the number of columns the second matrix
    mv s3, a3 # pointer to the second matrix
    mv s4, a4 # the number of rows of the second matrix
    mv s5, a5 # the number of columns in the second matrix
    mv s6, a6 # the pointer to the destination
    mv s7, a0 # as the base of address of the first matrix.
    
    # initialization
    mv t0, x0 # The index of row in the first matrix.
    mv t1, x0 # The index of column in the second matrix.
    mv t2, x0 # The offset of the first matrix.
    mv t3, x0 # The offset of the second matrix.
    mv t4, x0 # The offset of the destination matrix.

outer_loop_start:
    beq t0, s1, outer_loop_end

    slli t5, t0, 2
    mul t2, t5, s2
    add s0, s7, t2

inner_loop_start:
    beq t1, s5, inner_loop_end # reach the last column in the second matrix.

    slli t3, t1, 2
    add s3, a3, t3 # get the real address of the column in the second matrix.


    addi sp, sp, -40
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    sw a1, 24(sp)
    sw a2, 28(sp)
    sw a3, 32(sp)
    sw a4, 36(sp)
    
    mv a0, s0
    mv a1, s3
    mv a2, s2
    addi a3, x0, 1
    add a4, x0, s5 # We need to pass the remaining items in the row to get the first item in next row.

    jal ra, dot

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    lw a1, 24(sp)
    lw a2, 28(sp)
    lw a3, 32(sp)
    lw a4, 36(sp)
    addi sp, sp, 40 

    sw a0, 0(s6)
    addi s6, s6, 4 

    addi t1, t1, 1
    j inner_loop_start
    
inner_loop_end:
    mv t1, x0

    addi t0, t0, 1
    j outer_loop_start


outer_loop_end:


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp) 
    lw ra, 32(sp)
    addi sp, sp, 36 
    
error_handle:    
    ret