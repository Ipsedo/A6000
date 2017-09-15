.text
	move $fp, $sp
	addi $fp, $fp, -4
	lw $a0, 0($a1)
	jal atoi
	sw $v0, 0($fp)
	addi $sp, $sp, -48
#_main_0
	li $t0, -1
	sw $t0, -40($fp)
#_main_1
	li $t0, 0
	sw $t0, -44($fp)
#_main_2
#While
#_main_3
	b _label_main_2
#_label_main_1
_label_main_1:
#_main_5
#Corps de boucle
#_main_6
	li $t0, 0
	sw $t0, -40($fp)
#_main_7
	li $t0, 0
	sw $t0, -48($fp)
#_main_8
#While
#_main_9
	b _label_main_4
#_label_main_3
_label_main_3:
#_main_11
#Corps de boucle
#_main_12
#If
#_main_13
	lw $t0, -44($fp)
	lw $t1, -44($fp)
	mul $t0, $t0, $t1
	sw $t0, -20($fp)
#_main_14
	lw $t0, -48($fp)
	lw $t1, -48($fp)
	mul $t0, $t0, $t1
	sw $t0, -24($fp)
#_main_15
	lw $t0, -20($fp)
	lw $t1, -24($fp)
	add $t0, $t0, $t1
	sw $t0, -28($fp)
#_main_16
	lw $t0, 0($fp)
	lw $t1, 0($fp)
	mul $t0, $t0, $t1
	sw $t0, -32($fp)
#_main_17
	lw $t0, -28($fp)
	lw $t1, -32($fp)
	slt $t0, $t0, $t1
	sw $t0, -36($fp)
#_main_18
	lw $t0, -36($fp)
	bnez $t0, _label_main_5
#_main_19
#Bloc else
#_main_20
	li $a0, 35
	li $v0, 11
	syscall
#_main_21
	b _label_main_6
#_label_main_5
_label_main_5:
#_main_23
#Bloc then
#_main_24
	li $a0, 46
	li $v0, 11
	syscall
#_main_25
	li $t0, -1
	sw $t0, -40($fp)
#_label_main_6
_label_main_6:
#_main_27
#Fin if
#_main_28
	li $a0, 32
	li $v0, 11
	syscall
#_main_29
	lw $t0, -48($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -16($fp)
#_main_30
	lw $t0, -16($fp)
	sw $t0, -48($fp)
#_label_main_4
_label_main_4:
#_main_32
#Test de boucle
#_main_33
	lw $t0, 0($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -8($fp)
#_main_34
	lw $t0, -48($fp)
	lw $t1, -8($fp)
	slt $t0, $t0, $t1
	sw $t0, -12($fp)
#_main_35
	lw $t0, -12($fp)
	bnez $t0, _label_main_3
#_main_36
#Fin boucle
#_main_37
	li $a0, 10
	li $v0, 11
	syscall
#_main_38
	lw $t0, -44($fp)
	li $t1, 1
	add $t0, $t0, $t1
	sw $t0, -4($fp)
#_main_39
	lw $t0, -4($fp)
	sw $t0, -44($fp)
#_label_main_2
_label_main_2:
#_main_41
#Test de boucle
#_main_42
	lw $t0, -40($fp)
	bnez $t0, _label_main_1
#_main_43
#Fin boucle
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
