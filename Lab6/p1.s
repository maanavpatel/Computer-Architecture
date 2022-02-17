# /**
#  * Given a table of recipes and an inventory of items, this function
#  * will populate times_craftable with the number of times each recipe
#  * can be crafted.
#  *
#  * Note: When passing arrays as parameters, the register $a0 will hold the starting
#  * address of the array, not the contents of the array.
#  */

# void craftable_recipes(int inventory[5], int recipes[10][5], int times_craftable[10]) {
#     const int NUM_ITEMS = 5;
#     const int NUM_RECIPES = 10;

#   -  for (int recipe_idx = 0; recipe_idx < NUM_RECIPES; recipe_idx++) {
#    -     times_craftable[recipe_idx] = 0x7fffffff;  // Largest positive number
#     -    int assigned = 0;

#     b -   for (int item_idx = 0; item_idx < NUM_ITEMS; item_idx++) {
#       -      if (recipes[recipe_idx][item_idx] > 0) {
#                 // If the item is not required for the recipe, skip it
#                 // Note: There is a div psuedoinstruction to do the division
#                 // The format is:
#                 //    div   $rd, $rs, $rt
#        -         int times_item_req = inventory[item_idx] / recipes[recipe_idx][item_idx];
#        c ->        if (times_item_req < times_craftable[recipe_idx]) {
#                     times_craftable[recipe_idx] = times_item_req;
#                     assigned = 1;
#                 }
#             }
#         }

#         if (assigned == 0) {
#             times_craftable[recipe_idx] = 0;
#         }
#     }
# }

.globl craftable_recipes
craftable_recipes:
       


        add $t2, $0, $0        # t2: recipe_idx

        rec_for:
                bge $t2, 10, end_rec

                mul $t3, $t2, 4     # recipe_idx * 4
                add $t3, $a2, $t3   # addy of times_craftable[recipe_idx]
                li $t9, 0x7fffffff

                sw $t9, ($t3)  #store max_int into times_craftable[recipe_idx]   
                
                add $t4, $0, $0    # assigned = 0

                add $t5, $0, $0        # item_idx = 0

                item_for:       #b
                        bge $t5, 5, end_item
                        
                        #t3 has our recipe idx array, just need to add for item_idx
                        mul $t3, $t2, 4     # recipe_idx * 4
                        mul $t3, $t3, 5         # * NUM_COL
                        add $t3, $a1, $t3   # addy of recipes[recipe_idx]

                        mul $t6, $t5, 4         # item_idx * 4
                        add $t6, $t3, $t6       # recipes[recipe_idx][item_idx]
                        lw $t9, ($t6)           # = recipes[recipe_idx][item_idx] 
                        
                        #if (recipes[recipe_idx][item_idx] > 0)
                        ble $t9, $0, a
                                mul $t6, $t5, 4      # item_idx * 4
                                add $t7, $a0, $t6    # inventory[item_idx]   
                                lw $t0, ($t7)        # = inventory[item_idx] 
                                div $t1, $t0, $t9       # times_item_req 
                                                        #   = inventory[item_idx] / recipes[recipe_idx][item_idx]
                                
                                #c
                                mul $t3, $t2, 4     # recipe_idx * 4
                                add $t3, $a2, $t3   # times_craftable[recipe_idx]
                                lw $t9, ($t3)       # = times_craftable[recipe_idx]
                                bge $t1, $t9, a
                                        sw $t1, ($t3)
                                        addi $t4, $0, 1

                        a:
                        addi $t5, $t5, 1
                        j item_for
                        
                end_item:      
        mul $t3, $t2, 4     # recipe_idx * 4
        add $t3, $a2, $t3   # times_craftable[recipe_idx]
        lw $t9, ($t3)       # = times_craftable[recipe_idx]
        bne $t4, $0, e
                sw $0, ($t3)     
        e:
        addi $t2, $t2, 1
        j rec_for

        end_rec:

        jr      $ra