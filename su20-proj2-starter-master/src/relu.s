.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the length of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 115.
# ==============================================================================
relu:
    # Prologue
    addi t0, x0, 1
    blt a1, t0, loop_end_exception # length < 1
    add t1, x0, x0 # current index of the vector

loop_start:
    beq t1, a1, loop_end 
    slli t2, t1, 2 # the relative location of the vector.
    add t5, a0, t2 # points to the next vector.
    lw t3, 0(t5) # load current value of this vector.
    addi t1, t1, 1 # index
    slti t4, t3, 0 
    beq t4, x0, loop_start

loop_continue:
    sw x0, 0(t5)
    j loop_start

loop_end_exception:
    addi a1, x0, 115
    j exit2

loop_end:


    # Epilogue

    
	ret