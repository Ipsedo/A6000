.text
	move $fp, $sp
	addi $fp, $fp, -4
#_main_0
	li $t3, 1
	sw $t3, -40($fp)
#_main_1
	li $t3, 0
	sw $t3, -44($fp)
#_main_2
	li $t3, 50
	sw $t3, -52($fp)
#_main_3
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_5
	li $t3, 0
	sw $t3, -40($fp)
#_main_6
	li $t3, 0
	sw $t3, -48($fp)
#_main_7
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_9
	lw $t1, -44($fp)
	lw $t2, -44($fp)
	mul $t0, $t1, $t2
	sw $t0, -20($fp)
#_main_10
	lw $t1, -48($fp)
	lw $t2, -48($fp)
	mul $t0, $t1, $t2
	sw $t0, -24($fp)
#_main_11
	lw $t1, -20($fp)
	lw $t2, -24($fp)
	add $t0, $t1, $t2
	sw $t0, -28($fp)
#_main_12
	lw $t1, -52($fp)
	lw $t2, -52($fp)
	mul $t0, $t1, $t2
	sw $t0, -32($fp)
#_main_13
	lw $t1, -28($fp)
	lw $t2, -32($fp)
	slt $t0, $t1, $t2
	sw $t0, -36($fp)
#_main_14
	li $t0, 1
	lw $t1, -36($fp)
	beq $t1, $t0, _label_main_5
#_main_15
	li $a0, 35
	li $v0, 11
	syscall
#_main_16
	jal _label_main_6
#_label_main_5
_label_main_5:
#_main_18
	li $a0, 46
	li $v0, 11
	syscall
#_main_19
	li $t3, 1
	sw $t3, -40($fp)
#_label_main_6
_label_main_6:
#_main_21
	li $a0, 32
	li $v0, 11
	syscall
#_main_22
	lw $t1, -48($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_23
	lw $t3, -16($fp)
	sw $t3, -48($fp)
#_label_main_3
_label_main_3:
#_main_25
	lw $t1, -52($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_26
	lw $t1, -48($fp)
	lw $t2, -8($fp)
	slt $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_27
	li $t0, 1
	lw $t1, -12($fp)
	beq $t1, $t0, _label_main_4
#_main_28
	li $a0, 10
	li $v0, 11
	syscall
#_main_29
	lw $t1, -44($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_30
	lw $t3, -4($fp)
	sw $t3, -44($fp)
#_label_main_1
_label_main_1:
#_main_32
	li $t0, 1
	lw $t1, -40($fp)
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
