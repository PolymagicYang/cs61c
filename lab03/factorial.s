.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi s0, x0, 1 # initialize the accurate number

loop:
    beq x0, a0, end
    mul s0, s0, a0
    addi a0, a0, -1
    jal x0, loop    # ... while i!= 0

end:
    add a0, a0, s0
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
