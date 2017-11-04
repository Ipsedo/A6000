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
	addi $sp, $sp, -12
	sw $a0, -12($fp)
#_0
	li $t0, 51
	sw $t0, -8($fp)
#_1
	lw $a0, -12($fp)
	lw $a1, -8($fp)
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
#_2
	lw $t0, -8($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_3
	lw $t0, -4($fp)
	sw $t0, -8($fp)
#_4
	lw $a0, -12($fp)
	lw $a1, -8($fp)
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 0
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 20
	jr $ra
print_ixe:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -8
	sw $a0, -8($fp)
	sw $a1, -4($fp)
#_5
	lw $a0, -8($fp)
	lw $a1, -4($fp)
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
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 16
	jr $ra
print_ixeprime:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, -32
	sw $a0, -4($fp)
	sw $a1, -8($fp)
	sw $a2, -12($fp)
	sw $a3, -16($fp)
	lw $t0, 24($fp)
	sw $t0, -20($fp)
	lw $t0, 20($fp)
	sw $t0, -24($fp)
	lw $t0, 16($fp)
	sw $t0, -28($fp)
	lw $t0, 12($fp)
	sw $t0, -32($fp)
#_6
	lw $a0, -4($fp)
	li $v0, 11
	syscall
#_7
	lw $a0, -8($fp)
	li $v0, 11
	syscall
#_8
	lw $a0, -12($fp)
	li $v0, 11
	syscall
#_9
	lw $a0, -16($fp)
	li $v0, 11
	syscall
#_10
	lw $a0, -20($fp)
	li $v0, 11
	syscall
#_11
	lw $a0, -24($fp)
	li $v0, 11
	syscall
#_12
	lw $a0, -28($fp)
	li $v0, 11
	syscall
#_13
	lw $a0, -32($fp)
	li $v0, 11
	syscall
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 40
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
