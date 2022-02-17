/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);

    // allocate an array for the output
    unsigned char *message_out = new unsigned char[length];
    for (int i = 0; i < length; i++) {
        message_out[i] = 0;
    }

    // TODO: write your code here

    //traverse each char of the message 
    for (int i = 0; i < length; i++) { 
        for (int j = 0; j < 8; j++){ //traverse each bit
            char x = message_in[i];
            x = x >> j;
            x = x & 1;
            x = x << (i % 8);
            message_out[8* (i/8) + j] |= x;
        }
    }
        //traverse each bit of the byte

/*
    EX:
    93 is an 8 bit binary number
    To get each bit
    find LSB:
        and with 1 ( & 1 ) (technically represented as 00000001)
    shift 1
        find LSB again
     //entire matrix
    to get output matrix:
        OR with LSB
    shift again
        repeat OR operation

    //would repeat this for each number
*/


    

    return message_out;
}
