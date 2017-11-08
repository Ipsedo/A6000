.text
	move $fp, $sp
	lw $a0, 0($a1)
	jal atoi
	move $a0, $v0
	jal main
	li $v0, 10
	syscall
log10:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_0
	li $t1, 1000000
	sge $t3, $t2, $t1
#_1
	bnez $t3, _label_1
#_2
	li $t1, 100000
	sge $t3, $t2, $t1
#_3
	bnez $t3, _label_3
#_4
	li $t1, 10000
	sge $t3, $t2, $t1
#_5
	bnez $t3, _label_5
#_6
	li $t1, 1000
	sge $t3, $t2, $t1
#_7
	bnez $t3, _label_7
#_8
	li $t1, 100
	sge $t3, $t2, $t1
#_9
	bnez $t3, _label_9
#_10
	li $t1, 10
	sge $t3, $t2, $t1
#_11
	bnez $t3, _label_11
#_12
	li $t0, 0
	move $t2, $t0
#_13
	b _label_12
#_label_11
_label_11:
#_15
	li $t0, 1
	move $t2, $t0
#_label_12
_label_12:
#_17
	b _label_10
#_label_9
_label_9:
#_19
	li $t0, 2
	move $t2, $t0
#_label_10
_label_10:
#_21
	b _label_8
#_label_7
_label_7:
#_23
	li $t0, 3
	move $t2, $t0
#_label_8
_label_8:
#_25
	b _label_6
#_label_5
_label_5:
#_27
	li $t0, 4
	move $t2, $t0
#_label_6
_label_6:
#_29
	b _label_4
#_label_3
_label_3:
#_31
	li $t0, 5
	move $t2, $t0
#_label_4
_label_4:
#_33
	b _label_2
#_label_1
_label_1:
#_35
	li $t0, 6
	move $t2, $t0
#_label_2
_label_2:
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
#_37
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	sw $t6, -20($sp)
	sw $t7, -24($sp)
	sw $t8, -28($sp)
	addi $sp, $sp, -28
	move $a0, $t2
	addi $sp, $sp, 0
	jal log10
	addi $sp, $sp, 0
	addi $sp, $sp, 28
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	lw $t6, -20($sp)
	lw $t7, -24($sp)
	lw $t8, -28($sp)
	move $t3, $v0
#_38
	li $t1, 1
	add $t3, $t3, $t1
#_39
	move $t6, $t3
#_40
	move $t0, $t6
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	li $v0, 9
	move $a0, $t0
	syscall
	move $t0, $t6
	sw $t0, 0($v0)
	move $t3, $v0
#_41
	move $t5, $t3
#_42
	li $t0, 0
	move $t7, $t0
#_43
	b _label_13
#_label_14
_label_14:
#_45
	li $t1, 10
	div $t3, $t2, $t1
#_46
	move $t3, $t3
#_47
	li $t1, 10
	mul $t3, $t3, $t1
#_48
	move $t3, $t3
#_49
	sub $t3, $t2, $t3
#_50
	move $t3, $t3
#_51
	move $a0, $t7
	move $a1, $t5
	jal _check_array_bounds
	move $t0, $t7
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t5
	add $t0, $t0, $t1
	move $t1, $t3
	sw $t1, 0($t0)
#_52
	li $t1, 10
	div $t3, $t2, $t1
#_53
	move $t2, $t3
#_54
	li $t1, 1
	add $t3, $t7, $t1
#_55
	move $t7, $t3
#_label_13
_label_13:
#_57
	slt $t3, $t7, $t6
#_58
	bnez $t3, _label_14
#_59
	move $t4, $t5
	move $v0, $t4
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
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
.data
_array_out_of_bounds_string:
	.asciiz "Array out of Bounds : "
