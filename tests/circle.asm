.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -48
#_main_0
	li $t5, 1
	sw $t5, -40($fp)
#_main_1
	li $t5, 0
	sw $t5, -44($fp)
#_main_2
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_4
	li $t5, 0
	sw $t5, -40($fp)
#_main_5
	li $t5, 0
	sw $t5, -48($fp)
#_main_6
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_8
	lw $t1, -44($fp)
	lw $t2, -44($fp)
	mul $t0, $t1, $t2
	sw $t0, -20($fp)
#_main_9
	lw $t1, -48($fp)
	lw $t2, -48($fp)
	mul $t0, $t1, $t2
	sw $t0, -24($fp)
#_main_10
	lw $t1, -20($fp)
	lw $t2, -24($fp)
	add $t0, $t1, $t2
	sw $t0, -28($fp)
#_main_11
	lw $t1, -48($fp)
	lw $t2, -48($fp)
	mul $t0, $t1, $t2
	sw $t0, -32($fp)
#_main_12
	lw $t1, -28($fp)
	lw $t2, -32($fp)
	slt $t0, $t1, $t2
	sw $t0, -36($fp)
#_main_13
	li $t0, 1
	lw $t1, -36($fp)
	beq $t1, $t0, _label_main_5
#_main_14
	li $a0, 35
	li $v0, 11
	syscall
#_main_15
	jal _label_main_6
#_label_main_5
_label_main_5:
#_main_17
	li $a0, 46
	li $v0, 11
	syscall
#_main_18
	li $t5, 1
	sw $t5, -40($fp)
#_label_main_6
_label_main_6:
#_main_20
	li $a0, 32
	li $v0, 11
	syscall
#_main_21
	lw $t1, -48($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_22
	lw $t5, -16($fp)
	sw $t5, -48($fp)
#_label_main_3
_label_main_3:
#_main_24
	lw $t1, -48($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_25
	lw $t1, -48($fp)
	lw $t2, -8($fp)
	slt $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_26
	li $t0, 1
	lw $t1, -12($fp)
	beq $t1, $t0, _label_main_4
#_main_27
	li $a0, 10
	li $v0, 11
	syscall
#_main_28
	lw $t1, -44($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_29
	lw $t5, -4($fp)
	sw $t5, -44($fp)
#_label_main_1
_label_main_1:
#_main_31
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
