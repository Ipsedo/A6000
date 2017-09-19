.text
	move $fp, $sp
	addi $fp, $fp, -4
#_main_0
	li $t7, 0
	sw $t7, -28($fp)
#_main_1
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_3
	li $t6, 0
	sw $t6, -24($fp)
#_main_4
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_6
	lw $t8, -24($fp)
	li $t9, 48
	add $t5, $t8, $t9
	sw $t5, -20($fp)
#_main_7
	lw $a0, -20($fp)
	li $v0, 11
	syscall
#_main_8
	lw $t8, -24($fp)
	li $t9, 1
	add $t4, $t8, $t9
	sw $t4, -16($fp)
#_main_9
	lw $t6, -16($fp)
	sw $t6, -24($fp)
#_label_main_3
_label_main_3:
#_main_11
	lw $t8, -24($fp)
	li $t9, 10
	slt $t3, $t8, $t9
	sw $t3, -12($fp)
#_main_12
	li $t8, 1
	lw $t9, -12($fp)
	beq $t9, $t8, _label_main_4
#_main_13
	li $a0, 10
	li $v0, 11
	syscall
#_main_14
	lw $t8, -28($fp)
	li $t9, 1
	add $t2, $t8, $t9
	sw $t2, -8($fp)
#_main_15
	lw $t7, -8($fp)
	sw $t7, -28($fp)
#_label_main_1
_label_main_1:
#_main_17
	lw $t8, -28($fp)
	li $t9, 10
	slt $t1, $t8, $t9
	sw $t1, -4($fp)
#_main_18
	li $t8, 1
	lw $t9, -4($fp)
	beq $t9, $t8, _label_main_2
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
