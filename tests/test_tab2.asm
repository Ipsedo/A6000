.text
	move $fp, $sp
	lw $a0, 0($a1)
	jal atoi
	move $a0, $v0
	jal main
	li $v0, 10
	syscall
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
	move $a0, $t2
	addi $sp, $sp, 0
	jal make_tab
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	move $t2, $v0
#_main_1
	move $t2, $t2
#_main_2
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	addi $sp, $sp, -8
	move $a0, $t2
	addi $sp, $sp, 0
	jal print_tab
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
make_tab:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -4
	move $t2, $a0
#_make_tab_0
	li $a0, 10
	jal _new_array_
	move $t7, $v0
#_make_tab_1
	move $t3, $t7
#_make_tab_2
	li $t0, 0
	move $t4, $t0
#_make_tab_3
	b _label_make_tab_1
#_label_make_tab_2
_label_make_tab_2:
#_make_tab_5
	move $a0, $t2
	jal _new_array_
	move $t6, $v0
#_make_tab_6
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	move $a2, $t6
	jal _store_in_array
#_make_tab_7
	li $t0, 0
	move $t5, $t0
#_make_tab_8
	b _label_make_tab_3
#_label_make_tab_4
_label_make_tab_4:
#_make_tab_10
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	jal _load_array_elt
	move $t7, $v0
#_make_tab_11
	add $t6, $t4, $t5
#_make_tab_12
	li $t1, 49
	add $t6, $t6, $t1
#_make_tab_13
	move $a0, $t5
	move $a1, $t7
	jal _check_array_bounds
	move $a0, $t7
	move $a1, $t5
	move $a2, $t6
	jal _store_in_array
#_make_tab_14
	li $t1, 1
	add $t7, $t5, $t1
#_make_tab_15
	move $t5, $t7
#_label_make_tab_3
_label_make_tab_3:
#_make_tab_17
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	jal _load_array_elt
	move $t6, $v0
#_make_tab_18
	move $a0, $t6
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t6, $v0
#_make_tab_19
	slt $t7, $t5, $t6
#_make_tab_20
	bnez $t7, _label_make_tab_4
#_make_tab_21
	li $t1, 1
	add $t7, $t4, $t1
#_make_tab_22
	move $t4, $t7
#_label_make_tab_1
_label_make_tab_1:
#_make_tab_24
	move $a0, $t3
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t6, $v0
#_make_tab_25
	slt $t7, $t4, $t6
#_make_tab_26
	bnez $t7, _label_make_tab_2
#_make_tab_27
	sw $t3, -4($fp)
	lw $v0, -4($fp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 12
	jr $ra
print_tab:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_print_tab_0
	li $t0, 0
	move $t3, $t0
#_print_tab_1
	b _label_print_tab_1
#_label_print_tab_2
_label_print_tab_2:
#_print_tab_3
	li $t0, 0
	move $t4, $t0
#_print_tab_4
	b _label_print_tab_3
#_label_print_tab_4
_label_print_tab_4:
#_print_tab_6
	move $a0, $t3
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	move $a1, $t3
	jal _load_array_elt
	move $t5, $v0
#_print_tab_7
	move $a0, $t4
	move $a1, $t5
	jal _check_array_bounds
	move $a0, $t5
	move $a1, $t4
	jal _load_array_elt
	move $t5, $v0
#_print_tab_8
	move $a0, $t5
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_print_tab_9
	li $t1, 1
	add $t5, $t4, $t1
#_print_tab_10
	move $t4, $t5
#_label_print_tab_3
_label_print_tab_3:
#_print_tab_12
	move $a0, $t3
	move $a1, $t2
	jal _check_array_bounds
	move $a0, $t2
	move $a1, $t3
	jal _load_array_elt
	move $t5, $v0
#_print_tab_13
	move $a0, $t5
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t5, $v0
#_print_tab_14
	slt $t5, $t4, $t5
#_print_tab_15
	bnez $t5, _label_print_tab_4
#_print_tab_16
	li $a0, 10
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_print_tab_17
	li $t1, 1
	add $t5, $t3, $t1
#_print_tab_18
	move $t3, $t5
#_label_print_tab_1
_label_print_tab_1:
#_print_tab_20
	move $a0, $t2
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t5, $v0
#_print_tab_21
	slt $t5, $t3, $t5
#_print_tab_22
	bnez $t5, _label_print_tab_2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
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
