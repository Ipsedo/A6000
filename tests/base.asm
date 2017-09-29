.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -124
#_main_0
	li $t1, 3
	li $t2, 2
	sne $t0, $t1, $t2
	sw $t0, -60($fp)
#_main_1
	li $t1, 3
	li $t2, 4
	mul $t0, $t1, $t2
	sw $t0, -64($fp)
#_main_2
	li $t1, 15
	li $t2, 3
	sub $t0, $t1, $t2
	sw $t0, -68($fp)
#_main_3
	lw $t1, -64($fp)
	lw $t2, -68($fp)
	seq $t0, $t1, $t2
	sw $t0, -72($fp)
#_main_4
	lw $t1, -60($fp)
	lw $t2, -72($fp)
	and $t0, $t1, $t2
	sw $t0, -76($fp)
#_main_5
	li $t1, 1
	li $t2, 2
	slt $t0, $t1, $t2
	sw $t0, -80($fp)
#_main_6
	lw $t1, -76($fp)
	lw $t2, -80($fp)
	or $t0, $t1, $t2
	sw $t0, -84($fp)
#_main_7
	li $t0, 1
	lw $t1, -84($fp)
	beq $t1, $t0, _label_main_9
#_main_8
	jal _label_main_10
#_label_main_9
_label_main_9:
#_main_10
	li $t5, 512
	sw $t5, -120($fp)
#_main_11
	jal _label_main_11
#_label_main_12
_label_main_12:
#_main_13
	li $t5, 0
	sw $t5, -124($fp)
#_main_14
	li $t5, 1
	sw $t5, -116($fp)
#_main_15
	jal _label_main_15
#_label_main_16
_label_main_16:
#_main_17
	lw $t1, -124($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -56($fp)
#_main_18
	lw $a0, -56($fp)
	li $v0, 11
	syscall
#_main_19
	lw $t1, -124($fp)
	li $t2, 1
	add $t0, $t1, $t2
	sw $t0, -52($fp)
#_main_20
	lw $t5, -52($fp)
	sw $t5, -124($fp)
#_main_21
	lw $t1, -116($fp)
	li $t2, 2
	mul $t0, $t1, $t2
	sw $t0, -44($fp)
#_main_22
	lw $t5, -44($fp)
	sw $t5, -116($fp)
#_label_main_15
_label_main_15:
#_main_24
	lw $t1, -116($fp)
	li $t2, 1024
	slt $t0, $t1, $t2
	sw $t0, -40($fp)
#_main_25
	li $t0, 1
	lw $t1, -40($fp)
	beq $t1, $t0, _label_main_16
#_main_26
	lw $t1, -116($fp)
	lw $t2, -116($fp)
	mul $t0, $t1, $t2
	sw $t0, -32($fp)
#_main_27
	li $t1, 50
	lw $t2, -32($fp)
	slt $t0, $t1, $t2
	sw $t0, -36($fp)
#_main_28
	li $t0, 1
	lw $t1, -36($fp)
	beq $t1, $t0, _label_main_13
#_main_29
	jal _label_main_14
#_label_main_13
_label_main_13:
#_main_31
	li $a0, 95
	li $v0, 11
	syscall
#_label_main_14
_label_main_14:
#_main_33
	li $a0, 10
	li $v0, 11
	syscall
#_main_34
	lw $t1, -120($fp)
	li $t2, 2
	div $t0, $t1, $t2
	sw $t0, -28($fp)
#_main_35
	lw $t5, -28($fp)
	sw $t5, -120($fp)
#_label_main_11
_label_main_11:
#_main_37
	lw $t1, -120($fp)
	li $t2, 0
	sgt $t0, $t1, $t2
	sw $t0, -24($fp)
#_main_38
	li $t0, 1
	lw $t1, -24($fp)
	beq $t1, $t0, _label_main_12
#_label_main_10
_label_main_10:
#_main_40
	li $a0, 10
	li $v0, 11
	syscall
#_main_41
	li $t5, 9
	sw $t5, -116($fp)
#_main_42
	jal _label_main_7
#_label_main_8
_label_main_8:
#_main_44
	lw $t1, -116($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -20($fp)
#_main_45
	lw $a0, -20($fp)
	li $v0, 11
	syscall
#_main_46
	lw $t1, -116($fp)
	li $t2, 1
	sub $t0, $t1, $t2
	sw $t0, -16($fp)
#_main_47
	lw $t5, -16($fp)
	sw $t5, -116($fp)
#_label_main_7
_label_main_7:
#_main_49
	lw $t1, -116($fp)
	li $t2, 0
	sgt $t0, $t1, $t2
	sw $t0, -12($fp)
#_main_50
	li $t0, 1
	lw $t1, -12($fp)
	beq $t1, $t0, _label_main_8
#_main_51
	li $a0, 10
	li $v0, 11
	syscall
#_main_52
	li $t5, 9
	sw $t5, -116($fp)
#_main_53
	jal _label_main_5
#_label_main_6
_label_main_6:
#_main_55
	lw $t1, -116($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -8($fp)
#_main_56
	lw $a0, -8($fp)
	li $v0, 11
	syscall
#_main_57
	lw $t1, -116($fp)
	li $t2, 1
	sub $t0, $t1, $t2
	sw $t0, -112($fp)
#_main_58
	lw $t5, -112($fp)
	sw $t5, -116($fp)
#_label_main_5
_label_main_5:
#_main_60
	lw $t1, -116($fp)
	li $t2, 0
	sge $t0, $t1, $t2
	sw $t0, -108($fp)
#_main_61
	li $t0, 1
	lw $t1, -108($fp)
	beq $t1, $t0, _label_main_6
#_main_62
	li $a0, 10
	li $v0, 11
	syscall
#_main_63
	li $t5, 9
	sw $t5, -116($fp)
#_main_64
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_66
	lw $t1, -116($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -104($fp)
#_main_67
	lw $a0, -104($fp)
	li $v0, 11
	syscall
#_main_68
	lw $t1, -116($fp)
	li $t2, 3
	sub $t0, $t1, $t2
	sw $t0, -100($fp)
#_main_69
	lw $t5, -100($fp)
	sw $t5, -116($fp)
#_label_main_3
_label_main_3:
#_main_71
	lw $t1, -116($fp)
	li $t2, 0
	sge $t0, $t1, $t2
	sw $t0, -96($fp)
#_main_72
	li $t0, 1
	lw $t1, -96($fp)
	beq $t1, $t0, _label_main_4
#_main_73
	li $a0, 10
	li $v0, 11
	syscall
#_main_74
	li $t5, 0
	sw $t5, -116($fp)
#_main_75
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_77
	lw $t1, -116($fp)
	li $t2, 48
	add $t0, $t1, $t2
	sw $t0, -92($fp)
#_main_78
	lw $a0, -92($fp)
	li $v0, 11
	syscall
#_main_79
	lw $t1, -116($fp)
	li $t2, 2
	add $t0, $t1, $t2
	sw $t0, -88($fp)
#_main_80
	lw $t5, -88($fp)
	sw $t5, -116($fp)
#_label_main_1
_label_main_1:
#_main_82
	lw $t1, -116($fp)
	li $t2, 10
	slt $t0, $t1, $t2
	sw $t0, -48($fp)
#_main_83
	li $t0, 1
	lw $t1, -48($fp)
	beq $t1, $t0, _label_main_2
#_main_84
	li $a0, 10
	li $v0, 11
	syscall
#_main_85
	li $t5, 48
	sw $t5, -116($fp)
#_main_86
	lw $t1, -116($fp)
	li $t2, 2
	add $t0, $t1, $t2
	sw $t0, -4($fp)
#_main_87
	lw $t5, -4($fp)
	sw $t5, -116($fp)
#_main_88
	lw $a0, -116($fp)
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
