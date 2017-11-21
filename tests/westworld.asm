.text
	move $fp, $sp
	lw $a0, 0($a1)
	jal atoi
	move $a0, $v0
	jal main
	li $v0, 10
	syscall
bass:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -4
#_bass_0
	li $a0, 6
	jal _new_array_
	move $t2, $v0
#_bass_1
	move $t2, $t2
#_bass_2
	li $a0, 0
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 0
	li $a2, 0
	jal _store_in_array
#_bass_3
	li $a0, 1
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 1
	li $a2, 2
	jal _store_in_array
#_bass_4
	li $a0, 2
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 2
	li $a2, 7
	jal _store_in_array
#_bass_5
	li $a0, 3
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 3
	li $a2, 14
	jal _store_in_array
#_bass_6
	li $a0, 4
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 4
	li $a2, 15
	jal _store_in_array
#_bass_7
	li $a0, 5
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 5
	li $a2, 15
	jal _store_in_array
#_bass_8
	sw $t2, -4($fp)
	lw $v0, -4($fp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 12
	jr $ra
blank:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -4
	move $t2, $a0
	move $t6, $a1
#_blank_0
	move $a0, $t6
	jal _new_array_
	move $t8, $v0
#_blank_1
	move $t7, $t8
#_blank_2
	li $t0, 0
	move $t5, $t0
#_blank_3
	b _label_blank_1
#_label_blank_2
_label_blank_2:
#_blank_5
	move $a0, $t2
	jal _new_array_
	move $t8, $v0
#_blank_6
	move $t3, $t8
#_blank_7
	li $t0, 0
	move $t4, $t0
#_blank_8
	b _label_blank_3
#_label_blank_4
_label_blank_4:
#_blank_10
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	li $a2, 0
	jal _store_in_array
#_blank_11
	li $t1, 1
	add $t8, $t4, $t1
#_blank_12
	move $t4, $t8
#_label_blank_3
_label_blank_3:
#_blank_14
	slt $t8, $t4, $t2
#_blank_15
	bnez $t8, _label_blank_4
#_blank_16
	move $a0, $t5
	move $a1, $t7
	jal _check_array_bounds
	move $a0, $t7
	move $a1, $t5
	move $a2, $t3
	jal _store_in_array
#_blank_17
	li $t1, 1
	add $t8, $t5, $t1
#_blank_18
	move $t5, $t8
#_label_blank_1
_label_blank_1:
#_blank_20
	slt $t8, $t5, $t6
#_blank_21
	bnez $t8, _label_blank_2
#_blank_22
	sw $t7, -4($fp)
	lw $v0, -4($fp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 12
	jr $ra
burn:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -8
	move $t9, $a0
	move $t6, $a1
	move $t7, $a2
	move $t3, $a3
	lw $t2, 12($fp)
#_burn_0
	li $t0, 0
	move $t4, $t0
#_burn_1
	b _label_burn_1
#_label_burn_2
_label_burn_2:
#_burn_3
	li $t0, 0
	move $t8, $t0
#_burn_4
	move $a0, $t4
	move $a1, $t6
	jal _check_array_bounds
	move $a0, $t6
	move $a1, $t4
	jal _load_array_elt
	sw $v0, -4($fp)
#_burn_5
	lw $t0, -4($fp)
	add $t0, $t0, $t2
	sw $t0, -4($fp)
#_burn_6
	lw $t0, -4($fp)
	move $t5, $t0
#_burn_7
	b _label_burn_3
#_label_burn_4
_label_burn_4:
#_burn_9
	mul $t0, $t4, $t3
	sw $t0, -8($fp)
#_burn_10
	lw $t0, -8($fp)
	add $t0, $t0, $t8
	sw $t0, -8($fp)
#_burn_11
	lw $a0, -8($fp)
	move $a1, $t9
	jal _check_array_bounds
	move $a0, $t9
	lw $a1, -8($fp)
	jal _load_array_elt
	sw $v0, -4($fp)
#_burn_12
	move $a0, $t5
	lw $a1, -4($fp)
	jal _check_array_bounds
	lw $a0, -4($fp)
	move $a1, $t5
	li $a2, 1
	jal _store_in_array
#_burn_13
	li $t1, 1
	add $t0, $t8, $t1
	sw $t0, -4($fp)
#_burn_14
	lw $t0, -4($fp)
	move $t8, $t0
#_label_burn_3
_label_burn_3:
#_burn_16
	slt $t0, $t8, $t3
	sw $t0, -4($fp)
#_burn_17
	lw $t0, -4($fp)
	bnez $t0, _label_burn_4
#_burn_18
	li $t1, 1
	add $t0, $t4, $t1
	sw $t0, -4($fp)
#_burn_19
	lw $t0, -4($fp)
	move $t4, $t0
#_label_burn_1
_label_burn_1:
#_burn_21
	slt $t0, $t4, $t7
	sw $t0, -4($fp)
#_burn_22
	lw $t0, -4($fp)
	bnez $t0, _label_burn_2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 16
	jr $ra
main:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_main_0
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	addi $sp, $sp, -8
	addi $sp, $sp, 0
	jal westworld
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	move $t2, $v0
#_main_1
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	addi $sp, $sp, -8
	move $a0, $t2
	li $a1, 40
	li $a2, 24
	addi $sp, $sp, 0
	jal play
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
play:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t5, $a0
	move $t2, $a1
	move $t3, $a2
#_play_0
	li $t1, 1
	sub $t6, $t3, $t1
#_play_1
	move $t4, $t6
#_play_2
	b _label_play_1
#_label_play_2
_label_play_2:
#_play_4
	li $t1, 1
	sub $t6, $t2, $t1
#_play_5
	move $t3, $t6
#_play_6
	b _label_play_3
#_label_play_4
_label_play_4:
#_play_8
	move $a0, $t4
	move $a1, $t5
	jal _check_array_bounds
	move $a0, $t5
	move $a1, $t4
	jal _load_array_elt
	move $t6, $v0
#_play_9
	move $a0, $t3
	move $a1, $t6
	jal _check_array_bounds
	move $a0, $t6
	move $a1, $t3
	jal _load_array_elt
	move $t6, $v0
#_play_10
	bnez $t6, _label_play_5
#_play_11
	li $a0, 32
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_play_12
	li $a0, 32
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_play_13
	b _label_play_6
#_label_play_5
_label_play_5:
#_play_15
	li $a0, 35
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_play_16
	li $a0, 35
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_label_play_6
_label_play_6:
#_play_18
	li $t1, 1
	sub $t6, $t3, $t1
#_play_19
	move $t3, $t6
#_label_play_3
_label_play_3:
#_play_21
	li $t0, 0
	sle $t6, $t0, $t3
#_play_22
	bnez $t6, _label_play_4
#_play_23
	li $a0, 10
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_play_24
	li $t1, 1
	sub $t6, $t4, $t1
#_play_25
	move $t4, $t6
#_label_play_1
_label_play_1:
#_play_27
	li $t0, 0
	sle $t6, $t0, $t4
#_play_28
	bnez $t6, _label_play_2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
repeat:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -4
	move $t4, $a0
	move $t5, $a1
#_repeat_0
	li $t0, 2
	mul $t6, $t0, $t5
#_repeat_1
	move $a0, $t6
	jal _new_array_
	move $t6, $v0
#_repeat_2
	move $t3, $t6
#_repeat_3
	li $t0, 0
	move $t2, $t0
#_repeat_4
	b _label_repeat_1
#_label_repeat_2
_label_repeat_2:
#_repeat_6
	move $a0, $t2
	move $a1, $t4
	jal _check_array_bounds
	move $a0, $t4
	move $a1, $t2
	jal _load_array_elt
	move $t6, $v0
#_repeat_7
	move $a0, $t2
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t2
	move $a2, $t6
	jal _store_in_array
#_repeat_8
	add $t7, $t2, $t5
#_repeat_9
	move $a0, $t2
	move $a1, $t4
	jal _check_array_bounds
	move $a0, $t4
	move $a1, $t2
	jal _load_array_elt
	move $t6, $v0
#_repeat_10
	move $a0, $t7
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t7
	move $a2, $t6
	jal _store_in_array
#_repeat_11
	li $t1, 1
	add $t6, $t2, $t1
#_repeat_12
	move $t2, $t6
#_label_repeat_1
_label_repeat_1:
#_repeat_14
	slt $t6, $t2, $t5
#_repeat_15
	bnez $t6, _label_repeat_2
#_repeat_16
	sw $t3, -4($fp)
	lw $v0, -4($fp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 12
	jr $ra
theme:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -4
#_theme_0
	li $a0, 12
	jal _new_array_
	move $t2, $v0
#_theme_1
	move $t2, $t2
#_theme_2
	li $a0, 0
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 0
	li $a2, 14
	jal _store_in_array
#_theme_3
	li $a0, 1
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 1
	li $a2, 14
	jal _store_in_array
#_theme_4
	li $a0, 2
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 2
	li $a2, 15
	jal _store_in_array
#_theme_5
	li $a0, 3
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 3
	li $a2, 14
	jal _store_in_array
#_theme_6
	li $a0, 4
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 4
	li $a2, 14
	jal _store_in_array
#_theme_7
	li $a0, 5
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 5
	li $a2, 15
	jal _store_in_array
#_theme_8
	li $a0, 6
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 6
	li $a2, 14
	jal _store_in_array
#_theme_9
	li $a0, 7
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 7
	li $a2, 12
	jal _store_in_array
#_theme_10
	li $a0, 8
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 8
	li $a2, 10
	jal _store_in_array
#_theme_11
	li $a0, 9
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 9
	li $a2, 10
	jal _store_in_array
#_theme_12
	li $a0, 10
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 10
	li $a2, 10
	jal _store_in_array
#_theme_13
	li $a0, 11
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	li $a1, 11
	li $a2, 10
	jal _store_in_array
#_theme_14
	sw $t2, -4($fp)
	lw $v0, -4($fp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 12
	jr $ra
westworld:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -4
#_westworld_0
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	li $a0, 40
	li $a1, 24
	addi $sp, $sp, 0
	jal blank
	addi $sp, $sp, 0
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	move $t2, $v0
#_westworld_1
	move $t2, $t2
#_westworld_2
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	addi $sp, $sp, 0
	jal theme
	addi $sp, $sp, 0
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	move $t3, $v0
#_westworld_3
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	li $a2, 12
	li $a3, 2
	li $t0, 12
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	jal burn
	addi $sp, $sp, 4
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
#_westworld_4
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	addi $sp, $sp, 0
	jal theme
	addi $sp, $sp, 0
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	move $t3, $v0
#_westworld_5
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	li $a2, 12
	li $a3, 2
	li $t0, 24
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	jal burn
	addi $sp, $sp, 4
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
#_westworld_6
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	addi $sp, $sp, 0
	jal bass
	addi $sp, $sp, 0
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	move $t3, $v0
#_westworld_7
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t3
	li $a1, 6
	addi $sp, $sp, 0
	jal repeat
	addi $sp, $sp, 0
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	move $t3, $v0
#_westworld_8
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t3
	li $a1, 12
	addi $sp, $sp, 0
	jal repeat
	addi $sp, $sp, 0
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	move $t3, $v0
#_westworld_9
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	li $a2, 24
	li $a3, 1
	li $t0, 0
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	jal burn
	addi $sp, $sp, 4
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
#_westworld_10
	sw $t2, -4($fp)
	lw $v0, -4($fp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 12
	jr $ra
_new_array_:
	move $t0, $a0
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	li $v0, 9
	move $t1, $a0
	move $a0, $t0
	syscall
	sw $t1, 0($v0)
	jr $ra
_load_array_elt:
	move $t0, $a1
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $a0
	add $t0, $t0, $t1
	lw $v0, 0($t0)
	jr $ra
_store_in_array:
	move $t0, $a1
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $a0
	add $t0, $t0, $t1
	move $t1, $a2
	sw $t1, 0($t0)
	jr $ra
atoi:
	move $t0, $a0
	li $t1, 0
	li $t2, 10
atoi_loop:
	lbu $t3, 0($t0)
	beq $t3, $zero, atoi_end
	li $t4, 48
	blt $t3, $t4, atoi_error
	li $t4, 57
	bgt $t3, $t4, atoi_error
	addi $t3, $t3, -48
	mul $t1, $t1, $t2
	add $t1, $t1, $t3
	addi $t0, $t0, 1
	b atoi_loop
atoi_error:
	li $v0, 10
	syscall
atoi_end:
	move $v0, $t1
	jr $ra
_check_array_bounds:
	bgez $a0, _ckeck_bound_1
	move $t0, $a0
	li $v0, 4
	la $a0, _array_out_of_bounds_string
	syscall
	li $a0, 45
	jal print
	neg $t0, $t0
	addi $a0, $t0, 48
	jal print
	li $a0, 10
	jal print
	li $v0, 10
	syscall
_ckeck_bound_1:
	lw $a1, 0($a1)
	blt $a0, $a1, _ckeck_bound_2
	move $t0, $a0
	li $v0, 4
	la $a0, _array_out_of_bounds_string
	syscall
	addi $a0, $t0, 48
	jal print
	li $a0, 10
	jal print
	li $v0, 10
	syscall
_ckeck_bound_2:
	jr $ra
print:
	li $v0, 11
	syscall
	jr $ra
log10:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
	li $t1, 1000000
	sge $t3, $t2, $t1
	bnez $t3, _label_log10_1
	li $t1, 100000
	sge $t3, $t2, $t1
	bnez $t3, _label_log10_3
	li $t1, 10000
	sge $t3, $t2, $t1
	bnez $t3, _label_log10_5
	li $t1, 1000
	sge $t3, $t2, $t1
	bnez $t3, _label_log10_7
	li $t1, 100
	sge $t3, $t2, $t1
	bnez $t3, _label_log10_9
	li $t1, 10
	sge $t3, $t2, $t1
	bnez $t3, _label_log10_11
	li $t0, 0
	move $t2, $t0
	b _label_log10_12
_label_log10_11:
	li $t0, 1
	move $t2, $t0
_label_log10_12:
	b _label_log10_10
_label_log10_9:
	li $t0, 2
	move $t2, $t0
_label_log10_10:
	b _label_log10_8
_label_log10_7:
	li $t0, 3
	move $t2, $t0
_label_log10_8:
	b _label_log10_6
_label_log10_5:
	li $t0, 4
	move $t2, $t0
_label_log10_6:
	b _label_log10_4
_label_log10_3:
	li $t0, 5
	move $t2, $t0
_label_log10_4:
	b _label_log10_2
_label_log10_1:
	li $t0, 6
	move $t2, $t0
_label_log10_2:
	move $v0, $t2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
string_of_int:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	sw $t6, -20($sp)
	sw $t7, -24($sp)
	addi $sp, $sp, -24
	move $a0, $t2
	addi $sp, $sp, 0
	jal log10
	addi $sp, $sp, 0
	addi $sp, $sp, 24
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	lw $t6, -20($sp)
	lw $t7, -24($sp)
	move $t3, $v0
	li $t1, 1
	add $t3, $t3, $t1
	move $t6, $t3
	move $a0, $t6
	jal _new_array_
	move $t3, $v0
	move $t5, $t3
	li $t1, 1
	sub $t3, $t6, $t1
	move $t6, $t3
	b _label_string_of_int_13
_label_string_of_int_14:
	li $t1, 10
	div $t3, $t2, $t1
	li $t1, 10
	mul $t3, $t3, $t1
	sub $t3, $t2, $t3
	li $t1, 48
	add $t3, $t3, $t1
	move $a0, $t6
	move $a1, $t5
	jal _check_array_bounds
	move $a0, $t5
	move $a1, $t6
	move $a2, $t3
	jal _store_in_array
	li $t1, 10
	div $t3, $t2, $t1
	move $t2, $t3
	li $t1, 1
	sub $t3, $t6, $t1
	move $t6, $t3
_label_string_of_int_13:
	li $t1, 0
	sge $t3, $t6, $t1
	bnez $t3, _label_string_of_int_14
	move $t4, $t5
	move $v0, $t4
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
arr_length:
	lw $v0, 0($a0)
	jr $ra
.data
_array_out_of_bounds_string:
	.asciiz "Array out of Bounds : "
