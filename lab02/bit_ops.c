#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    // YOUR CODE HERE
    // Returning -1 is a placeholder (it makes
    // no sense, because get_bit only returns
    // 0 or 1)
    unsigned mask = 1;
    mask <<= n;
    return (mask & x) >> n;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    unsigned maskOfRight = ~(0xffffffff << n);
    unsigned maskOfLeft = (0xffffffff << (n + 1));
    maskOfLeft &= *x;
    maskOfRight &= *x;
    *x = maskOfLeft | maskOfRight | 0x0;
    *x = *x | (v << n);
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    unsigned maskOfRight = ~(0xffffffff << n);
    unsigned maskOfLeft = (0xffffffff << (n + 1));
    maskOfLeft &= *x;
    maskOfRight &= *x;
    unsigned v = (((0x1 << n) ^ (*x)) >> n) & 0x00000001;
    *x = maskOfLeft | maskOfRight | 0x0;
    unsigned filpedNumMask = v << n;
    *x = *x | filpedNumMask;
}

