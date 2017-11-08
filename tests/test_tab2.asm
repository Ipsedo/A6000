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
#_0
	li $t0, 0
	move $t4, $t0
#_1
	move $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	li $v0, 9
	move $a0, $t0
	syscall
	move $t0, $t2
	sw $t0, 0($v0)
	move $t5, $v0
#_2
	move $t3, $t5
#_3
	b _label_3
#_label_4
_label_4:
#_5
	li $t1, 49
	add $t5, $t4, $t1
#_6
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $t0, $t4
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	move $t1, $t5
	sw $t1, 0($t0)
#_7
	li $t1, 1
	add $t5, $t4, $t1
#_8
	move $t4, $t5
#_label_3
_label_3:
#_10
	li $t1, 1
	add $t5, $t2, $t1
#_11
	slt $t5, $t4, $t5
#_12
	bnez $t5, _label_4
#_13
	li $t0, 0
	move $t4, $t0
#_14
	b _label_1
#_label_2
_label_2:
#_16
	move $a0, $t4
	move $a1, $t3
	jal _check_array_bounds
	move $t0, $t4
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	lw $t5, 0($t0)
#_17
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	sw $t6, -20($sp)
	addi $sp, $sp, -20
	move $a0, $t5
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
	addi $sp, $sp, 20
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	lw $t6, -20($sp)
#_18
	li $t1, 1
	add $t5, $t4, $t1
#_19
	move $t4, $t5
#_label_1
_label_1:
#_21
	slt $t5, $t4, $t2
#_22
	bnez $t5, _label_2
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
