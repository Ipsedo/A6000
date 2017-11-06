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
#_0
	move $t2, $a0
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
#_5
	li $a0, 10
	li $v0, 11
	syscall
#_6
	li $t1, 1
	add $t0, $t3, $t1
	move $t4, $t0
#_7
	move $t3, $t4
#_label_1
_label_1:
#_9
	li $t1, 10
	slt $t0, $t3, $t1
	move $t4, $t0
#_10
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
#_11
	move $t2, $a0
#_12
	move $t3, $a1
#_13
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
#_14
	move $t9, $a0
#_15
	move $t8, $a1
#_16
	move $t7, $a2
#_17
	move $t6, $a3
#_18
	lw $t0, 24($fp)
	move $t5, $t0
#_19
	lw $t0, 20($fp)
	move $t4, $t0
#_20
	lw $t0, 16($fp)
	move $t3, $t0
#_21
	lw $t0, 12($fp)
	move $t2, $t0
#_22
	move $a0, $t9
	li $v0, 11
	syscall
#_23
	move $a0, $t8
	li $v0, 11
	syscall
#_24
	move $a0, $t7
	li $v0, 11
	syscall
#_25
	move $a0, $t6
	li $v0, 11
	syscall
#_26
	move $a0, $t5
	li $v0, 11
	syscall
#_27
	move $a0, $t4
	li $v0, 11
	syscall
#_28
	move $a0, $t3
	li $v0, 11
	syscall
#_29
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
