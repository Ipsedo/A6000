.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -12
#_main_0
	li $t4, 50
	li $t5, 2
	add $t2, $t4, $t5
	sw $t2, -8($fp)
#_main_1
	lw $t3, -8($fp)
	sw $t3, -12($fp)
#_main_2
	lw $t4, -12($fp)
	li $t5, 1
	add $t1, $t4, $t5
	sw $t1, -4($fp)
#_main_3
	lw $t3, -4($fp)
	sw $t3, -12($fp)
#_main_4
	lw $a0, -12($fp)
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
