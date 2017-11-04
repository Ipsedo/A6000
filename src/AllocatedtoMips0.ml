open AllocatedAst
open Mips

let bool_to_int b = if b then 1 else 0

let generate_function fct =

  (* Affecte des emplacements mémoire aux variables locales. *)
  let sp_off   = fct.offset in
  let symb_tbl = fct.locals in

  let find_alloc id =
    try  AllocatedAst.Symb_Tbl.find id symb_tbl
    with Not_found -> failwith (Printf.sprintf "Node %s not found" id)
  in

  let rec generate_block = function
    | []       -> nop
    | (l,i)::b -> comment l @@ generate_instr i @@ generate_block b

  and store_identifier res id = match find_alloc id with
    |Stack o -> sw res o ~$fp
    |Reg r -> move r res

  (* Un appel [load_value r v] génère du code qui place la valeur [v]
     dans le registre [r]. *)
  and load_value r : AllocatedAst.value -> 'a Mips.asm = function
    | Identifier id -> (match find_alloc id with
        | Stack o -> lw r o ~$fp
        | Reg reg -> move r reg)
    | Literal id -> (match id with
        | Int i  -> li r i
        | Bool b -> li r (bool_to_int b))

  and load_value_ad_hoc r : AllocatedAst.value ->
    'a Mips.asm * Mips.register option = function
    | Identifier id -> (match find_alloc id with
        | Stack o -> lw r o ~$fp, None
        | Reg reg -> nop, Some reg)
    | Literal id -> (match id with
        | Int i  -> li r i, None
        | Bool b -> li r (bool_to_int b), None)

  and generate_binop id (b : IrAst.binop) v1 v2 : 'a Mips.asm  =
    let dest = ref "" in
    let will_ad_hoc = match find_alloc id with
      | Reg reg -> dest := reg; true
      | Stack _ -> false
    in
    let instr1, o1 = load_value_ad_hoc ~$t0 v1 in
    let instr2, o2 = load_value_ad_hoc ~$t1 v2 in
    let r1 = match o1 with Some r -> r | _ -> ~$t0 in
    let r2 = match o2 with Some r -> r | _ -> ~$t1 in
    let res = if will_ad_hoc then !dest else ~$t0 in
    let op = ((match b with
        | Add -> add
        | Mult -> mul
        | Div  -> div
        | Sub -> sub
        | Eq -> seq
        | Neq -> sne
        | Lt -> slt
        | Le -> sle
        | Mt -> sgt
        | Me -> sge
        | And -> and_
        | Or -> or_)
         res r1 r2)
    in
    instr1
    @@ instr2
    @@ op
    @@ if will_ad_hoc then nop else store_identifier res id

  and generate_instr : AllocatedAst.instruction -> 'a Mips.asm = function
    | Print(v) -> load_value ~$a0 v @@ li ~$v0 11 @@ syscall
    | Value(id, v) -> (let dest = ref ~$t0 in
                       let instr, o = load_value_ad_hoc ~$t0 v in
                       let will_ad_hoc = match find_alloc id with
                         | Reg r -> dest := r; true
                         | Stack _ -> false
                       in
                       let r1 = match o with
                         | Some r -> r
                         | _ -> ~$t0
                       in
                       instr
                       @@ if will_ad_hoc then
                         move !dest r1
                       else store_identifier r1 id)
    | Binop(id, b, v1, v2) -> generate_binop id b v1 v2
    | Label(l) -> label l
    | Goto(l) -> b l
    | CondGoto(value, l) -> (let tmp1 = ~$t0 in
                             let instr, o = load_value_ad_hoc tmp1 value in
                             instr
                             @@ match o with
                               Some r -> bnez r l
                             | _ -> bnez tmp1 l)
    | Comment(str) -> comment str
    | FunCall(_) -> failwith "unimplemented funcall allocatedToMips"
    | ProcCall(str, v_list) -> generate_proccall str v_list

  and generate_proccall str v_list = (* ok *)
    let allocate_reg_formal index value =
      load_value (Printf.sprintf "$a%d" index) value
    in
    let allocate_stack_formal index value = (* index ne pas comprenant a0-a3 ! *)
      load_value ~$t0 value
      @@ sw ~$t0 (-index * 4 - 4) ~$sp (* -4 pour @ suivante de sp *)
    in
    let alloc_formal index value =
      if index < 4 then
        allocate_reg_formal index value
      else
        allocate_stack_formal (index - 4) value
    in
    let arg, nb = List.fold_left
        (fun (acc, index) elt -> (acc @@ alloc_formal index elt, index + 1))
        (nop, 0) v_list
    in
    let stack_args = if nb < 4 then 0 else (nb - 4) * 4 (* -4 pour a0-a3 *)
    in
    let nb_reg = Symb_Tbl.fold
        (fun id alloc_info acc ->
           match alloc_info with
             Reg s -> let index = int_of_string (String.sub s 2 1) in
             if index > acc then index else acc
           | _ -> acc)
        fct.locals 0
    in
    save_t_reg nb_reg
    @@ arg
    @@ addi sp sp (-stack_args)
    @@ jal str
    @@ addi sp sp stack_args
    @@ load_t_reg nb_reg

  and save_t_reg nb =
    let acc = ref nop in
    for i=0 to (nb - 1) do
      let reg = Printf.sprintf "$t%d" (i + 2) in
      acc := !acc @@ sw reg (-i * 4 - 4) sp
    done;
    !acc @@ addi sp sp (-nb * 4)

  and load_t_reg nb =
    let acc = ref nop in
    for i=0 to (nb - 1) do
      let reg = Printf.sprintf "$t%d" (7 - i + 2) in
      acc := !acc @@ lw reg (i * 4 + 4) sp
    done;
    !acc @@ addi sp sp (nb * 4)
  in

  let affect_formals = (* ok *)
    let nb = List.length fct.formals in
    let aux index str =
      if index < 4 then begin
        match find_alloc str with
          Stack o -> sw (Printf.sprintf "$a%d" index) o ~$fp
        | Reg r -> move r (Printf.sprintf "$a%d" index)
      end
      else begin
        let index_stack = index - 4 in
        let real_index = ((nb - 4) - index_stack) * 4 + 8 in (* +8 pr pointer au dessus de old_fp *)
        match find_alloc str with
          Stack o -> lw ~$t0 real_index ~$fp
          @@ sw ~$t0 o ~$fp
        | Reg r -> lw r real_index ~$fp
      end
    in
    let aff, _ = List.fold_left
        (fun (acc, index) str_formal ->
           (acc @@ aux index str_formal, index + 1))
        (nop, 0) fct.formals
      in aff
  in

  let init_fct = (* ok *)
    sw fp (-4) sp              (* save $fp *)
    @@ sw ra (-8) sp           (* old_ra <- $ra *)
    @@ addi sp sp (-8)         (* fp pointe sur old_ra *)
    @@ move fp sp              (* new @ stack pointer *)
    @@ addi sp sp sp_off       (* allocation variable locale *)
    @@ affect_formals          (* affectation des paramètres formels *)
    (* passer params *)
    (*move fp sp
      @@ addi fp fp (-4)
      @@ lw a0 0 a1
      @@ jal "atoi"
      @@ sw v0 0 fp
      @@ addi sp sp sp_off*)
  in

  let close_fct = (* ok *)
    lw ra 0 fp
    @@ lw fp 4 fp
    @@ addi sp sp (-sp_off + 8)
    @@ jr ra
  in
  init_fct @@ generate_block fct.code @@ close_fct

let init_prog =
  move fp sp
  @@ lw a0 0 a1
  @@ jal "atoi"
  @@ move a0 v0
  @@ jal "main"

let close_prog = li v0 10 @@ syscall

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

let generate_prog p =
  let prog = Symb_Tbl.fold
      (fun id info acc -> acc @@ label id @@ generate_function info)
      p nop
  in
  { text = init_prog @@ close_prog @@ prog @@ built_ins; data = nop}
