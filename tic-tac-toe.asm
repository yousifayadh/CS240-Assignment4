.data 0x10010000
bitmap:  .space 256
player_x: .asciiz "Player X Wins!\n"
player_O: .asciiz "Player O Wins!\n"
msg_draw: .asciiz "Oooo, a draw!\n"
#set up
.align 2
the_array: .word -1, -1, -1, -1, -1, -1, -1, -1, -1

O: .byte 0xC0, 0xC0
X: .byte 0x80, 0x40
 
 grid:
 .byte 0x24  # 0 0 1 0 0 1 0 0 
 .byte 0x24  # 0 0 1 0 0 1 0 0
 .byte 0xFF  # 1 1 1 1 1 1 1 1 
 .byte 0x24  # 0 0 1 0 0 1 0 0
 .byte 0x24  # 0 0 1 0 0 1 0 0
 .byte 0xFF  # 1 1 1 1 1 1 1 1 
 .byte 0x24  # 0 0 1 0 0 1 0 0
 .byte 0x24  # 0 0 1 0 0 1 0 0
 
 
 
.text
li $t0, 0  #number of X's and O's
li $s0, 0 #turn tracker
la $t1, the_array

  #create board
la $t2, bitmap
li $s2, 0x00FFFFFF
li $s3, 0x000000FF
li $s4, 0x0000FF00
la $t4, grid
li $t8, 8

row_loop:
lbu $t3, 0($t4)
li $t6, 8

pixel_loop:
andi $t5, $t3, 0x80

beqz $t5, skip_the_pixel

sw $s2, 0($t2)

skip_the_pixel:
addiu $t2, $t2, 4

sll $t3, $t3, 1

addiu $t6, $t6, -1

bnez $t6, pixel_loop

addiu $t4, $t4, 1
addiu $t8, $t8, -1
bnez $t8, row_loop


#get user input
user_input_start:
li $t9, 0xffff0000

lw $t7, 0($t9)

andi $t7, $t7, 1

beqz $t7, user_input_start

lw $t5, 4($t9)

blt $t5, 49, user_input_start
bgt $t5, 57, user_input_start

sub $t5, $t5, 49

move $t3, $t5

sll $t5, $t5, 2

#update board
add $t5, $t5, $t1

lw $t2, 0($t5)

bne $t2, -1, user_input_start

sw $s0, 0($t5)

addi $t0, $t0, 1

div $t9, $t3, 3 
rem $t6, $t3, 3


mul $t7, $t9, 3
mul $t8, $t6, 3

sll $t7, $t7, 3

add $t7, $t7, $t8

sll $t7, $t7, 2

la $t2, bitmap

add $t7, $t7, $t2

beq $s0, 0, load_O

la $t4, X

move $s2, $s3
j draw

load_O:
la $t4, O
move $s2, $s4

draw:

li $t8, 2
row_loop1:
lbu $t3, 0($t4)
li $t6, 2

move $t2, $t7

pixel_loop1:
andi $t5, $t3, 0x80

beqz $t5, skip_the_pixel1

sw $s2, 0($t7)

skip_the_pixel1:
addiu $t7, $t7, 4

sll $t3, $t3, 1

addiu $t6, $t6, -1

bnez $t6, pixel_loop1

addiu $t4, $t4, 1
addiu $t2, $t2, 32
move $t7, $t2

addiu $t8, $t8, -1
bnez $t8, row_loop1

xori $s0, $s0, 1


#check if win
lw $t2, 0($t1)
lw $t3, 4($t1)
lw $t4, 8($t1)

beq $t2, -1, check_row2

bne $t2, $t3, check_row2
bne $t3, $t4, check_row2

j player_win

check_row2:
lw $t2, 12($t1)
lw $t3, 16($t1)
lw $t4, 20($t1)

beq $t2, -1, check_row3

bne $t2, $t3, check_row3
bne $t3, $t4, check_row3

j player_win

check_row3:
lw $t2, 24($t1)
lw $t3, 28($t1)
lw $t4, 32($t1)

beq $t2, -1, check_column1

bne $t2, $t3, check_column1
bne $t3, $t4, check_column1

j player_win

check_column1: 
lw $t2, 0($t1)
lw $t3, 12($t1)
lw $t4, 24($t1)

beq $t2, -1, check_column2

bne $t2, $t3, check_column2
bne $t3, $t4, check_column2

j player_win

check_column2:

lw $t2, 4($t1)
lw $t3, 16($t1)
lw $t4, 28($t1)

beq $t2, -1, check_column3

bne $t2, $t3, check_column3
bne $t3, $t4, check_column3

j player_win

check_column3:
lw $t2, 8($t1)
lw $t3, 20($t1)
lw $t4, 32($t1)

beq $t2, -1, check_diagonal1

bne $t2, $t3, check_diagonal1
bne $t3, $t4, check_diagonal1

j player_win

check_diagonal1:

lw $t2, 0($t1)
lw $t3, 16($t1)
lw $t4, 32($t1)

beq $t2, -1, check_diagonal2

bne $t2, $t3, check_diagonal2
bne $t3, $t4, check_diagonal2

j player_win

check_diagonal2:

lw $t2, 8($t1)
lw $t3, 16($t1)
lw $t4, 24($t1)

beq $t2, -1, check_draw

bne $t2, $t3, check_draw
bne $t3, $t4, check_draw

j player_win

check_draw:

beq $t0, 9, player_draw
j user_input_start


player_draw:
     la $a0, msg_draw
     li $v0, 4
     syscall
     
     j freeze_loop
player_win:
     beqz $t2, o_champion
     
     la $a0, player_x
     j print_and_freeze
     
o_champion:
    la $a0, player_O
print_and_freeze:
    li $v0, 4
    syscall
freeze_loop:
j freeze_loop
