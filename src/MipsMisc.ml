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
  	@@ move t3 t3
  	@@ li t1 10
  	@@ mul t3 t3 t1
  	@@ move t3 t3
  	@@ sub t3 t2 t3
  	@@ move t3 t3
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
