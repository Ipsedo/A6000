.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -128
#_main_0
	li $t0, 50
	sw $t0, -112($fp)
#_main_1
	li $t0, 0
	sw $t0, -104($fp)
#_main_2
	li $t0, 0
	sw $t0, -108($fp)
#_main_3
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_5
	li $t0, 0
	sw $t0, -116($fp)
#_main_6
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_8
	lw $t0, 0($fp)
	li $t1, 2
	div $t0, $t0, $t1
	sw $t0, -60($fp)
#_main_9
	lw $t0, -108($fp)
	lw $t1, -60($fp)
	sub $t0, $t0, $t1
	sw $t0, -64($fp)
#_main_10
	lw $t0, -64($fp)
	sw $t0, -100($fp)
#_main_11
	lw $t0, 0($fp)
	li $t1, 2
	div $t0, $t0, $t1
	sw $t0, -52($fp)
#_main_12
	lw $t0, -116($fp)
	lw $t1, -52($fp)
	sub $t0, $t0, $t1
	sw $t0, -56($fp)
#_main_13
	lw $t0, -56($fp)
	sw $t0, -96($fp)
#_main_14
	li $t0, 0
	sw $t0, -128($fp)
#_main_15
	li $t0, 0
	sw $t0, -124($fp)
#_main_16
	li $t0, 0
	sw $t0, -104($fp)
#_main_17
	jal _label_main_7
#_label_main_8
_label_main_8:
#_main_19
	lw $t0, -128($fp)
	sw $t0, -120($fp)
#_main_20
	lw $t0, -128($fp)
	lw $t1, -128($fp)
	mul $t0, $t0, $t1
	sw $t0, -32($fp)
#_main_21
	lw $t0, -124($fp)
	lw $t1, -124($fp)
	mul $t0, $t0, $t1
	sw $t0, -36($fp)
#_main_22
	lw $t0, -32($fp)
	lw $t1, -36($fp)
	sub $t0, $t0, $t1
	sw $t0, -40($fp)
#_main_23
	lw $t0, -40($fp)
	lw $t1, -100($fp)
	add $t0, $t0, $t1
	sw $t0, -44($fp)
#_main_24
	lw $t0, -44($fp)
	sw $t0, -128($fp)
#_main_25
	li $t0, 2
	lw $t1, -124($fp)
	mul $t0, $t0, $t1
	sw $t0, -20($fp)
#_main_26
	lw $t0, -20($fp)
	lw $t1, -120($fp)
	mul $t0, $t0, $t1
	sw $t0, -24($fp)
#_main_27
	lw $t0, -24($fp)
	lw $t1, -96($fp)
	add $t0, $t0, $t1
	sw $t0, -28($fp)
#_main_28
	lw $t0, -28($fp)
	sw $t0, -124($fp)
#_main_29
	lw $t0, -104($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -16($fp)
#_main_30
	lw $t0, -16($fp)
	sw $t0, -104($fp)
#_label_main_7
_label_main_7:
#_main_32
	lw $t0, -128($fp)
	lw $t1, -128($fp)
	mul $t0, $t0, $t1
	sw $t0, -80($fp)
#_main_33
	lw $t0, -124($fp)
	lw $t1, -124($fp)
	mul $t0, $t0, $t1
	sw $t0, -84($fp)
#_main_34
	lw $t0, -80($fp)
	lw $t1, -84($fp)
	add $t0, $t0, $t1
	sw $t0, -88($fp)
#_main_35
	lw $t0, -88($fp)
	li $t1, 4
	slt $t0, $t0, $t1
	sw $t0, -92($fp)
#_main_36
	lw $t0, -104($fp)
	lw $t1, -112($fp)
	slt $t0, $t0, $t1
	sw $t0, -8($fp)
#_main_37
	lw $t0, -92($fp)
	lw $t1, -8($fp)
	and $t0, $t0, $t1
	sw $t0, -12($fp)
#_main_38
	lw $t0, -12($fp)
	bgtz $t0, _label_main_8
#_main_39
	lw $t0, -104($fp)
	lw $t1, -112($fp)
	seq $t0, $t0, $t1
	sw $t0, -76($fp)
#_main_40
	lw $t0, -76($fp)
	bgtz $t0, _label_main_5
#_main_41
	li $a0, 46
	li $v0, 11
	syscall
#_main_42
	li $a0, 32
	li $v0, 11
	syscall
#_main_43
	jal _label_main_6
#_label_main_5
_label_main_5:
#_main_45
	li $a0, 35
	li $v0, 11
	syscall
#_main_46
	li $a0, 32
	li $v0, 11
	syscall
#_label_main_6
_label_main_6:
#_main_48
	lw $t0, -116($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -72($fp)
#_main_49
	lw $t0, -72($fp)
	sw $t0, -116($fp)
#_label_main_3
_label_main_3:
#_main_51
	lw $t0, -116($fp)
	lw $t1, 0($fp)
	slt $t0, $t0, $t1
	sw $t0, -68($fp)
#_main_52
	lw $t0, -68($fp)
	bgtz $t0, _label_main_4
#_main_53
	li $a0, 10
	li $v0, 11
	syscall
#_main_54
	lw $t0, -108($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -48($fp)
#_main_55
	lw $t0, -48($fp)
	sw $t0, -108($fp)
#_label_main_1
_label_main_1:
#_main_57
	lw $t0, -108($fp)
	lw $t1, 0($fp)
	slt $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_58
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
