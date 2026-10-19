.data 0x10010000
bitmap:  .space 4096
player_wins: .asciiz "Player Wins!\n"
dealer_wins: .asciiz "Dealer Wins!\n"
msg_draw: .asciiz "Oooo, a draw!\n"
#set up

.data
.align 2
A:  .byte 0xF8, 0x98, 0x68, 0x08, 0x68, 0x68, 0xF8  # Clear 'A'
.align 2
C2: .byte 0xF8, 0x08, 0xE8, 0x98, 0x78, 0x08, 0xF8  # Clear '2'
.align 2
C3: .byte 0xF8, 0x08, 0xE8, 0x98, 0xE8, 0x08, 0xF8  # Clear '3'
.align 2
C4: .byte 0xF8, 0x68, 0x68, 0x08, 0xE8, 0xE8, 0xF8  # Clear '4'
.align 2
C5: .byte 0xF8, 0x08, 0x78, 0x08, 0xE8, 0x08, 0xF8  # Clear '5'
.align 2
C6: .byte 0xF8, 0x08, 0x78, 0x08, 0x68, 0x08, 0xF8  # Clear '6'
.align 2
C7: .byte 0xF8, 0x08, 0xE8, 0xD8, 0xB8, 0x78, 0xF8  # Clear '7'
.align 2
C8: .byte 0xF8, 0x08, 0x68, 0x08, 0x68, 0x08, 0xF8  # Clear '8'
.align 2
C9: .byte 0xF8, 0x08, 0x68, 0x08, 0xE8, 0x08, 0xF8  # Clear '9'
.align 2
T:  .byte 0xF8, 0x40, 0x50, 0x50, 0x50, 0x40, 0xF8 
.align 2
J:  .byte 0xF8, 0xC8, 0xE8, 0xE8, 0x68, 0x98, 0xF8  # Clear 'J'
.align 2
Q:  .byte 0xF8, 0x98, 0x68, 0x68, 0x48, 0x90, 0xF8  # Clear 'Q' with tail
.align 2
K:  .byte 0xF8, 0x68, 0x58, 0x38, 0x58, 0x68, 0xF8  # Clear 'K'



 
 grid:
 .byte 0x00 # 0 0 1 0 0 1 0 0 
 .byte 0x00  # 0 0 1 0 0 1 0 0
 .byte 0x00  # 1 1 1 1 1 1 1 1 
 .byte 0x00  # 0 0 1 0 0 1 0 0
 .byte 0x00  # 0 0 1 0 0 1 0 0
 .byte 0x00  # 1 1 1 1 1 1 1 1 
 .byte 0x00 # 0 0 1 0 0 1 0 0
 .byte 0x00  # 0 0 1 0 0 1 0 0
 
 

.text
li $s0, 0  #playerScore
li $s1, 0 #dealerScore
li $s5, 0 #playerAceTracker
li $s6, 0 #dealerAceTracker

  #create board
la $t2, bitmap
move $s2, $t2
addi $s3, $t2, 2048
li $t0, 0x0000AA00
li $t8, 1024

bg_paint_loop:
sw $t0, 0($t2)

addiu $t2, $t2, 4
subi $t8, $t8, 1
bnez $t8, bg_paint_loop

li $s7, 2
jal begin_deal

li $s7, 2
jal begin_deal

li $s7, 1
jal begin_deal

move $ra, $zero
sw $zero, 0($sp)

j user_input_start

begin_deal:
subiu $sp, $sp, 4

sw $ra, 0($sp)
j roll_card

generate_card_now:
roll_card:
dealer_turn:
dealer_roll:

li $a0, 0
li $a1, 13
li $v0, 42

syscall 

move $t1, $a0

addi $t1, $t1, 1

beq $t1, 1, draw_ace 
beq $t1, 2, draw_two
beq $t1, 3, draw_three
beq $t1, 4, draw_four
beq $t1, 5, draw_five
beq $t1, 6, draw_six
beq $t1, 7, draw_seven
beq $t1, 8, draw_eight
beq $t1, 9, draw_nine
beq $t1, 10, draw_ten
beq $t1, 11, draw_jack
beq $t1, 12, draw_queen
beq $t1, 13, draw_king

draw_ace:
beq $s7, 1, dealer_draw_ace
la $t0, A
addi $s0, $s0, 11
addi $s5, $s5, 1
j check_bust

dealer_draw_ace:
la $t0, A
addi $s1, $s1, 11
addi $s6, $s6, 1
j check_bust

draw_two:
beq $s7, 1, dealer_draw_two
la $t0, C2
addi $s0, $s0, 2
j check_bust

dealer_draw_two:
la $t0, C2
addi $s1, $s1, 2
j check_bust

draw_three:
beq $s7, 1, dealer_draw_three
la $t0, C3
addi $s0, $s0, 3
j check_bust

dealer_draw_three:
la $t0, C3
addi $s1, $s1, 3
j check_bust

draw_four:
beq $s7, 1, dealer_draw_four
la $t0, C4
addi $s0, $s0, 4
j check_bust

dealer_draw_four:
la $t0, C4
addi $s1, $s1, 4
j check_bust

draw_five:
beq $s7, 1, dealer_draw_five
la $t0, C5
addi $s0, $s0, 5
j check_bust

dealer_draw_five:
la $t0, C5
addi $s1, $s1, 5
j check_bust

draw_six:
beq $s7, 1, dealer_draw_six
la $t0, C6
addi $s0, $s0, 6
j check_bust

dealer_draw_six:
la $t0, C6
addi $s1, $s1, 6
j check_bust

draw_seven:
beq $s7, 1, dealer_draw_seven
la $t0, C7
addi $s0, $s0, 7
j check_bust

dealer_draw_seven:
la $t0, C7
addi $s1, $s1, 7
j check_bust


draw_eight:
beq $s7, 1, dealer_draw_eight
la $t0, C8
addi $s0, $s0, 8
j check_bust

dealer_draw_eight:
la $t0, C8
addi $s1, $s1, 8
j check_bust

draw_nine:
beq $s7, 1, dealer_draw_nine
la $t0, C9
addi $s0, $s0, 9
j check_bust

dealer_draw_nine:
la $t0, C9
addi $s1, $s1, 9
j check_bust

draw_ten:
la $t0, T
j check_dealer_branch
draw_jack:
la $t0, J
j check_dealer_branch
draw_queen:
la $t0, Q
j check_dealer_branch
draw_king:
la $t0, K

check_dealer_branch:
beq $s7, 1, dealer_full_start

full_start:
addi $s0, $s0, 10
j check_bust

dealer_full_start:
addi $s1, $s1, 10
j check_bust



check_bust:
beq $s7, 1, check_dealer_bust
check_player_bust:
ble $s0, 21, end_check_bust
beq $s5, 0, end_check_bust
subi $s0, $s0, 10
subi $s5, $s5, 1
j check_player_bust

check_dealer_bust:
ble $s1, 21, end_check_bust
beq $s6, 0, end_check_bust
subi $s1, $s1, 10
subi $s6, $s6, 1
j check_dealer_bust

end_check_bust:
beq $s7, 1, dealer_draw
move $t7, $s3
j end_check


dealer_draw:
move $t7, $s2

end_check:
li $t8, 7

card_row_loop:
lbu $t3, 0($t0)
li $t6, 5

card_pixel_loop:
andi $t5, $t3, 0x80
bnez $t5, paint_card_white
sw $zero, 0($t7)
j advance_pixel

paint_card_white:
li $t1, 0x00FFFFFF
sw $t1, 0($t7)

advance_pixel:
addiu $t7, $t7, 4
sll $t3, $t3, 1
subi $t6, $t6, 1
bnez $t6, card_pixel_loop

addiu $t0, $t0, 1
addiu $t7, $t7, 108
subi $t8, $t8, 1
bnez $t8, card_row_loop
beq $s7, 1, shift_dealer_anchor

addi $s3, $s3, 24

j finish_anchor_shift

shift_dealer_anchor:

addi $s2, $s2, 24

finish_anchor_shift:

lw $ra, 0($sp)
beqz $ra, live_gameplay_flow
addiu $sp, $sp, 4
jr $ra

live_gameplay_flow:
bgt $s0, 21, dealer_win
bgt $s1, 21, player_win

normal_flow:
beq $s7, 2, user_input_start
beq $s7, 1, dealer_decision_rules
subi $s7, $s7, 1
bgt $s7, 0, roll_card
j user_input_start

dealer_decision_rules:
blt $s1, 17, dealer_roll_again  
bgt $s1, 21, player_win         
bgt $s1, $s0, dealer_win
bgt $s0, $s1, player_win
beq $s0, $s1, player_draw

dealer_roll_again:
li $s7, 1                       
j roll_card

check_dealer_aces:
beq $s6, 0, player_win
subi $s1, $s1, 10
subi $s6, $s6, 1
j dealer_decision_rules

user_input_start:
li $t9, 0xffff0000
lw $t8, 0($t9)
andi $t8, $t8, 1
beqz $t8, user_input_start
lw $t5, 4($t9)
beq $t5, 104, player_hit
beq $t5, 115, start_dealer
j user_input_start

player_hit:
li $s7, 2
j generate_card_now

start_dealer:
li $s7, 1
j dealer_decision_rules

player_draw:
     la $a0, msg_draw
     li $v0, 4
     syscall
     j freeze_loop
     
player_win:
     la $a0, player_wins
     li $v0, 4
     syscall
     j freeze_loop
    
dealer_win:
     la $a0, dealer_wins
     li $v0, 4
     syscall 
     j freeze_loop

freeze_loop:
j freeze_loop
