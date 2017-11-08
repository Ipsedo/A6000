open Mips

let log10 : 'a Mips.asm =
  let p = label "log10"
  @@ sw fp (-4) sp
  @@ sw ra (-8) sp
  @@ addi sp sp (-8)
  @@ move fp sp
  @@ addi sp sp 0
  @@ move t2 a0
  @@ li t1 1000000
  @@ sge t3 t2 t1
  @@ bnez t3 "_label_1"
  @@ li t1 100000
  @@ sge t3 t2 t1
  @@ bnez t3 "_label_3"
  @@ li t1 10000
  @@ sge t3 t2 t1
  @@ bnez t3 "_label_5"
  @@ li t1 1000
  @@ sge t3 t2 t1
  @@ bnez t3 "_label_7"
  @@ li t1 100
  @@ sge t3 t2 t1
  @@ bnez t3 "_label_9"
  @@ li t1 10
  @@ sge t3 t2 t1
  @@ bnez t3 "_label_11"
  @@ li t0 0
  @@ move t2 t0
  @@ b "_label_12"
  @@ label "_label_11"
  @@ li t0 1
  @@ move t2 t0
  @@ label "_label_12"
  @@ b "_label_10"
  @@ label "_label_9"
  @@ li t0 2
  @@ move t2 t0
  @@ label "_label_10"
  @@ b "_label_8"
  @@ label "_label_7"
  @@ li t0 3
  @@ move t2 t0
  @@ label "_label_8"
  @@ b "_label_6"
  @@ label "_label_5"
  @@ li t0 4
  @@ move t2 t0
  @@ label "_label_6"
  @@ b "_label_4"
  @@ label "_label_3"
  @@ li t0 5
  @@ move t2 t0
  @@ label "_label_4"
  @@ b "_label_2"
  @@ label "_label_1"
  @@ li t0 6
  @@ move t2 t0
  @@ label "_label_2"
  @@ move v0 t2
  @@ lw ra 0 fp
  @@ lw fp 4 fp
  @@ addi sp sp 8
  @@ jr ra
  in let _ = { text = p;
        data = nop}
  in p

let string_of_int : 'a Mips.asm =
  label "string_of_int"
  sw $fp, -4($sp)
  sw $ra, -8($sp)
  addi $sp, $sp, -8
  move $fp, $sp
  addi $sp, $sp, 0
  move $t2, $a0
#_37
  sw $t2, -4($sp)
  sw $t3, -8($sp)
  sw $t4, -12($sp)
  sw $t5, -16($sp)
  sw $t6, -20($sp)
  sw $t7, -24($sp)
  sw $t8, -28($sp)
  addi $sp, $sp, -28
  move $a0, $t2
  addi $sp, $sp, 0
  jal log10
  addi $sp, $sp, 0
  addi $sp, $sp, 28
  lw $t2, -4($sp)
  lw $t3, -8($sp)
  lw $t4, -12($sp)
  lw $t5, -16($sp)
  lw $t6, -20($sp)
  lw $t7, -24($sp)
  lw $t8, -28($sp)
  move $t3, $v0
#_38
  li $t1, 1
  add $t3, $t3, $t1
#_39
  move $t6, $t3
#_40
  move $t0, $t6
  li $t1, 4
  mul $t0, $t0, $t1
  addi $t0, $t0, 4
  li $v0, 9
  move $a0, $t0
  syscall
  move $t0, $t6
  sw $t0, 0($v0)
  move $t3, $v0
#_41
  move $t5, $t3
#_42
  li $t0, 0
  move $t7, $t0
#_43
  b _label_13
#_label_14
_label_14:
#_45
  li $t1, 10
  div $t3, $t2, $t1
#_46
  move $t3, $t3
#_47
  li $t1, 10
  mul $t3, $t3, $t1
#_48
  move $t3, $t3
#_49
  sub $t3, $t2, $t3
#_50
  move $t3, $t3
#_51
  move $a0, $t7
  move $a1, $t5
  jal _check_array_bounds
  move $t0, $t7
  li $t1, 4
  mul $t0, $t0, $t1
  addi $t0, $t0, 4
  move $t1, $t5
  add $t0, $t0, $t1
  move $t1, $t3
  sw $t1, 0($t0)
#_52
  li $t1, 10
  div $t3, $t2, $t1
#_53
  move $t2, $t3
#_54
  li $t1, 1
  add $t3, $t7, $t1
#_55
  move $t7, $t3
#_label_13
_label_13:
#_57
  slt $t3, $t7, $t6
#_58
  bnez $t3, _label_14
#_59
  move $t4, $t5
  move $v0, $t4
  lw $ra, 0($fp)
  lw $fp, 4($fp)
  addi $sp, $sp, 8
  jr $ra
