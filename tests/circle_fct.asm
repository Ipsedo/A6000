.text
	move $fp, $sp
	lw $a0, 0($a1)
	jal atoi
	move $a0, $v0
	jal main
	li $v0, 10
	syscall
line:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t4, $a0
	move $t3, $a1
#_0
	li $t0, 0
	move $t2, $t0
#_1
	li $t0, 0
	move $t5, $t0
#_2
	b _label_1
#_label_2
_label_2:
#_4
	slt $t2, $t5, $t4
#_5
	bnez $t2, _label_3
#_6
	li $a0, 35
	li $v0, 11
	syscall
#_7
	b _label_4
#_label_3
_label_3:
#_9
	li $a0, 46
	li $v0, 11
	syscall
#_10
	li $t0, 1
	move $t2, $t0
#_label_4
_label_4:
#_12
	li $a0, 32
	li $v0, 11
	syscall
#_13
	li $t1, 1
	add $t2, $t5, $t1
#_14
	move $t5, $t2
#_label_1
_label_1:
#_16
	li $t1, 1
	add $t2, $t3, $t1
#_17
	slt $t2, $t5, $t2
#_18
	bnez $t2, _label_2
#_19
	li $a0, 10
	li $v0, 11
	syscall
	move $v0, $t2
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
loop:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t3, $a0
	move $t2, $a1
#_20
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	addi $sp, $sp, -16
	move $a0, $t3
	move $a1, $t2
	addi $sp, $sp, 0
	jal point
	addi $sp, $sp, 0
	addi $sp, $sp, 16
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	move $t4, $v0
#_21
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	addi $sp, $sp, -16
	move $a0, $t4
	move $a1, $t2
	addi $sp, $sp, 0
	jal line
	addi $sp, $sp, 0
	addi $sp, $sp, 16
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
	move $t4, $v0
#_22
	bnez $t4, _label_5
#_23
	b _label_6
#_label_5
_label_5:
#_25
	li $t1, 1
	add $t4, $t3, $t1
#_26
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	sw $t4, -12($sp)
	sw $t5, -16($sp)
	addi $sp, $sp, -16
	move $a0, $t4
	move $a1, $t2
	addi $sp, $sp, 0
	jal loop
	addi $sp, $sp, 0
	addi $sp, $sp, 16
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $t4, -12($sp)
	lw $t5, -16($sp)
#_label_6
_label_6:
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
main:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t2, $a0
#_28
	sw $t2, -4($sp)
	sw $t3, -8($sp)
	addi $sp, $sp, -8
	li $a0, 0
	move $a1, $t2
	addi $sp, $sp, 0
	jal loop
	addi $sp, $sp, 0
	addi $sp, $sp, 8
	lw $t2, -4($sp)
	lw $t3, -8($sp)
	lw $ra, 0($fp)
	lw $fp, 4($fp)
	addi $sp, $sp, 8
	jr $ra
point:
	sw $fp, -4($sp)
	sw $ra, -8($sp)
	addi $sp, $sp, -8
	move $fp, $sp
	addi $sp, $sp, 0
	move $t4, $a0
	move $t2, $a1
#_29
	li $t0, 0
	move $t3, $t0
#_30
	b _label_7
#_label_8
_label_8:
#_32
	li $t1, 1
	add $t6, $t3, $t1
#_33
	move $t3, $t6
#_label_7
_label_7:
#_35
	mul $t6, $t4, $t4
#_36
	mul $t5, $t3, $t3
#_37
	add $t6, $t6, $t5
#_38
	mul $t5, $t2, $t2
#_39
	slt $t6, $t6, $t5
#_40
	bnez $t6, _label_8
#_41
	move $t5, $t3
	move $v0, $t5
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
