.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;
##     unsigned int width;
##     // The pattern to draw on the canvas.
##     unsigned char pattern;
##     // Each char* is null-terminated and has same length.
##     char** canvas;
## };
## 
## // Count the number of disjoint empty area in a given canvas.
## unsigned int count_disjoint_regions_step(unsigned char marker,       a0
##                                          Canvas* canvas) {           a1
##     unsigned int region_count = 0;
##     for (unsigned int row = 0; row < canvas->height; row++) {
##         for (unsigned int col = 0; col < canvas->width; col++) {
##             unsigned char curr_char = canvas->canvas[row][col];
##             if (curr_char != canvas->pattern && curr_char != marker) {
##                 region_count ++;
##                 flood_fill(row, col, marker, canvas);
##             }
##         }
##     }
##     return region_count;
## }

.globl count_disjoint_regions_step
count_disjoint_regions_step:
        # Your code goes here :)
        sub $sp, $sp, 24	#alloc stack
        sw $ra, 0($sp)
        sw $s0, 4($sp)          #a0 marker
        sw $s1, 8($sp)          #a1 canvas
        sw $s2, 12($sp)         #row
        sw $s3, 16($sp)         #col   
        sw $s4, 20($sp)         #region count

        #save
        move $s0, $a0           
        move $s1, $a1

        addu $s4, $0, $0        # unsigned int region_count = 0;
        
        addu $s2, $0, $0         #row

        for_row:
        lw $t0, ($s1)          ## canvas->height
        bge $s2, $t0, end_row

                addu $s3, $0, $0        #col
                for_col:
                lw $t8, 4($s1)          #canvas->width
                bge $s3, $t8, end_col

                        
                        # li $v0, 1
                        # move $a0, $s3
                        # syscall



                        lw $t7, 12($s1) ##canvas->canvas
                        mul $t3, $s2, 4 #[row]
                        add $t6, $t7, $t3       ## canvas->canvas[row]
                        lw $t9, ($t6)     	## = canvas->canvas[row];

                        add $t9, $t9, $s3	## canvas->canvas[row][col]
                        lb $t3, ($t9)           # curr_char

                        #if (curr_char != canvas->pattern && curr_char != marker) {
                        
                        lb $t9, 8($s1)
                        beq $t3, $t9, a

                        # li $v0, 11
                        # move $a0, $t9
                        # syscall

                        # addu $t9, $s0, $0
                        beq $t3, $s0, a

                       

                        if:
                                addi $s4, $s4, 1 #   region_count ++;
                                
                                #stack save
                                # move $s4, $v0

                                #load arguments
                                addu $a0, $s2, $0        #row
                                addu $a1, $s3, $0        #col
                                add $a2, $s0, $0        #marker
                                add $a3, $s1, $0        #canvas
                                
                                # flood_fill(row, col, marker, canvas);
                                jal flood_fill




                a:
                addi $s3, $s3, 1
                j for_col
                end_col:

        addi $s2, $s2, 1
        j for_row
        end_row:

        #restore args
        add $a0, $s0, $0
        add $a1, $s1, $0

        #return count
        addu $v0, $s4, $0

        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)

        add $sp, $sp, 24
        jr      $ra
