.text

## struct Lines {
##     unsigned int num_lines;          0      
##
##     // An int* array of size 2, where first element is an array of start pos
##     // and second element is an array of end pos for each line.
##     // start pos always has a smaller value than end pos.
##     unsigned int* coords[2];         4
## };
## 
## struct Solution {
##     unsigned int length;     0
##     int* counts;             4
## };
## 
## // Count the number of disjoint empty area after adding each line.
## // Store the count values into the Solution struct. 
## void count_disjoint_regions(const Lines* lines, Canvas* canvas,
##                             Solution* solution) {
##     // Iterate through each step.
##   x  for (unsigned int i = 0; i < lines->num_lines; i++) {
##    x     unsigned int start_pos = lines->coords[0][i];
##    x     unsigned int end_pos = lines->coords[1][i];
##         // Draw line on canvas.
##    x     draw_line(start_pos, end_pos, canvas);
##         // Run flood fill algorithm on the updated canvas.
##         // In each even iteration, fill with marker 'A', otherwise use 'B'.
##   x      unsigned int count =
##                 count_disjoint_regions_step('A' + (i % 2), canvas);
##         // Update the solution struct. Memory for counts is preallocated.
##   x      solution->counts[i] = count;
##     }
## }

.globl count_disjoint_regions
count_disjoint_regions:
        # Your code goes here :)
        sub $sp, $sp, 28
        sw $ra, 0($sp)
        sw $s0, 4($sp)          #a0     lines
        sw $s1, 8($sp)          #a1     canvas
        sw $s2, 12($sp)         #a2     solution
        sw $s3, 16($sp)         #i   
        sw $s4, 20($sp)         #start pos
        sw $s5, 24($sp)         #end pos 

        move $s0, $a0   #lines 
        move $s1, $a1   #canvas
        move $s2, $a2   #solution

        addu $s3, $0, $0
        for:
        lw $t0, ($s0)   #lines->lines
        bge $s3, $t0, endL      # i < lines->num_lines;
                
                # unsigned int start_pos = lines->coords[0][i];
                lw $t0, 4($s0)          # lines->coords
                # lw $t1, 0($t1)          # lines->coords[0]
                
                mul $t2, $s3, 4         #[i]       
                add $t0, $t0, $t2       # lines->coords[0][i]
                lw $s4, ($t0)           # start_pos = lines->coords[0][i]

                # unsigned int end_pos = lines->coords[1][i];
                lw $t0, 4($s0)          # lines->coords
                addi $t0, $t0, 4        # lines->coords[1]
 
                mul $t2, $s3, 4         #[i]       
                add $t1, $t0, $t2       # lines->coords[1][i]
                lw $s5, ($t1)           # end = lines->coords[1][i]

                # if endpos is greater than start then flip them (branch on start <= end)
                ble $s4, $s5, z
                        #fliperoo
                        move $t4, $s4
                        move $s4, $s5
                        move $s5, $t4
                z:

                # draw_line(start_pos, end_pos, canvas);
                move $a0, $s4
                move $a1, $s5
                move $a2, $s1

                jal draw_line

                # unsigned int count = count_disjoint_regions_step('A' + (i % 2), canvas)
                li $t0, 2
                divu $s3, $t0     #i % 2
                mfhi $t1        
                
                li $t2, 'A'
                add $t2, $t2, $t1
                add $a0, $t2, $0
                add $a1, $s1, $0
                jal count_disjoint_regions
                add $t6, $v0, $0

                lw $t7, 4($s2)
                mul $t8, $s3, 4         # [i]
                add $t8, $t8, $t7       # solution->counts[i]
                sw $t6, ($t8)

        addi $s3, $s3, 1
        j for
        endL:

        add $a0, $s0, $0
        add $a1, $s1, $0
        add $a2, $s2, $0

        lw $ra, 0($sp)
        lw $s0, 4($sp)          #a0     lines
        lw $s1, 8($sp)          #a1     canvas
        lw $s2, 12($sp)         #a2     solution
        lw $s3, 16($sp)         #i   
        lw $s4, 20($sp)         #start pos
        lw $s5, 24($sp)         #end pos 
        add $sp, $sp, 28


        jr      $ra
