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
#_0
	move $t4, $a0
#_1
	move $t3, $a1
#_2
	li $t0, 0
	move $t2, $t0
#_3
	li $t0, 0
	move $t5, $t0
#_4
	b _label_1
#_label_2
_label_2:
#_6
	slt $t0, $t5, $t4
	move $t2, $t0
#_7
	bnez $t2, _label_3
#_8
	li $a0, 35
	li $v0, 11
	syscall
#_9
	b _label_4
#_label_3
_label_3:
#_11
	li $a0, 46
	li $v0, 11
	syscall
#_12
	li $t0, 1
	move $t2, $t0
#_label_4
_label_4:
#_14
	li $a0, 32
	li $v0, 11
	syscall
#_15
	li $t1, 1
	add $t0, $t5, $t1
	move $t2, $t0
#_16
	move $t5, $t2
#_label_1
_label_1:
#_18
	li $t1, 1
	add $t0, $t3, $t1
	move $t2, $t0
#_19
	slt $t0, $t5, $t2
	move $t2, $t0
#_20
	bnez $t2, _label_2
#_21
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
#_22
	move $t3, $a0
#_23
	move $t2, $a1
#_24
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
#_25
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
#_26
	bnez $t4, _label_5
#_27
	b _label_6
#_label_5
_label_5:
#_29
	li $t1, 1
	add $t0, $t3, $t1
	move $t4, $t0
#_30
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
#_32
	move $t2, $a0
#_33
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
#_34
	move $t4, $a0
#_35
	move $t2, $a1
#_36
	li $t0, 0
	move $t3, $t0
#_37
	b _label_7
#_label_8
_label_8:
#_39
	li $t1, 1
	add $t0, $t3, $t1
	move $t6, $t0
#_40
	move $t3, $t6
#_label_7
_label_7:
#_42
	mul $t0, $t4, $t4
	move $t6, $t0
#_43
	mul $t0, $t3, $t3
	move $t5, $t0
#_44
	add $t0, $t6, $t5
	move $t6, $t0
#_45
	mul $t0, $t2, $t2
	move $t5, $t0
#_46
	slt $t0, $t6, $t5
	move $t6, $t0
#_47
	bnez $t6, _label_8
#_48
	move $t2, $t3
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
