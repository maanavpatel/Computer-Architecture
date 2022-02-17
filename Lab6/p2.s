# /**
#  * This function matches a 5x5 pattern across the map using 2D convolution.
#  * If the correlation between the pattern and a 5x5 patch of the map is above the
#  * given threshold, then the left hand corner of the patch will be returned.
#  * If no match was found, then -1 is returned.
#  */
# int pattern_match(int threshold, int pattern[5][5], int map[16][16]) {
#     const int PATTERN_SIZE = 5;
#     const int EDGE = 16 - 5 + 1;

#     for (int row = 0; row < EDGE; row++) {
#         for (int col = 0; col < EDGE; col++) {
#             int sum = 0;
#             for (int pat_row = 0; pat_row < PATTERN_SIZE; pat_row++) {
#                 for (int pat_col = 0; pat_col < PATTERN_SIZE; pat_col++) {
#                     if (pattern[pat_row][pat_col] == map[row + pat_row][col + pat_col]) {
#                         sum += 1;
#                     }
#                     if (sum > threshold) {
#                         return (row << 16) | col;
#                     }
#                 }
#             }
#         }
#     }
#     return -1;
# }

.globl pattern_match
pattern_match:

        #for (int row = 0; row < EDGE; row++)
        add $t2, $0, $0     #row
        row_edge:
        bge $t2, 12, end_rE

                #for (int col = 0; col < EDGE; col++)
                add $t3, $0, $0     #col
                col_edge:
                bge $t3, 12, end_cE


                        add $t4, $0, $0         #sum

                        #for (int pat_row = 0; pat_row < PATTERN_SIZE; pat_row++) {
                        add $t5, $0, $0         #pat_row
                        pat_row:
                        bge $t5, 5, end_rP

                                #for (int pat_col = 0; pat_col < PATTERN_SIZE; pat_col++)
                                add $t6, $0, $0         #pat_col       
                                pat_col:
                                bge $t6, 5, end_cP
                                
                                        mul $t7, $t5, 4        # pat_row * (int=4)
                                        mul $t7, $t7, 5        # pat_row * (NUMCOL=5)

                                        mul $t8, $t6, 4         # pat_col *4 
                                        
                                        add $t9, $t7, $t8      # (pat_row * NUMCOL) + pat_col
                                        add $t9, $a1, $t9       # pattern[pat_row][pat_col]
                                        lw $t0, 0($t9)           # = pattern[pat_row][pat_col]

                                        #t: 1,7,8,9 usable
                                        
                                        add $t1, $t2, $t5       # row + pat_row
                                        mul $t1, $t1, 4         # [row + pat_row]
                                        mul $t1, $t1, 16        # [row + pat_row][]

                                        add $t7, $t3, $t6      # col + pat_col
                                        mul $t7, $t7, 4         # [col + pat_col]

                                        add $t7, $t1, $t7       # [row + pat_row][col + pat_col]
                                        add $t1, $t7, $a2       # map[row + pat_row][col + pat_col]
                                        
                                        lw $t7, ($t1)
                                        
                                        #t: 8,9 usable
                                        # if (pattern[pat_row][pat_col] == map[row + pat_row][col + pat_col])
                                        if:
                                        bne $t7, $t0, if2       
                                                addi $t4, $t4, 1        #sum += 1

                                        if2:
                                        ble $t4, $a0, d
                                                
                                                sll $t8, $t2, 16        #(row << 16) 
                                                or $v0, $t8, $t3
                                                #return
                                                jr $ra


                                d:
                                addi $t6, $t6, 1 
                                j pat_col
                                end_cP:

                        addi $t5, $t5, 1 
                        j pat_row
                        end_rP:

                addi $t3, $t3, 1
                j col_edge
                end_cE:

        addi $t2, $t2, 1
        j row_edge
        end_rE:

        add $v0, $0, -1
        jr      $ra