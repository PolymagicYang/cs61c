#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    /* YOUR CODE HERE */
    unsigned digitOfZeroP = (0x1 & (*reg)) & 1;
    unsigned digitOfTwoP = ((0x4 & (*reg)) >> 2) & 1;
    unsigned digitOfThreeP = ((0x8 & (*reg)) >> 3) & 1;
    unsigned digitOfFiveP = ((0x20 & (*reg)) >> 5) & 1;

    unsigned Msd = digitOfZeroP ^ digitOfTwoP ^ digitOfThreeP ^ digitOfFiveP;  
    Msd <<= 15;
    *reg = ((*reg) >> 1) | Msd;
}

