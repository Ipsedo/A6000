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
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	addi $sp, $sp, -8
	move $a0, $t2
	move $a1, $t2
	li $a2, 9
	addi $sp, $sp, 0
	jal rec_mul
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	move $t2, $v0
#_1
	move $a0, $t2
	li $v0, 11
	syscall
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
plus_deux:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t3, $a0
#_2
	li $t1, 2
	add $t0, $t3, $t1
	move $t2, $t0
#_3
	move $t2, $t2
	move $v0, $t2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
plus_vingt:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t3, $a0
#_4
	li $t0, 0
	move $t4, $t0
#_5
	move $t2, $t3
#_6
	b _label_1
#_label_2
_label_2:
#_8
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	addi $sp, $sp, -16
	move $a0, $t2
	addi $sp, $sp, 0
	jal plus_deux
	addi $sp, $sp, 0
	addi $sp, $sp, 16
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	move $t3, $v0
#_9
	move $t2, $t3
#_10
	li $t1, 1
	add $t0, $t4, $t1
	move $t3, $t0
#_11
	move $t4, $t3
#_label_1
_label_1:
#_13
	li $t1, 10
	slt $t0, $t4, $t1
	move $t3, $t0
#_14
	bnez $t3, _label_2
	move $v0, $t2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
rec_mul:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t3, $a0
	move $t5, $a1
	move $t4, $a2
#_15
	li $t1, 0
	sgt $t0, $t4, $t1
	move $t2, $t0
#_16
	bnez $t2, _label_3
#_17
	move $t2, $t3
#_18
	b _label_4
#_label_3
_label_3:
#_20
	add $t0, $t3, $t5
	move $t2, $t0
#_21
	li $t1, 1
	sub $t0, $t4, $t1
	move $t3, $t0
#_22
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	sw $t6, -20($sp)
	addi $sp, $sp, -20
	move $a0, $t2
	move $a1, $t5
	move $a2, $t3
	addi $sp, $sp, 0
	jal rec_mul
	addi $sp, $sp, 0
	addi $sp, $sp, 20
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	lw $t6, -20($sp)
	move $t2, $v0
#_23
	move $t2, $t2
#_label_4
_label_4:
	move $v0, $t2
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
