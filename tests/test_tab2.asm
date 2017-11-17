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
	li $t0, 5
	li $t1, 1
	add $t7, $t0, $t1
#_main_1
	li $t1, 1
	add $t7, $t7, $t1
#_main_2
	li $t1, 1
	add $t7, $t7, $t1
#_main_3
	li $t1, 1
	add $t7, $t7, $t1
#_main_4
	li $t1, 1
	add $t7, $t7, $t1
#_main_5
	move $a0, $t7
	jal _new_array_
	move $t7, $v0
#_main_6
	move $t3, $t7
#_main_7
	li $t0, 0
	move $t4, $t0
#_main_8
	b _label_main_5
#_label_main_6
_label_main_6:
#_main_10
	move $a0, $t2
	jal _new_array_
	move $t6, $v0
#_main_11
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	move $a2, $t6
	jal _store_in_array
#_main_12
	li $t0, 0
	move $t5, $t0
#_main_13
	b _label_main_7
#_label_main_8
_label_main_8:
#_main_15
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	jal _load_array_elt
	move $t7, $v0
#_main_16
	add $t6, $t4, $t5
#_main_17
	li $t1, 49
	add $t6, $t6, $t1
#_main_18
	move $a0, $t5
	move $a1, $t7
	jal _check_array_bounds
	move $a0, $t7
	move $a1, $t5
	move $a2, $t6
	jal _store_in_array
#_main_19
	li $t1, 1
	add $t7, $t5, $t1
#_main_20
	move $t5, $t7
#_label_main_7
_label_main_7:
#_main_22
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	jal _load_array_elt
	move $t6, $v0
#_main_23
	move $a0, $t6
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t6, $v0
#_main_24
	slt $t7, $t5, $t6
#_main_25
	bnez $t7, _label_main_8
#_main_26
	li $t1, 1
	add $t7, $t4, $t1
#_main_27
	move $t4, $t7
#_label_main_5
_label_main_5:
#_main_29
	move $a0, $t3
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t6, $v0
#_main_30
	slt $t7, $t4, $t6
#_main_31
	bnez $t7, _label_main_6
#_main_32
	li $t0, 0
	move $t4, $t0
#_main_33
	b _label_main_1
#_label_main_2
_label_main_2:
#_main_35
	li $t0, 0
	move $t5, $t0
#_main_36
	b _label_main_3
#_label_main_4
_label_main_4:
#_main_38
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	jal _load_array_elt
	move $t7, $v0
#_main_39
	move $a0, $t5
	move $a1, $t7
	jal _check_array_bounds
	move $a0, $t7
	move $a1, $t5
	jal _load_array_elt
	move $t7, $v0
#_main_40
	move $a0, $t7
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_main_41
	li $t1, 1
	add $t7, $t5, $t1
#_main_42
	move $t5, $t7
#_label_main_3
_label_main_3:
#_main_44
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $a0, $t3
	move $a1, $t4
	jal _load_array_elt
	move $t6, $v0
#_main_45
	move $a0, $t6
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t6, $v0
#_main_46
	slt $t7, $t5, $t6
#_main_47
	bnez $t7, _label_main_4
#_main_48
	li $a0, 10
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
#_main_49
	li $t1, 1
	add $t7, $t4, $t1
#_main_50
	move $t4, $t7
#_label_main_1
_label_main_1:
#_main_52
	move $a0, $t3
	addi $sp, $sp, 0
	jal arr_length
	addi $sp, $sp, 0
	move $t6, $v0
#_main_53
	slt $t7, $t4, $t6
#_main_54
	bnez $t7, _label_main_2
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
