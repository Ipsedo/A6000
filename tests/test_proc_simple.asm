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
	li $t0, 51
	move $t4, $t0
#_1
	li $t0, 0
	move $t3, $t0
#_2
	b _label_1
#_label_2
_label_2:
#_4
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	sw $t6, -20($sp)
	addi $sp, $sp, -20
	move $a0, $t2
	move $a1, $t4
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
	addi $sp, $sp, 20
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	lw $t6, -20($sp)
#_5
	li $a0, 10
	li $v0, 11
	syscall
#_6
	li $t1, 1
	add $t5, $t3, $t1
#_7
	move $t3, $t5
#_label_1
_label_1:
#_9
	li $t1, 10
	slt $t5, $t3, $t1
#_10
	bnez $t5, _label_2
#_11
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	sw $t6, -20($sp)
	addi $sp, $sp, -20
	move $a0, $t2
	move $a1, $t4
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
	addi $sp, $sp, 20
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	lw $t6, -20($sp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
print_ixe:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
	move $t3, $a1
#_12
	move $a0, $t2
	li $v0, 11
	syscall
#_13
	move $a0, $t3
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