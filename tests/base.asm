.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -116
#_main_0
	li $t1, 3
	li $t2, 2
	sne $t0, $t1, $t2
	sw $t0, -56($fp)
#_main_1
	li $t1, 3
	li $t2, 4
	mul $t0, $t1, $t2
	sw $t0, -60($fp)
#_main_2
	li $t1, 15
	li $t2, 3
	sub $t0, $t1, $t2
	sw $t0, -64($fp)
#_main_3
	lw $t1, -60($fp)
	lw $t2, -64($fp)
	seq $t0, $t1, $t2
	sw $t0, -68($fp)
#_main_4
	lw $t1, -56($fp)
	lw $t2, -68($fp)
	and $t0, $t1, $t2
	sw $t0, -72($fp)
#_main_5
	li $t1, 1
	li $t2, 2
	slt $t0, $t1, $t2
	sw $t0, -76($fp)
#_main_6
	lw $t1, -72($fp)
	lw $t2, -76($fp)
	and $t0, $t1, $t2
	sw $t0, -80($fp)
#_main_7
	li $t0, 1
	lw $t1, -80($fp)
	beq $t1, $t0, _label_main_9
#_main_8
	jal _label_main_10
#_label_main_9
_label_main_9:
#_main_10
	li $t5, 512
	sw $t5, -116($fp)
#_main_11
	jal _label_main_11
#_label_main_12
_label_main_12:
#_main_13
	li $t5, 0
	sw $t5, -112($fp)
#_main_14
	jal _label_main_15
#_label_main_16
_label_main_16:
#_main_16
	lw $t1, -112($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -52($fp)
#_main_17
	lw $a0, -52($fp)
	li $v0, 11
	syscall
#_main_18
	lw $t1, -112($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -44($fp)
#_main_19
	lw $t5, -44($fp)
	sw $t5, -112($fp)
#_label_main_15
_label_main_15:
#_main_21
	lw $t1, -112($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -40($fp)
#_main_22
	li $t0, 1
	lw $t1, -40($fp)
	beq $t1, $t0, _label_main_16
#_main_23
	lw $t1, -112($fp)
	lw $t2, -112($fp)
	mul $t0, $t1, $t2
	sw $t0, -32($fp)
#_main_24
	li $t1, 50
	lw $t2, -32($fp)
	slt $t0, $t1, $t2
	sw $t0, -36($fp)
#_main_25
	li $t0, 1
	lw $t1, -36($fp)
	beq $t1, $t0, _label_main_13
#_main_26
	jal _label_main_14
#_label_main_13
_label_main_13:
#_main_28
	li $a0, 95
	li $v0, 11
	syscall
#_label_main_14
_label_main_14:
#_main_30
	li $a0, 10
	li $v0, 11
	syscall
#_main_31
	lw $t1, -116($fp)
	li $t2, 2
	div $t0, $t1, $t2
	sw $t0, -28($fp)
#_main_32
	lw $t5, -28($fp)
	sw $t5, -116($fp)
#_label_main_11
_label_main_11:
#_main_34
	lw $t1, -116($fp)
	li $t2, 0
	sgt $t0, $t1, $t2
	sw $t0, -24($fp)
#_main_35
	li $t0, 1
	lw $t1, -24($fp)
	beq $t1, $t0, _label_main_12
#_label_main_10
_label_main_10:
#_main_37
	li $a0, 10
	li $v0, 11
	syscall
#_main_38
	li $t5, 9
	sw $t5, -112($fp)
#_main_39
	jal _label_main_7
#_label_main_8
_label_main_8:
#_main_41
	lw $t1, -112($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -20($fp)
#_main_42
	lw $a0, -20($fp)
	li $v0, 11
	syscall
#_main_43
	lw $t1, -112($fp)
	li $t2, 1
	sub $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_44
	lw $t5, -16($fp)
	sw $t5, -112($fp)
#_label_main_7
_label_main_7:
#_main_46
	lw $t1, -112($fp)
	li $t2, 0
	sgt $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_47
	li $t0, 1
	lw $t1, -12($fp)
	beq $t1, $t0, _label_main_8
#_main_48
	li $a0, 10
	li $v0, 11
	syscall
#_main_49
	li $t5, 9
	sw $t5, -112($fp)
#_main_50
	jal _label_main_5
#_label_main_6
_label_main_6:
#_main_52
	lw $t1, -112($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_53
	lw $a0, -8($fp)
	li $v0, 11
	syscall
#_main_54
	lw $t1, -112($fp)
	li $t2, 1
	sub $t0, $t1, $t2
	sw $t0, -108($fp)
#_main_55
	lw $t5, -108($fp)
	sw $t5, -112($fp)
#_label_main_5
_label_main_5:
#_main_57
	lw $t1, -112($fp)
	li $t2, 0
	sge $t0, $t1, $t2
	sw $t0, -104($fp)
#_main_58
	li $t0, 1
	lw $t1, -104($fp)
	beq $t1, $t0, _label_main_6
#_main_59
	li $a0, 10
	li $v0, 11
	syscall
#_main_60
	li $t5, 9
	sw $t5, -112($fp)
#_main_61
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_63
	lw $t1, -112($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -100($fp)
#_main_64
	lw $a0, -100($fp)
	li $v0, 11
	syscall
#_main_65
	lw $t1, -112($fp)
	li $t2, 1
	sub $t0, $t1, $t2
	sw $t0, -96($fp)
#_main_66
	lw $t5, -96($fp)
	sw $t5, -112($fp)
#_label_main_3
_label_main_3:
#_main_68
	lw $t1, -112($fp)
	li $t2, 0
	sge $t0, $t1, $t2
	sw $t0, -92($fp)
#_main_69
	li $t0, 1
	lw $t1, -92($fp)
	beq $t1, $t0, _label_main_4
#_main_70
	li $a0, 10
	li $v0, 11
	syscall
#_main_71
	li $t5, 0
	sw $t5, -112($fp)
#_main_72
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_74
	lw $t1, -112($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -88($fp)
#_main_75
	lw $a0, -88($fp)
	li $v0, 11
	syscall
#_main_76
	lw $t1, -112($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -84($fp)
#_main_77
	lw $t5, -84($fp)
	sw $t5, -112($fp)
#_label_main_1
_label_main_1:
#_main_79
	lw $t1, -112($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -48($fp)
#_main_80
	li $t0, 1
	lw $t1, -48($fp)
	beq $t1, $t0, _label_main_2
#_main_81
	li $a0, 10
	li $v0, 11
	syscall
#_main_82
	li $t5, 48
	sw $t5, -112($fp)
#_main_83
	lw $t1, -112($fp)
	li $t2, 2
	add $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_84
	lw $t5, -4($fp)
	sw $t5, -112($fp)
#_main_85
	lw $a0, -112($fp)
	li $v0, 11
	syscall
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
