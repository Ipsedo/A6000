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
	li $t1, 1
	add $t6, $t2, $t1
#_1
	move $t0, $t6
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	li $v0, 9
	move $a0, $t0
	syscall
	move $t6, $v0
#_2
	move $t3, $t6
#_3
	li $t0, 0
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	li $t1, 1
	sw $t1, 0($t0)
#_4
	li $t0, 1
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	li $t1, 1
	sw $t1, 0($t0)
#_5
	li $t0, 2
	move $t4, $t0
#_6
	b _label_1
#_label_2
_label_2:
#_8
	li $t1, 1
	sub $t6, $t4, $t1
#_9
	move $t0, $t6
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	lw $t6, 0($t0)
#_10
	li $t1, 2
	sub $t5, $t4, $t1
#_11
	move $t0, $t5
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	lw $t5, 0($t0)
#_12
	add $t6, $t6, $t5
#_13
	move $t0, $t4
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	move $t1, $t6
	sw $t1, 0($t0)
#_14
	li $t1, 1
	add $t6, $t4, $t1
#_15
	move $t4, $t6
#_label_1
_label_1:
#_17
	sle $t6, $t4, $t2
#_18
	bnez $t6, _label_2
#_19
	move $t0, $t2
	li $t1, 4
	mul $t0, $t0, $t1
	addi $t0, $t0, 4
	move $t1, $t3
	add $t0, $t0, $t1
	lw $t6, 0($t0)
#_20
	move $a0, $t6
	li $v0, 11
	syscall
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
.data
