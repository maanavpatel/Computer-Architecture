.text

## struct Canvas {
##     // Height and width of the canvas.
##     unsigned int height;						0
##     unsigned int width;						4
##     // The pattern to draw on the canvas.
##     unsigned char pattern;					8
##     // Each char* is null-terminated and has same length.
##     char** canvas;							12
## };
## 
## // Mark an empty region as visited on the canvas using flood fill algorithm.
##					0			1				2				3
## void flood_fill(int row, int col, unsigned char marker, Canvas* canvas) {
##     // Check the current position is valid.
##     if (row < 0 || col < 0 ||
##         row >= canvas->height || col >= canvas->width) {
##         return;
##     }
##     unsigned char curr = canvas->canvas[row][col];
##     if (curr != canvas->pattern && curr != marker) {
##         // Mark the current pos as visited.
##         canvas->canvas[row][col] = marker;
##         // Flood fill four neighbors.
##         flood_fill(row - 1, col, marker, canvas);
##         flood_fill(row, col + 1, marker, canvas);
##         flood_fill(row + 1, col, marker, canvas);
##         flood_fill(row, col - 1, marker, canvas);
##     }
## }

.globl flood_fill
flood_fill:
	
	sub $sp, $sp, 20	#alloc stack
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	#copy all arguments
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3

	#if (row < 0 || col < 0 ||
	##         row >= canvas->height || col >= canvas->width)
	# goes to the base case if any of these are true
	blt $s0, $0, base	#row < 0
	blt $s1, $0, base	#col < 0 
	
	lw $t0, 0($s3)		#row >= canvas->height
	bge $s0, $t0, base

	lw $t0, 4($s3)		#col >= canvas->width
	bge $s1, $t0, base
	
	#all above were false so we go to the recursive case
		j recursive

	base: 
		j $ra

	recursive:
		
		mul $t0, $s0, 4
		lw $t1, 12($s3)
		add $t1, $t1, $t0	# address of canvas->canvas[row]

		lw $t2, ($t1)     	# canvas->canvas[row];
		add $t3, $t2, $a1	# canvas->canvas[row][col]

		lbu $t4, ($t3)		# curr

##     if (curr != canvas->pattern && curr != marker)
		lb $t5, 8($s3)		#canvas->pattern

		#branch on any false case
		beq $t4, $t5, done
		beq $t4, $s2, done

			

			#// Mark the current pos as visited.
			mul $t0, $a0, 4
			lw $t1, 12($s3)		# address of canvas->canvas
			add $t1, $t1, $t0	# address of canvas->canvas[row]

			lw $t2, ($t1)     	# canvas->canvas[row];
			add $t3, $t2, $a1	# canvas->canvas[row][col]
			
			sb $a2, ($t3)		# canvas->canvas[row][col] = marker;

			# flood_fill(row - 1, col, marker, canvas);
			addi $a0, $s0, -1
			add $a1, $s1, $0
			add $a2, $s2, $0
			add $a3, $s3, $0

			jal flood_fill

			# flood_fill(row, col + 1, marker, canvas);
			add $a0, $s0, $0
			addi $a1, $s1, 1
			add $a2, $s2, $0
			add $a3, $s3, $0
			jal flood_fill

			# flood_fill(row + 1, col, marker, canvas)
			addi $a0, $s0, 1
			add $a1, $s1, $0
			add $a2, $s2, $0
			add $a3, $s3, $0
			jal flood_fill

			# flood_fill(row, col - 1, marker, canvas);
			add $a0, $s0, $0
			addi $a1, $s1, -1
			add $a2, $s2, $0
			add $a3, $s3, $0			
			jal flood_fill

			
	done:
	

	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s3

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	add $sp, $sp, 20	#dealloc stack
	jr 	$ra



#####

# .globl count_disjoint_regions_step
# count_disjoint_regions_step:
#         # Your code goes here :)
#         sub $sp, $sp, 20	#alloc stack
#         sw $ra, 0($sp)
#         sw $s0, 4($sp)          #a0 marker
#         sw $s1, 8($sp)          #a1 canvas
#         sw $s2, 12($sp)         #row
#         sw $s3, 16($sp)         #col   
#         sw $s4, 20($sp)         #region count

#         #save
#         move $s0, $a0           
#         move $s1, $a1

#         addu $v0, $0, $0        # unsigned int region_count = 0;
        
#         addu $s2, $0, $0         #row

#         for_row:
#         add $t1, $s1, $0
#         lw $t0, ($t1)          # canvas->height
#         bge $s2, $t0, end_row

#                 addu $t2, $0, $0        #col
#                 for_col:
#                 lw $t8, 4($s1)          #canvas->width
#                 bge $t2, $t8, end_col

#                         lw $t7, 12($s1) #canvas->canvas
#                         mul $t8, $s2, 4 #[row]
#                         add $t6, $t7, $t8       #canvas->canvas[row]
#                         lw $t9, ($t6)     	# = canvas->canvas[row];

#                         add $t9, $t9, $t2	# canvas->canvas[row][col]
#                         lb $t3, ($t9)           # curr_char

#                         #if (curr_char != canvas->pattern && curr_char != marker) {
#                         lb $t9, 8($s1)
#                         beq $t3, $t9, a

#                         addu $t9, $s0, $0
#                         beq $t3, $t9, a
                        
#                         if:
#                                 addi $v0, $v0, 1 #   region_count ++;
                                
#                                 #stack save
                                
#                                 move $s2, $s2
#                                 move $s3, $t2
#                                 move $s4, $v0

#                                 #load arguments
#                                 addu $a0, $s2, $0        #row
#                                 addu $a1, $t2, $0        #col
#                                 add $a2, $s0, $0        #marker
#                                 add $a3, $s1, $0        #canvas
                                
#                                 # recurse
#                                         # flood_fill(row, col, marker, canvas);
#                                 jal count_disjoint_regions_step

#                                 add $a0, $s0, $0        #restore marker
#                                 add $a1, $s1, $0        #       canvas
#                                 add $t1, $s2, $0        #       row
#                                 add $t2, $s3, $0        #       col
#                                 add $v0, $s4, $0        #       region_count

#                 a:
#                 addi $t2, $t2, 1
#                 j for_col
#                 end_col:

#         addi $s2, $s2, 1
#         j for_row
#         end_row:

#         lw $ra, 0($sp)
#         lw $s0, 4($sp)
#         lw $s1, 8($sp)
#         lw $s2, 12($sp)
#         lw $s3, 16($sp)
#         lw $s4, 20($sp)

#         add $sp, $sp, 20
#         jr      $ra
