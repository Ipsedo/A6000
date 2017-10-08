.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, 0
#_main_0
	lw $a0, 0($fp)
	li $v0, 11
	syscall
#_main_1
	li $t0, 1
	li $t1, 5
	add $t0, $t0, $t1
	move $t3, $t0
#_main_2
	move $t0, $t3
	li $t1, 8
	add $t0, $t0, $t1
	move $t4, $t0
#_main_3
	li $t0, 9
	li $t1, 5
	mul $t0, $t0, $t1
	move $t3, $t0
#_main_4
	move $t0, $t3
	li $t1, 2
	mul $t0, $t0, $t1
	move $t3, $t0
#_main_5
	move $t0, $t4
	move $t1, $t3
	sub $t0, $t0, $t1
	move $t3, $t0
#_main_6
	move $t0, $t3
	li $t1, 7
	sub $t0, $t0, $t1
	move $t4, $t0
#_main_7
	li $t0, 6
	li $t1, 7
	mul $t0, $t0, $t1
	move $t3, $t0
#_main_8
	move $t0, $t3
	li $t1, 9
	mul $t0, $t0, $t1
	move $t3, $t0
#_main_9
	move $t0, $t4
	move $t1, $t3
	add $t0, $t0, $t1
	move $t4, $t0
#_main_10
	li $t0, 6
	li $t1, 6
	mul $t0, $t0, $t1
	move $t3, $t0
#_main_11
	move $t0, $t4
	move $t1, $t3
	add $t0, $t0, $t1
	move $t3, $t0
#_main_12
	move $t0, $t3
	move $t3, $t0
#_main_13
	move $t0, $t3
	li $t1, 331
	seq $t0, $t0, $t1
	move $t3, $t0
#_main_14
	move $t0, $t3
	bgtz $t0, _label_main_1
#_main_15
	jal _label_main_2
#_label_main_1
_label_main_1:
#_main_17
	li $a0, 10
	li $v0, 11
	syscall
#_main_18
	lw $a0, 0($fp)
	li $v0, 11
	syscall
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
