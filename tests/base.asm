.text
	move $fp, $sp
	addi $fp, $fp, -4
#_main_0
	li $t3, 0
	sw $t3, -36($fp)
#_main_1
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_3
	li $t3, 0
	sw $t3, -32($fp)
#_main_4
	jal _label_main_5
#_label_main_6
_label_main_6:
#_main_6
	lw $t1, -32($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -28($fp)
#_main_7
	lw $a0, -28($fp)
	li $v0, 11
	syscall
#_main_8
	lw $t1, -32($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -24($fp)
#_main_9
	lw $t3, -24($fp)
	sw $t3, -32($fp)
#_label_main_5
_label_main_5:
#_main_11
	lw $t1, -32($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -20($fp)
#_main_12
	li $t0, 1
	lw $t1, -20($fp)
	beq $t1, $t0, _label_main_6
#_main_13
	lw $t1, -32($fp)
	lw $t2, -32($fp)
	mul $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_14
	li $t1, 50
	lw $t2, -12($fp)
	slt $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_15
	li $t0, 1
	lw $t1, -16($fp)
	beq $t1, $t0, _label_main_3
#_main_16
	jal _label_main_4
#_label_main_3
_label_main_3:
#_main_18
	li $a0, 58
	li $v0, 11
	syscall
#_label_main_4
_label_main_4:
#_main_20
	li $a0, 10
	li $v0, 11
	syscall
#_main_21
	lw $t1, -36($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_22
	lw $t3, -8($fp)
	sw $t3, -36($fp)
#_label_main_1
_label_main_1:
#_main_24
	lw $t1, -36($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_25
	li $t0, 1
	lw $t1, -4($fp)
	beq $t1, $t0, _label_main_2
	li $v0, 10
	syscall
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
.data
