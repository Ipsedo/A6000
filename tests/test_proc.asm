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
	move $t3, $t0
#_1
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
	lw $t9, 4($sp)
	lw $t8, 8($sp)
	lw $t7, 12($sp)
	addi $sp, $sp, 12
#_2
	li $t1, 1
	add $t3, $t3, $t1
#_3
	move $t3, $t3
#_4
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
	lw $t9, 4($sp)
	lw $t8, 8($sp)
	lw $t7, 12($sp)
	addi $sp, $sp, 12
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
#_5
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	addi $sp, $sp, -12
	move $a0, $t2
	move $a1, $t3
	li $a2, 52
	li $a3, 53
	li $t0, 54
	sw $t0, -4($sp)
	li $t0, 55
	sw $t0, -8($sp)
	li $t0, 56
	sw $t0, -12($sp)
	li $t0, 57
	sw $t0, -16($sp)
	addi $sp, $sp, -16
	jal print_ixeprime
	addi $sp, $sp, 16
	lw $t9, 4($sp)
	lw $t8, 8($sp)
	lw $t7, 12($sp)
	addi $sp, $sp, 12
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
#_6
	move $a0, $t9
	li $v0, 11
	syscall
#_7
	move $a0, $t8
	li $v0, 11
	syscall
#_8
	move $a0, $t7
	li $v0, 11
	syscall
#_9
	move $a0, $t6
	li $v0, 11
	syscall
#_10
	move $a0, $t5
	li $v0, 11
	syscall
#_11
	move $a0, $t4
	li $v0, 11
	syscall
#_12
	move $a0, $t3
	li $v0, 11
	syscall
#_13
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
