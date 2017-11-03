.text
	move $fp, $sp
	lw $a0, 0($a1)
	jal atoi
	move $a0, $v0
	jal main
	li $v0, 10
	syscall
main:
	sw $fp, -4($fp)
	sw $ra, -8($fp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_0
	move $a0, $t2
	addi $sp, $sp, 0
	jal print_ixe
	addi $sp, $sp, 1
	lw $ra, 0($fp)
	addi $fp, $fp, 4
	lw $fp, 0($fp)
	addi $sp, $sp, 4
	jr $ra
print_ixe:
	sw $fp, -4($fp)
	sw $ra, -8($fp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_1
	move $a0, $t2
	addi $sp, $sp, 0
	jal print_ixeprime
	addi $sp, $sp, 1
	lw $ra, 0($fp)
	addi $fp, $fp, 4
	lw $fp, 0($fp)
	addi $sp, $sp, 4
	jr $ra
print_ixeprime:
	sw $fp, -4($fp)
	sw $ra, -8($fp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_2
	move $a0, $t2
	li $v0, 11
	syscall
	lw $ra, 0($fp)
	addi $fp, $fp, 4
	lw $fp, 0($fp)
	addi $sp, $sp, 4
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
