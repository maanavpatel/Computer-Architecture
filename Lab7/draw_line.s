.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;                     #0
##     unsigned int width;                      #4
##     // The pattern to draw on the canvas.
##     unsigned char pattern;                   #8
##     // Each char* is null-terminated and has same length.
##     char** canvas;                           #12                           
## };

##      void draw_line(
##      unsigned int start_pos,         #a0
##      unsigned int end_pos,           #a1
##      Canvas* canvas) {               #a2
##  .        unsigned int width = canvas->width;
##   .       unsigned int step_size = 1;
##          // Check if the line is vertical.
##   /      if (end_pos - start_pos >= width) {
##              step_size = width;
##          }
##          // Update the canvas with the new line.
##          for (int pos = start_pos; pos != end_pos + step_size; pos += step_size) {
##              canvas->canvas[pos / width][pos % width] = canvas->pattern;
##          }
##      }

.globl draw_line
draw_line:

        sub $sp, $sp, 16
        sw $ra, 0($sp)
        sw $s0, 4($sp)          #a0     start
        sw $s1, 8($sp)          #a1     end
        sw $s2, 12($sp)         #a2     canvas
        move $s0, $a0
        move $s1, $a1
        move $s2, $a2


        lw  $t0, 4($s2)         #canvas->width                          ?? correct way to access struct val?


        addu $t1, $t0, $0            # t1: width = canvas->width      
        li $t9, 1               # stepsize = 1                          ?? need to do for unsigned?        
        addu $t9, $t9, $0
        subu $t0, $s1, $s0       # end_pos - start_pos
        
        #if (end_pos - start_pos >= width)
        blt $t0, $t1, endif
                add $t9, $0, $t1  # stepsize = width
        endif:

        add $t0, $s0, $0         # int pos = start     
        for:
        addu $t2, $s1, $t9        # end_pos + step_size       
        beq $t0, $t2, endL

                
                lw $t3, 12($s2)       #address of canvas->canvas      ?? correct way to access struct val?
                
                # calc  pos/width
                # calc pos % width
                divu $t4, $t0, $t1

                mflo $t5        #pos/width
                mfhi $t6        #pos%width
                
                mul $t5, $t5, 4         #mult by pointer size         ?? mult by width right?... nope
                add $t7, $t5, $t3       #  canvas[pos/width]
                                                                

                lw $t4, ($t7)           #  = canvas[pos/width]


                add $t8, $t4, $t6       # canvas[pos / width][pos % width]

                # de ref: canvas[pos/width]
                # add offset for pos%width
                # deref/write

                #value at canvas->pattern       
                lbu $t5, 8($s2)          # canvas->pattern
                
                lb $t5, ($t8)            # canvas->canvas[pos / width][pos % width] = canvas->pattern;



        add $t0, $t0, $t9
        j for
        endL:

        move $a0, $s0
        move $a1, $s1
        move $a2, $s2


        lw $ra, 0($sp)
        lw $s0, 4($sp)          #a0     start
        lw $s1, 8($sp)          #a1     end
        lw $s2, 12($sp)         #a2     canvas
        add $sp, $sp, 16


        
        jr      $ra
