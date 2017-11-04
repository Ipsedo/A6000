.text
	move $fp, $sp
	lw $a0, 0($a1)
	jal atoi
	move $a0, $v0
	jal main
	li $v0, 10
	syscall
main:
	sw $fp, 0($sp)
	sw $ra, -4($sp)
	addi $sp, $sp, -8
	addi $fp, $sp, 4
	addi $sp, $sp, 0
	move $t2, $a0
#_0
	li $t0, 1
	move $t5, $t0
#_1
	li $t0, 0
	move $t4, $t0
#_2
	b _label_1
#_label_2
_label_2:
#_4
	li $t0, 0
	move $t5, $t0
#_5
	li $t0, 0
	move $t3, $t0
#_6
	b _label_3
#_label_4
_label_4:
#_8
	mul $t7, $t4, $t4
#_9
	mul $t6, $t3, $t3
#_10
	add $t7, $t7, $t6
#_11
	mul $t6, $t2, $t2
#_12
	slt $t7, $t7, $t6
#_13
	bnez $t7, _label_5
#_14
	li $a0, 35
	li $v0, 11
	syscall
#_15
	b _label_6
#_label_5
_label_5:
#_17
	li $a0, 46
	li $v0, 11
	syscall
#_18
	li $t0, 1
	move $t5, $t0
#_label_6
_label_6:
#_20
	li $a0, 32
	li $v0, 11
	syscall
#_21
	li $t1, 1
	add $t7, $t3, $t1
#_22
	move $t3, $t7
#_label_3
_label_3:
#_24
	li $t1, 1
	add $t6, $t2, $t1
#_25
	slt $t7, $t3, $t6
#_26
	bnez $t7, _label_4
#_27
	li $a0, 10
	li $v0, 11
	syscall
#_28
	li $t1, 1
	add $t7, $t4, $t1
#_29
	move $t4, $t7
#_label_1
_label_1:
#_31
	bnez $t5, _label_2
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
