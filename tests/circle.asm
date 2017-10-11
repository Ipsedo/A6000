.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, 0
#_main_0
	li $t0, 1
	move $t5, $t0
#_main_1
	li $t0, 0
	move $t4, $t0
#_main_2
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_4
	li $t0, 0
	move $t5, $t0
#_main_5
	li $t0, 0
	move $t3, $t0
#_main_6
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_8
	mul $t7, $t4, $t4
#_main_9
	mul $t6, $t3, $t3
#_main_10
	add $t7, $t7, $t6
#_main_11
	li $t1, 1
	sub $t7, $t7, $t1
#_main_12
	lw $t0, 0($fp)
	lw $t1, 0($fp)
	mul $t6, $t0, $t1
#_main_13
	li $t1, 1
	sub $t6, $t6, $t1
#_main_14
	slt $t7, $t7, $t6
#_main_15
	bnez $t7, _label_main_5
#_main_16
	li $a0, 35
	li $v0, 11
	syscall
#_main_17
	jal _label_main_6
#_label_main_5
_label_main_5:
#_main_19
	li $a0, 46
	li $v0, 11
	syscall
#_main_20
	li $t0, 1
	move $t5, $t0
#_label_main_6
_label_main_6:
#_main_22
	li $a0, 32
	li $v0, 11
	syscall
#_main_23
	li $t1, 1
	add $t7, $t3, $t1
#_main_24
	move $t0, $t7
	move $t3, $t0
#_label_main_3
_label_main_3:
#_main_26
	lw $t0, 0($fp)
	li $t1, 1
	add $t6, $t0, $t1
#_main_27
	slt $t7, $t3, $t6
#_main_28
	bnez $t7, _label_main_4
#_main_29
	li $a0, 10
	li $v0, 11
	syscall
#_main_30
	li $t1, 1
	add $t7, $t4, $t1
#_main_31
	move $t0, $t7
	move $t4, $t0
#_label_main_1
_label_main_1:
#_main_33
	bnez $t5, _label_main_2
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
