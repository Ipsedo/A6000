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
	li $t0, 0
	move $t3, $t0
#_1
	b _label_1
#_label_2
_label_2:
#_3
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	addi $sp, $sp, -16
	move $a0, $t2
	li $a1, 51
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
	addi $sp, $sp, 16
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
#_4
	li $a0, 10
	li $v0, 11
	syscall
#_5
	li $t1, 1
	add $t4, $t3, $t1
#_6
	move $t3, $t4
#_label_1
_label_1:
#_8
	li $t1, 10
	slt $t4, $t3, $t1
#_9
	bnez $t4, _label_2
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
#_10
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	li $a2, 52
	li $a3, 53
	li $t0, 54
	sw $t0, 0($sp)
	li $t0, 55
	sw $t0, -4($sp)
	li $t0, 56
	sw $t0, -8($sp)
	li $t0, 57
	sw $t0, -12($sp)
	addi $sp, $sp, -16
	jal print_ixeprime
	addi $sp, $sp, 16
	addi $sp, $sp, 12
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
print_ixeprime:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t9, $a0
	move $t8, $a1
	move $t7, $a2
	move $t6, $a3
	lw $t5, 24($fp)
	lw $t4, 20($fp)
	lw $t3, 16($fp)
	lw $t2, 12($fp)
#_11
	move $a0, $t9
	li $v0, 11
	syscall
#_12
	move $a0, $t8
	li $v0, 11
	syscall
#_13
	move $a0, $t7
	li $v0, 11
	syscall
#_14
	move $a0, $t6
	li $v0, 11
	syscall
#_15
	move $a0, $t5
	li $v0, 11
	syscall
#_16
	move $a0, $t4
	li $v0, 11
	syscall
#_17
	move $a0, $t3
	li $v0, 11
	syscall
#_18
	move $a0, $t2
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
