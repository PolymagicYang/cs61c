.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/simple0/bin/m0.bin"

.text
main:
    addi sp sp -12
    sw s0 0(sp)
    sw s1 4(sp)
    sw ra 8(sp)

    # Read matrix into memory
    li a0 8 
    jal ra malloc
    mv s0 a0
    addi t0 s0 4
    mv s1 t0 
    li t2 3
    sw t2 0(s0)
    sw t2 0(s1)

    
    # Print out elements of matrix
    la a0 file_path
    mv a1 s1
    mv a2 s2

    jal ra read_matrix

    li a1 3
    li a2 3
    jal ra print_int_array

    lw s0 0(sp)
    lw s1 4(sp)
    lw ra 8(sp)
    addi sp sp 12

    j exit

    # Terminate the program