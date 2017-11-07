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
	jal check_array_bounds
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
	slt $t5, $t4, $t2
#_11
	bnez $t5, _label_4
#_12
	li $t0, 0
	move $t4, $t0
#_13
	b _label_1
#_label_2
_label_2:
#_15
	move $a0, $t4
	move $a1, $t3
	jal check_array_bounds
	move $t0, $t4
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	lw $t5, 0($t0)
#_16
	move $a0, $t5
	li $v0, 11
	syscall
#_17
	li $t1, 1
	add $t5, $t4, $t1
#_18
	move $t4, $t5
#_label_1
_label_1:
#_20
	slt $t5, $t4, $t2
#_21
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
check_array_bounds:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	bgez $a0, _ckeck_bound_1
	li $v0, 10
	syscall
_ckeck_bound_1:
	lw $a1, 0($a1)
	blt $a0, $a1, _ckeck_bound_2
	li $v0, 10
	syscall
_ckeck_bound_2:
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	jr $ra
.data
