.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    addi sp sp -28
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw ra 24(sp)

    lw s0 4(a1) # Store the address of file name of m0 into s0
    lw s1 8(a1) # Store the address of file name of m1 into s1
    lw s2 12(a1) # Store the address of file name of input file into s2
    lw s3 16(a1) # Store the address of file name of output file into s3

    

    li t0 5
    beq t0 a0 classification_start

argument_number_match_error:
    li a1 49
    j exit2

classification_start:


	# =====================================
    # LOAD MATRICES
    # =====================================
    li a0 8
    jal ra malloc # allocate space for the number of row and colomn
    mv a1 a0 # The address of the number of row 
    addi t0 a0 4
    mv a2 t0 # The address of the number of colomn

    mv a0 s0
    jal ra read_matrix # Read the matrix in file m0
    

    mv s0 a0 # Store the address of the matrix m0 into the s0
    lw t1 0(a1) # Store the number of the row of m0
    lw t2 0(a2) # Store the number of the column of m0

    addi sp sp -24
    sw t1 0(sp)
    sw t2 4(sp)


    mv a0 s1
    jal ra read_matrix # Read the matrix in file m1

    mv s1 a0 # Store the address of the matrix m1 into the s1
    lw t3 0(a1) # Store the number of the row of m1
    lw t4 0(a2) # Store the number of the column of m1

    sw t3 8(sp)
    sw t4 12(sp)

    # Load input matrix
    mv a0 s2
    jal ra read_matrix
    mv s2 a0 
    lw t5 0(a1)
    lw t6 0(a2)


    sw t5 16(sp)
    sw t6 20(sp)

    mv a0 a1
    jal ra free

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    mul t0 t1 t6
    jal ra malloc
    mv s4 a0

    lw t1 0(sp)
    lw t2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    lw t6 20(sp)
    
    mv a0 s0
    mv a1 t1
    mv a2 t2
    mv a3 s2
    mv a4 t5
    mv a5 t6
    mv a6 s4


    jal ra matmul

    lw t1 0(sp)
    lw t6 20(sp)
    mul t0 t1 t6
    mv a0 a6
    mv a1 t0 # The length of the array
    jal relu

    mv a6 s4

    lw t1 0(sp)
    lw t2 4(sp)
    lw t3 8(sp)
    lw t4 12(sp)
    lw t5 16(sp)
    lw t6 20(sp)

    mul a0 t3 t6
    jal ra malloc
    mv s5 a0

    mv a0 s1
    mv a1 t3
    mv a2 t4
    mv a3 s4
    mv a4 t1
    mv a5 t6
    mv a6 s5

    jal ra matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw t3 8(sp)
    lw t6 20(sp)

    mv a0 s3
    mv a1 s5
    mv a2 t3
    mv a3 t6

    jal ra write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t3 8(sp)
    lw t6 20(sp)
    mul a1 t3 t6

    mv a0 s5

    jal ra argmax

    # Print classification
    mv a1 a0
    jal ra print_int
    
    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra print_char

    addi sp sp 24
    mv a0 t0 
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw ra 24(sp)
    addi sp sp 28

    ret