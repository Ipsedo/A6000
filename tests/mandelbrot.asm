.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -8
#_main_0
	li $t0, 0
	move $t7, $t0
#_main_1
	li $t0, 0
	move $t6, $t0
#_main_2
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_4
	li $t0, 0
	move $t5, $t0
#_main_5
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_7
	li $t0, 50
	li $t1, 2
	div $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_8
	move $t0, $t6
	lw $t1, -4($fp)
	sub $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_9
	lw $t0, -4($fp)
	move $t8, $t0
#_main_10
	li $t0, 50
	li $t1, 2
	div $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_11
	move $t0, $t5
	lw $t1, -4($fp)
	sub $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_12
	lw $t0, -4($fp)
	move $t9, $t0
#_main_13
	li $t0, 0
	move $t2, $t0
#_main_14
	li $t0, 0
	move $t3, $t0
#_main_15
	li $t0, 0
	move $t7, $t0
#_main_16
	jal _label_main_7
#_label_main_8
_label_main_8:
#_main_18
	move $t0, $t2
	move $t4, $t0
#_main_19
	move $t0, $t2
	move $t1, $t2
	mul $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_20
	move $t0, $t3
	move $t1, $t3
	mul $t0, $t0, $t1
	sw $t0, -8($fp)
#_main_21
	lw $t0, -4($fp)
	lw $t1, -8($fp)
	sub $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_22
	lw $t0, -4($fp)
	move $t1, $t8
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_23
	lw $t0, -4($fp)
	move $t2, $t0
#_main_24
	li $t0, 2
	move $t1, $t3
	mul $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_25
	lw $t0, -4($fp)
	move $t1, $t4
	mul $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_26
	lw $t0, -4($fp)
	move $t1, $t9
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_27
	lw $t0, -4($fp)
	move $t3, $t0
#_main_28
	move $t0, $t7
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_29
	lw $t0, -4($fp)
	move $t7, $t0
#_label_main_7
_label_main_7:
#_main_31
	move $t0, $t2
	move $t1, $t2
	mul $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_32
	move $t0, $t3
	move $t1, $t3
	mul $t0, $t0, $t1
	sw $t0, -8($fp)
#_main_33
	lw $t0, -4($fp)
	lw $t1, -8($fp)
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_34
	lw $t0, -4($fp)
	li $t1, 4
	slt $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_35
	move $t0, $t7
	li $t1, 50
	slt $t0, $t0, $t1
	sw $t0, -8($fp)
#_main_36
	lw $t0, -4($fp)
	lw $t1, -8($fp)
	and $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_37
	lw $t0, -4($fp)
	bgtz $t0, _label_main_8
#_main_38
	move $t0, $t7
	li $t1, 50
	seq $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_39
	lw $t0, -4($fp)
	bgtz $t0, _label_main_5
#_main_40
	li $a0, 46
	li $v0, 11
	syscall
#_main_41
	li $a0, 32
	li $v0, 11
	syscall
#_main_42
	jal _label_main_6
#_label_main_5
_label_main_5:
#_main_44
	li $a0, 35
	li $v0, 11
	syscall
#_main_45
	li $a0, 32
	li $v0, 11
	syscall
#_label_main_6
_label_main_6:
#_main_47
	move $t0, $t5
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_48
	lw $t0, -4($fp)
	move $t5, $t0
#_label_main_3
_label_main_3:
#_main_50
	move $t0, $t5
	li $t1, 50
	slt $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_51
	lw $t0, -4($fp)
	bgtz $t0, _label_main_4
#_main_52
	li $a0, 10
	li $v0, 11
	syscall
#_main_53
	move $t0, $t6
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_54
	lw $t0, -4($fp)
	move $t6, $t0
#_label_main_1
_label_main_1:
#_main_56
	move $t0, $t6
	li $t1, 50
	slt $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_57
	lw $t0, -4($fp)
	bgtz $t0, _label_main_2
	li $v0, 10
	syscall
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
