// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration

// make generator
// ./generator

#include <cstdio>
using std::printf;

int
main() {
    int width = 32;
    for (int i = 1 ; i < width ; i ++) {
        printf("    alu1 al%d(out[%d], carryout[%d], A[%d], B[%d], carryout[%d], control);\n", i, i, i, i, i, i-1);
    }
}

/*
for i in range(1, 31):
    print(f"   alu{i}(carryout[{i}], A[{i}], B[{i}], carryout[{i - 1}], control)")

*/