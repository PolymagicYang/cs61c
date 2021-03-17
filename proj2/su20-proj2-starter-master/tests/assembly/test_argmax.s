.import ../../src/argmax.s
.import ../../src/utils.s

.data
v0: .word 3 -42 432 7 -5 6 5 -114 2 458 904 3942 3231 -23 2384 123 # MAKE CHANGES HERE

.text
main:
    # Load address of v0
    la s0 v0
    
    # Set length of v0
    addi s1 x0 15 # MAKE CHANGES HERE

    # Call argmax
    mv a0 s0
    mv a1 s1
    jal ra argmax

    # Print the output of argmax
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit program
    jal exit
