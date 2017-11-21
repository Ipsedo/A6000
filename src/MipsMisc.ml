open Mips

(* log10 function integer -> integer *)

let log10 : 'a Mips.asm =
  label "log10"
  @@	sw fp (-4) sp
  @@	sw ra (-8) sp
  @@	addi sp sp (-8)
  @@	move fp sp
  @@	addi sp sp (-4)
  @@	move t2 a0
  @@	li t0 0
  @@	move t3 t0
  @@	li t1 10
  @@	div t4 t2 t1
  @@	move t2 t4
  @@	b "_label_log10_1"
  @@  label "_label_log10_2"
  @@	li t1 1
  @@	add t4 t3 t1
  @@	move t3 t4
  @@	li t1 10
  @@	div t4 t2 t1
  @@	move t2 t4
  @@  label "_label_log10_1"
  @@	li t1 0
  @@	sgt t4 t2 t1
  @@	bnez t4 "_label_log10_2"
  @@	sw t3 (-4) fp
  @@	lw v0 (-4) fp
  @@	lw ra 0 fp
  @@	lw fp 4 fp
  @@	addi sp sp 12
  @@	jr ra

(* String (ascii int tab) of int *)

let string_of_int : 'a Mips.asm =
  label "string_of_int"
  @@	sw fp (-4) sp
  @@  sw ra (-8) sp
  @@  addi sp sp (-8)
  @@	move fp sp
  @@	addi sp sp 0
  @@	move t2 a0
  @@	sw t2 (-4) sp
  @@	sw t3 (-8) sp
  @@	sw t4 (-12) sp
  @@	sw t5 (-16) sp
  @@	sw t6 (-20) sp
  @@	sw t7 (-24) sp
  @@	addi sp sp (-24)
  @@	move a0 t2
  @@	addi sp sp 0
  @@	jal "log10"
  @@	addi sp sp 0
  @@	addi sp sp 24
  @@	lw t2 (-4) sp
  @@	lw t3 (-8) sp
  @@	lw t4 (-12) sp
  @@	lw t5 (-16) sp
  @@	lw t6 (-20) sp
  @@	lw t7 (-24) sp
  @@	move t3 v0
  @@	li t1 1
  @@	add t3 t3 t1
  @@	move t6 t3
  @@	move a0 t6
  @@	jal "_new_array_"
  @@	move t3 v0
  @@	move t5 t3
  @@	li t1 1
  @@	sub t3 t6 t1
  @@	move t6 t3
  @@	b "_label_string_of_int_13"
  @@  label "_label_string_of_int_14"
  @@	li t1 10
  @@	div t3 t2 t1
  @@	li t1 10
  @@	mul t3 t3 t1
  @@	sub t3 t2 t3
  @@	li t1 48
  @@	add t3 t3 t1
  @@	move a0 t6
  @@	move a1 t5
  @@	jal "_check_array_bounds"
  @@	move a0 t5
  @@	move a1 t6
  @@	move a2 t3
  @@	jal "_store_in_array"
  @@	li t1 10
  @@	div t3 t2 t1
  @@	move t2 t3
  @@	li t1 1
  @@	sub t3 t6 t1
  @@	move t6 t3
  @@  label "_label_string_of_int_13"
  @@	li t1 0
  @@	sge t3 t6 t1
  @@	bnez t3 "_label_string_of_int_14"
  @@	move t4 t5
  @@	move v0 t4
  @@	lw ra 0 fp
  @@	lw fp 4 fp
  @@	addi sp sp 8
  @@	jr ra

(* Atoi function *)

let built_ins =
  label "atoi"
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

(* Print procedure *)

let print =
  label "print"
  @@ li v0 11
  @@ syscall
  @@ jr ra

(* Array function & procedure *)

let arr_length =
  label "arr_length"
  @@ lw v0 0 a0
  @@ jr ra

let new_array =
  (* calcul de la taille en mot de 32 bits *)
  (* a0 = nb_elt *)
  label "_new_array_"
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

let store_in_array =
  label "_store_in_array"
  @@ move t0 a1
  @@ li ~$t1 4
  @@ mul ~$t0 ~$t0 ~$t1
  @@ addi ~$t0 ~$t0 4
  @@ move t1 a0
  @@ add ~$t0 ~$t0 ~$t1
  @@ move t1 a2
  @@ sw ~$t1 0 ~$t0
  @@ jr ra

let load_array_elt =
  label "_load_array_elt"
  @@ move t0 a1
  @@ li ~$t1 4
  @@ mul ~$t0 ~$t0 ~$t1
  @@ addi ~$t0 ~$t0 4
  @@ move t1 a0
  @@ add ~$t0 ~$t0 ~$t1
  @@ lw v0 0 t0
  @@ jr ra

let arr_bounds_error_asciiz =
  label "_array_out_of_bounds_string" @@ asciiz "Array out of Bounds : "

(* a0 : index, a1 : pointeur tab*)
(* besoin de faire string of int pr index, galère faut save reg du caller... *)
let check_array_bounds : 'a Mips.asm =
  label "_check_array_bounds"
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

let unused = { text = check_array_bounds
                 @@ load_array_elt
                 @@ store_in_array
                 @@ new_array
                 @@ arr_length
                 @@ print
                 @@ built_ins
                 @@ string_of_int
                 @@ log10;
               data = arr_bounds_error_asciiz}
