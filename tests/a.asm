.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -20
#_main_0
	li $t1, 1
	li $t2, 2
	add $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_1
	lw $t1, -12($fp)
	li $t2, 3
	mul $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_2
	lw $t5, -16($fp)
	sw $t5, -20($fp)
#_main_3
	lw $t1, -20($fp)
	li $t2, 1
	seq $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_4
	li $t0, 1
	lw $t1, -8($fp)
	beq $t1, $t0, _label_main_3
#_main_5
	jal _label_main_4
#_label_main_3
_label_main_3:
#_label_main_4
_label_main_4:
#_main_8
	jal _label_main_1
#_label_main_2
_label_main_2:
#_label_main_1
_label_main_1:
#_main_11
	lw $t1, -20($fp)
	li $t2, 1
	sle $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_12
	li $t0, 1
	lw $t1, -4($fp)
	beq $t1, $t0, _label_main_2
#_main_13
	lw $a0, 0($fp)
	li $v0, 11
	syscall
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
