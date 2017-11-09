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
    @@ bnez t3 "_label_log10_1"
    @@ li t1 100000
    @@ sge t3 t2 t1
    @@ bnez t3 "_label_log10_3"
    @@ li t1 10000
    @@ sge t3 t2 t1
    @@ bnez t3 "_label_log10_5"
    @@ li t1 1000
    @@ sge t3 t2 t1
    @@ bnez t3 "_label_log10_7"
    @@ li t1 100
    @@ sge t3 t2 t1
    @@ bnez t3 "_label_log10_9"
    @@ li t1 10
    @@ sge t3 t2 t1
    @@ bnez t3 "_label_log10_11"
    @@ li t0 0
    @@ move t2 t0
    @@ b "_label_log10_12"
    @@ label "_label_log10_11"
    @@ li t0 1
    @@ move t2 t0
    @@ label "_label_log10_12"
    @@ b "_label_log10_10"
    @@ label "_label_log10_9"
    @@ li t0 2
    @@ move t2 t0
    @@ label "_label_log10_10"
    @@ b "_label_log10_8"
    @@ label "_label_log10_7"
    @@ li t0 3
    @@ move t2 t0
    @@ label "_label_log10_8"
    @@ b "_label_log10_6"
    @@ label "_label_log10_5"
    @@ li t0 4
    @@ move t2 t0
    @@ label "_label_log10_6"
    @@ b "_label_log10_4"
    @@ label "_label_log10_3"
    @@ li t0 5
    @@ move t2 t0
    @@ label "_label_log10_4"
    @@ b "_label_log10_2"
    @@ label "_label_log10_1"
    @@ li t0 6
    @@ move t2 t0
    @@ label "_label_log10_2"
    @@ move v0 t2
    @@ lw ra 0 fp
    @@ lw fp 4 fp
    @@ addi sp sp 8
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p

let string_of_int : 'a Mips.asm =
  let p = label "string_of_int"
    @@ sw fp (-4) sp
    @@ sw ra (-8) sp
    @@ addi sp sp (-8)
    @@ move fp sp
    @@ addi sp sp 0
    @@ move t2 a0
    @@ sw t2 (-4) sp
    @@ sw t3 (-8) sp
    @@ sw t4 (-12) sp
    @@ sw t5 (-16) sp
    @@ sw t6 (-20) sp
    @@ sw t7 (-24) sp
    @@ addi sp sp (-24)
    @@ move a0 t2
    @@ addi sp sp 0
    @@ jal "log10"
    @@ addi sp sp 0
    @@ addi sp sp 24
    @@ lw t2 (-4) sp
    @@ lw t3 (-8) sp
    @@ lw t4 (-12) sp
    @@ lw t5 (-16) sp
    @@ lw t6 (-20) sp
    @@ lw t7 (-24) sp
    @@ move t3 v0
    @@ li t1 1
    @@ add t3 t3 t1
    @@ move t6 t3
    @@ move t0 t6
    @@ li t1 4
    @@ mul t0 t0 t1
    @@ addi t0 t0 4
    @@ li v0 9
    @@ move a0 t0
    @@ syscall
    @@ move t0 t6
    @@ sw t0 0 v0
    @@ move t3 v0
    @@ move t5 t3
    @@ li t1 1
    @@ sub t3 t6 t1
    @@ move t6 t3
    @@ b "_label_string_of_int_13"
    @@ label "_label_string_of_int_14"
    @@ li t1 10
    @@ div t3 t2 t1
    @@ li t1 10
    @@ mul t3 t3 t1
    @@ sub t3 t2 t3
    @@ li t1 48
    @@ add t3 t3 t1
    @@ move a0 t6
    @@ move a1 t5
    @@ jal "_check_array_bounds"
    @@ move t0 t6
    @@ li t1 4
    @@ mul t0 t0 t1
    @@ addi t0 t0 4
    @@ move t1 t5
    @@ add t0 t0 t1
    @@ move t1 t3
    @@ sw t1 0 t0
    @@ li t1 10
    @@ div t3 t2 t1
    @@ move t2 t3
    @@ li t1 1
    @@ sub t3 t6 t1
    @@ move t6 t3
    @@ label "_label_string_of_int_13"
    @@ li t1 0
    @@ sge t3 t6 t1
    @@ bnez t3 "_label_string_of_int_14"
    @@ move t4 t5
    @@ move v0 t4
    @@ lw ra 0 fp
    @@ lw fp 4 fp
    @@ addi sp sp 8
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p


let arr_bounds_error_asciiz =
  let d = label "_array_out_of_bounds_string" @@ asciiz "Array out of Bounds : "
  in let _ = { text = nop;
               data = d}
  in d

let check_array_bounds : 'a Mips.asm =
  let p = label "_check_array_bounds"
    (* test borne inferieure *)
    @@ bgez a0 "_ckeck_bound_1"
    @@ move t0 a0
    @@ li v0 4
    @@ la a0 "_array_out_of_bounds_string"
    @@ syscall
    @@ li a0 45
    @@ jal "print"
    @@ neg t0 t0
    @@ addi a0 t0 48
    @@ jal "print"
    @@ li a0 10
    @@ jal "print"
    @@ li v0 10
    @@ syscall
    (* borne inf ok *)
    @@ label "_ckeck_bound_1"
    @@ lw a1 0 a1
    (* test borne superieure *)
    @@ blt a0 a1 "_ckeck_bound_2"
    @@ move t0 a0
    @@ li v0 4
    @@ la a0 "_array_out_of_bounds_string"
    @@ syscall
    @@ addi a0 t0 48
    @@ jal "print"
    @@ li a0 10
    @@ jal "print"
    @@ li v0 10
    @@ syscall
    (*borne sup ok *)
    @@ label "_ckeck_bound_2"
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p

let built_ins =
  let p = label "atoi"
    @@ move t0 a0
    @@ li   t1 0
    @@ li   t2 10
    @@ label "atoi_loop"
    @@ lbu  t3 0 t0
    @@ beq  t3 zero "atoi_end"
    @@ li   t4 48
    @@ blt  t3 t4 "atoi_error"
    @@ li   t4 57
    @@ bgt  t3 t4 "atoi_error"
    @@ addi t3 t3 (-48)
    @@ mul  t1 t1 t2
    @@ add  t1 t1 t3
    @@ addi t0 t0 1
    @@ b "atoi_loop"
    @@ label "atoi_error"
    @@ li   v0 10
    @@ syscall
    @@ label "atoi_end"
    @@ move v0 t1
    @@ jr   ra
  in let _ = { text = p;
               data = nop}
  in p

let print =
  let p = label "print"
    @@ li v0 11
    @@ syscall
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p

let arr_length =
  let p = label "arr_length"
    @@ lw v0 0 a0
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p

let new_array =
  (* calcul de la taille en mot de 32 bits *)
  (*load_value ~$t0 nb_elt*)
  let p = label "_new_array_"
    @@ move t0 a0
    @@ li t1 4
    @@ mul t0 t0 t1
    @@ addi t0 t0 4
    (* appelle system sbrk *)
    @@ li v0 9
    @@ move t1 a0
    @@ move a0 t0
    @@ syscall
    @@ sw t1 0 v0
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p

let store_in_array =
  let p = label "_store_in_array"
    @@ move t0 a1
    @@ li ~$t1 4
    @@ mul ~$t0 ~$t0 ~$t1
    @@ addi ~$t0 ~$t0 4
    @@ move t1 a0
    @@ add ~$t0 ~$t0 ~$t1
    @@ move t1 a2
    @@ sw ~$t1 0 ~$t0
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p

let load_array_elt =
  let p = label "_load_array_elt"
    @@ move t0 a1
    @@ li ~$t1 4
    @@ mul ~$t0 ~$t0 ~$t1
    @@ addi ~$t0 ~$t0 4
    @@ move t1 a0
    @@ add ~$t0 ~$t0 ~$t1
    @@ lw v0 0 t0
    @@ jr ra
  in let _ = { text = p;
               data = nop}
  in p
