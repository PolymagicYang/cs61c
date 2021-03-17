.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)

    add t0, x0, x0 # The index of the array
    add t1, x0, x0 # The offset of the first array
    add t2, x0, x0 # The offset of the second array
    add t3, x0, x0 # The index of the first array
    add t4, x0, x0 # The index of the second array
    add t5, x0, x0 # The current value of the first array
    add t6, x0, x0 # The current value of the second array
    add s5, x0, x0 # The product of the first array and the second array
    add s6, x0, x0 # Store the current value of the dot product
    add s0, x0, a0 # The pointer to the start of v0
    add s1, x0, a1
    add s2, x0, a2
    add s3, x0, a3
    add s4, x0, a4

loop_start:
    beq t0, s2, loop_end
    add t3, t3, s3
    add t4, t4, s4 
    slli t1, t3, 2
    slli t2, t4, 2
    addi t0, t0, 1
    lw t5, 0(s0)
    lw t6, 0(s1)
    add s0, a0, t1
    add s1, a1, t2
    mul s5, t5, t6
    add s6, s6, s5
    j loop_start
     
loop_end:
    mv a0, s6
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    addi sp, sp, 28 

    # Epilogue

    
    ret