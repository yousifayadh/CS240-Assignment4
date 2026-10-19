.data 0x10010000
bitmap:  .space 4096

win_message: .asciiz "You Win!\n"

.text
.globl main
main:

#paint background
la $t2, bitmap
lui $s0, 0x1001
ori $s0, $s0, 0x0000
li $t0, 0x0000AA00
li $t8, 1024
li $s6, 2
li $s7, 2

bg_paint_loop:
sw $t0, 0($t2)
sw $t0, 0($s0)
addiu $t2, $t2, 4
addiu $s0, $s0, 4
subi $t8, $t8, 1
bnez $t8, bg_paint_loop

la $t2, bitmap  
lui $s0, 0x1001  
ori $s0, $s0, 0x0000 

li $s6, 2
li $s7, 2

#draw borders
li $t1, 0
li $t7, 32

draw_horiz_loop:
move $a0, $t1
li $a1, 0
jal draw_wall_pixel

move $a0, $t1
li $a1, 31
jal draw_wall_pixel


addiu $t1, $t1, 1
bne $t1, $t7, draw_horiz_loop

li $t1, 0
li $t7, 32

draw_vert_loop:
li $a0, 0
move $a1, $t1
jal draw_wall_pixel

li $a0, 31 
move $a1, $t1
jal draw_wall_pixel

addiu $t1, $t1, 1
bne $t1, $t7, draw_vert_loop

li $t1, 1
li $t7, 10
draw_vertical_1:
li $a0, 4
move $a1, $t1
jal draw_wall_pixel

addiu $t1, $t1, 1
bne $t1, $t7, draw_vertical_1

li $t1, 4
li $t7, 16

draw_horizontal_1:
move $a0, $t1
li $a1, 6
jal draw_wall_pixel

addiu $t1, $t1, 1
bne $t1, $t7, draw_horizontal_1


li $t1, 2 
li $t7, 18
draw_vertical_2:
li $a0, 12
move $a1, $t1   
jal draw_wall_pixel
addiu $t1, $t1, 1
bne $t1, $t7, draw_vertical_2
  
li $t1, 1
li $t7, 26
draw_horizontal_2:
move $a0, $t1 
li $a1, 14
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_horizontal_2


li $t1, 14
li $t7, 28
draw_vertical_3:
li $a0, 8 
move $a1, $t1 
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_vertical_3

   
li $t1, 4 
li $t7, 22
draw_horizontal_3:
move $a0, $t1 
li $a1, 22
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_horizontal_3

 
li $t1, 6 
li $t7, 26
draw_vertical_4:
li $a0, 18
move $a1, $t1 
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_vertical_4


li $t1, 18
li $t7, 31
draw_horizontal_4:
move $a0, $t1 
li $a1, 10
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_horizontal_4

li $t1, 1 
li $t7, 24
draw_vertical_5:
li $a0, 26
move $a1, $t1 
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_vertical_5


li $t1, 12
li $t7, 29
draw_horizontal_5:
move $a0, $t1 
li $a1, 26
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_horizontal_5

 
li $t1, 14
li $t7, 31
draw_vertical_6:
li $a0, 22
move $a1, $t1 
jal draw_wall_pixel
addiu $t1, $t1, 1 
bne $t1, $t7, draw_vertical_6

#start drawing maze
li $t5, 0x0000AA00

li $a0, 4
li $a1, 3
jal openings

 
li $a0, 10
li $a1, 6
jal openings

 
li $a0, 12
li $a1, 11
jal openings


li $a0, 6
li $a1, 14
jal openings


li $a0, 18
li $a1, 14
jal openings


li $a0, 18
li $a1, 18
jal openings

li $a0, 26
li $a1, 6
jal openings

li $a0, 26
li $a1, 18
jal openings

li $a0, 22
li $a1, 28
jal openings

j bypass

draw_wall_pixel:
 sll $t3, $a1, 5           
    add $t3, $t3, $a0         
    sll $t3, $t3, 2           
    lui $t4, 0x1001           
    ori $t4, $t4, 0x0000      
    add $t4, $t4, $t3
    li $t5, 0x00FFFFFF        
    sw $t5, 0($t4)            
    jr $ra
    
  
openings: 
sll $t3, $a1, 5
add $t3, $t3, $a0
sll $t3, $t3, 2
lui $t4, 0x1001
ori $t4, $t4, 0x0000      
add $t4, $t4, $t3
li $t6, 0x0000AA00        
sw $t6, 0($t4)            
jr $ra

bypass:
maze_generation_done:

li $s6, 2
li $s7, 2


sll $t3, $s7, 5
add $t3, $t3, $s6
sll $t3, $t3, 2

lui $t4, 0x1001
ori $t4, $t4, 0x0000
add $t4, $t4, $t3
li $t5, 0x000000FF
sw $t5, 0($t4)

#create victory block

li $t0, 29
li $t1, 29
sll $t3, $t1, 5
add $t3, $t3, $t0  
sll $t3, $t3, 2       
lui $t4, 0x1001           
ori $t4, $t4, 0x0000      
add $t4, $t4, $t3         
li $t5, 0x00FFFF00        
sw $t5, 0($t4) 

user_input_start:
li $t9, 0xffff0000
lw $t8, 0($t9)
andi $t8, $t8, 1
beqz $t8, user_input_start

lw $t5, 4($t9)

#movement
li $t6, 119
beq $t5, $t6, press_w

li $t6, 97
beq $t5, $t6, press_a

li $t6, 115
beq $t5, $t6, press_s

li $t6, 100
beq $t5, $t6, press_d

j user_input_start

#how the movement works
press_w:
li $s4, 0
li $s5, -1
j move_ready

press_a:
li $s4, -1
li $s5, 0
j move_ready

press_s:
li $s4, 0
li $s5, 1
j move_ready

press_d:
li $s4, 1
li $s5, 0
j move_ready

move_ready:
add $t0, $s6, $s4
add $t1, $s7, $s5

sll $t3, $t1, 5
add $t3, $t3, $t0
sll $t3, $t3, 2

lui $t4, 0x1001
ori $t4, $t4, 0x0000
add $t4, $t4, $t3
lw $t5, 0($t4)

lui $t6, 0x00FF
ori $t6, $t6, 0xFFFF
beq $t5, $t6, collision_hit

lui $t6, 0x00FF
ori $t6, $t6, 0xFF00
beq $t5, $t6, victory_win

sll $t3, $s7, 5
add $t3, $t3, $s6
sll $t3, $t3, 2

lui $t4, 0x1001
ori $t4, $t4, 0x0000
add $t4, $t4, $t3

li $t5, 0x0000AA00
sw $t5, 0($t4)

j render_player 

collision_hit:
j user_input_start

render_player:
move $s6, $t0
move $s7, $t1

sll $t3, $s7, 5
add $t3, $t3, $s6
sll $t3, $t3, 2

lui $t4, 0x1001
ori $t4, $t4, 0x0000
add $t4, $t4, $t3

li $t5, 0x000000FF
sw $t5, 0($t4)

j user_input_start

victory_win:
    
    la $a0, win_message
    li $v0, 4
    syscall

    li $v0, 10
    syscall
