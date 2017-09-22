.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -40
#_main_0
	li $t5, 0
	sw $t5, -40($fp)
#_main_1
	li $t1, 3
	li $t2, 2
	li $t3, 1
	seq $t0, $t1, $t2
	sub $t0, $t3, $t0
	sw $t0, -32($fp)
#_main_2
	li $t0, 1
	lw $t1, -32($fp)
	beq $t1, $t0, _label_main_1
#_main_3
	jal _label_main_2
#_label_main_1
_label_main_1:
#_main_5
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_7
	li $t5, 0
	sw $t5, -36($fp)
#_main_8
	jal _label_main_7
#_label_main_8
_label_main_8:
#_main_10
	lw $t1, -36($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -28($fp)
#_main_11
	lw $a0, -28($fp)
	li $v0, 11
	syscall
#_main_12
	lw $t1, -36($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -24($fp)
#_main_13
	lw $t5, -24($fp)
	sw $t5, -36($fp)
#_label_main_7
_label_main_7:
#_main_15
	lw $t1, -36($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -20($fp)
#_main_16
	li $t0, 1
	lw $t1, -20($fp)
	beq $t1, $t0, _label_main_8
#_main_17
	lw $t1, -36($fp)
	lw $t2, -36($fp)
	mul $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_18
	li $t1, 50
	lw $t2, -12($fp)
	slt $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_19
	li $t0, 1
	lw $t1, -16($fp)
	beq $t1, $t0, _label_main_5
#_main_20
	jal _label_main_6
#_label_main_5
_label_main_5:
#_main_22
	li $a0, 58
	li $v0, 11
	syscall
#_label_main_6
_label_main_6:
#_main_24
	li $a0, 10
	li $v0, 11
	syscall
#_main_25
	lw $t1, -40($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_26
	lw $t5, -8($fp)
	sw $t5, -40($fp)
#_label_main_3
_label_main_3:
#_main_28
	lw $t1, -40($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_29
	li $t0, 1
	lw $t1, -4($fp)
	beq $t1, $t0, _label_main_4
#_label_main_2
_label_main_2:
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
