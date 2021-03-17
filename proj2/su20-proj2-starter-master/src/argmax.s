.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    add s0, x0, a0
    add s1, x0, a1
    add t0, x0, x0 # The largest number
    add t1, x0, x0 # The index of the array
    add t2, x0, x0 # The offset of the array
    add t3, x0, x0 # The current value of the array

loop_start:
    beq t1, s1, loop_end 
    slli t2, t1, 2
    add s0, a0, t2
    lw  t3, 0(s0)
    bgt t3, t0, loop_continue
    addi t1, t1, 1
    j loop_start

loop_continue:
    mv t0, t3
    mv t4, t1 
    addi t1, t1, 1
    j loop_start

loop_end:
    
    # Epilogue
    mv a0, t4
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

    ret