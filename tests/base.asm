.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, 0
#_main_0
	li $t0, 3
	li $t1, 2
	sne $t5, $t0, $t1
#_main_1
	li $t0, 3
	li $t1, 4
	mul $t2, $t0, $t1
#_main_2
	li $t0, 15
	li $t1, 3
	sub $t3, $t0, $t1
#_main_3
	seq $t2, $t2, $t3
#_main_4
	and $t5, $t5, $t2
#_main_5
	li $t0, 1
	li $t1, 2
	slt $t2, $t0, $t1
#_main_6
	or $t5, $t5, $t2
#_main_7
	bnez $t5, _label_main_9
#_main_8
	jal _label_main_10
#_label_main_9
_label_main_9:
#_main_10
	li $t0, 512
	move $t3, $t0
#_main_11
	jal _label_main_11
#_label_main_12
_label_main_12:
#_main_13
	li $t0, 0
	move $t2, $t0
#_main_14
	li $t0, 1
	move $t4, $t0
#_main_15
	jal _label_main_15
#_label_main_16
_label_main_16:
#_main_17
	li $t1, 48
	add $t5, $t2, $t1
#_main_18
	move $a0, $t5
	li $v0, 11
	syscall
#_main_19
	li $t1, 1
	add $t5, $t2, $t1
#_main_20
	move $t0, $t5
	move $t2, $t0
#_main_21
	li $t1, 2
	mul $t5, $t4, $t1
#_main_22
	move $t0, $t5
	move $t4, $t0
#_label_main_15
_label_main_15:
#_main_24
	li $t1, 1024
	slt $t5, $t4, $t1
#_main_25
	bnez $t5, _label_main_16
#_main_26
	mul $t2, $t4, $t4
#_main_27
	li $t0, 50
	slt $t5, $t0, $t2
#_main_28
	bnez $t5, _label_main_13
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
	li $t1, 2
	div $t5, $t3, $t1
#_main_35
	move $t0, $t5
	move $t3, $t0
#_label_main_11
_label_main_11:
#_main_37
	li $t1, 0
	sgt $t5, $t3, $t1
#_main_38
	bnez $t5, _label_main_12
#_label_main_10
_label_main_10:
#_main_40
	li $a0, 10
	li $v0, 11
	syscall
#_main_41
	li $t0, 9
	move $t4, $t0
#_main_42
	jal _label_main_7
#_label_main_8
_label_main_8:
#_main_44
	li $t1, 48
	add $t5, $t4, $t1
#_main_45
	move $a0, $t5
	li $v0, 11
	syscall
#_main_46
	li $t1, 1
	sub $t5, $t4, $t1
#_main_47
	move $t0, $t5
	move $t4, $t0
#_label_main_7
_label_main_7:
#_main_49
	li $t1, 0
	sgt $t5, $t4, $t1
#_main_50
	bnez $t5, _label_main_8
#_main_51
	li $a0, 10
	li $v0, 11
	syscall
#_main_52
	li $t0, 9
	move $t4, $t0
#_main_53
	jal _label_main_5
#_label_main_6
_label_main_6:
#_main_55
	li $t1, 48
	add $t5, $t4, $t1
#_main_56
	move $a0, $t5
	li $v0, 11
	syscall
#_main_57
	li $t1, 1
	sub $t5, $t4, $t1
#_main_58
	move $t0, $t5
	move $t4, $t0
#_label_main_5
_label_main_5:
#_main_60
	li $t1, 0
	sge $t5, $t4, $t1
#_main_61
	bnez $t5, _label_main_6
#_main_62
	li $a0, 10
	li $v0, 11
	syscall
#_main_63
	li $t0, 9
	move $t4, $t0
#_main_64
	jal _label_main_3
#_label_main_4
_label_main_4:
#_main_66
	li $t1, 48
	add $t5, $t4, $t1
#_main_67
	move $a0, $t5
	li $v0, 11
	syscall
#_main_68
	li $t1, 3
	sub $t5, $t4, $t1
#_main_69
	move $t0, $t5
	move $t4, $t0
#_label_main_3
_label_main_3:
#_main_71
	li $t1, 0
	sge $t5, $t4, $t1
#_main_72
	bnez $t5, _label_main_4
#_main_73
	li $a0, 10
	li $v0, 11
	syscall
#_main_74
	li $t0, 0
	move $t3, $t0
#_main_75
	li $t0, 0
	move $t4, $t0
#_main_76
	jal _label_main_1
#_label_main_2
_label_main_2:
#_main_78
	li $t1, 48
	add $t5, $t3, $t1
#_main_79
	move $a0, $t5
	li $v0, 11
	syscall
#_main_80
	li $t1, 2
	add $t5, $t3, $t1
#_main_81
	move $t0, $t5
	move $t3, $t0
#_main_82
	li $t1, 2
	add $t5, $t4, $t1
#_main_83
	move $t0, $t5
	move $t4, $t0
#_label_main_1
_label_main_1:
#_main_85
	li $t1, 10
	slt $t5, $t3, $t1
#_main_86
	bnez $t5, _label_main_2
#_main_87
	li $a0, 10
	li $v0, 11
	syscall
#_main_88
	li $t0, 48
	move $t4, $t0
#_main_89
	li $t1, 2
	add $t5, $t4, $t1
#_main_90
	move $t0, $t5
	move $t4, $t0
#_main_91
	move $a0, $t4
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
