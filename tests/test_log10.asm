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
	addi $sp, $sp, 0
	jal log10
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	move $t2, $v0
#_1
	li $t1, 10
	mul $t2, $t2, $t1
#_2
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	addi $sp, $sp, -8
	move $a0, $t2
	addi $sp, $sp, 0
	jal print
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
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
_check_array_bounds:
	bgez $a0, _ckeck_bound_1
	move $t0, $a0
	li $v0, 4
	la $a0, _array_out_of_bounds_string
	syscall
	li $a0, 45
	jal print
	neg $t0, $t0
	addi $a0, $t0, 48
	jal print
	li $a0, 10
	jal print
	li $v0, 10
	syscall
_ckeck_bound_1:
	lw $a1, 0($a1)
	blt $a0, $a1, _ckeck_bound_2
	move $t0, $a0
	li $v0, 4
	la $a0, _array_out_of_bounds_string
	syscall
	addi $a0, $t0, 48
	jal print
	li $a0, 10
	jal print
	li $v0, 10
	syscall
_ckeck_bound_2:
	jr $ra
print:
	li $v0, 11
	syscall
	jr $ra
log10:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
	li $t1, 1000000
	sge $t3, $t2, $t1
	bnez $t3, _label_1
	li $t1, 100000
	sge $t3, $t2, $t1
	bnez $t3, _label_3
	li $t1, 10000
	sge $t3, $t2, $t1
	bnez $t3, _label_5
	li $t1, 1000
	sge $t3, $t2, $t1
	bnez $t3, _label_7
	li $t1, 100
	sge $t3, $t2, $t1
	bnez $t3, _label_9
	li $t1, 10
	sge $t3, $t2, $t1
	bnez $t3, _label_11
	li $t0, 0
	move $t2, $t0
	b _label_12
_label_11:
	li $t0, 1
	move $t2, $t0
_label_12:
	b _label_10
_label_9:
	li $t0, 2
	move $t2, $t0
_label_10:
	b _label_8
_label_7:
	li $t0, 3
	move $t2, $t0
_label_8:
	b _label_6
_label_5:
	li $t0, 4
	move $t2, $t0
_label_6:
	b _label_4
_label_3:
	li $t0, 5
	move $t2, $t0
_label_4:
	b _label_2
_label_1:
	li $t0, 6
	move $t2, $t0
_label_2:
	move $v0, $t2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
.data
_array_out_of_bounds_string:
	.asciiz "Array out of Bounds : "
