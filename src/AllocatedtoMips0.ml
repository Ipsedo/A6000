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
  in

  let init_fct =
    addi sp sp (-4)
    @@ sw ra 4 sp
    @@ sw fp 0 sp
    @@ addi sp sp sp_off
    (* passer params *)
    (*move fp sp
      @@ addi fp fp (-4)
      @@ lw a0 0 a1
      @@ jal "atoi"
      @@ sw v0 0 fp
      @@ addi sp sp sp_off*)
  in

  let close_fct =
    lw ra 4 sp
    @@ lw fp 0 sp
    @@ addi sp sp 4
    @@ addi sp sp (-sp_off)
  in

  (*let asm = Symb_Tbl.fold
    (fun id info acc ->
      acc @@ (label id) @@ (generate_block info.code))
    fct nop
    in
    { text = init @@ asm @@ close @@ built_ins; data = nop }*)
  init_fct @@ (generate_block fct.code) @@ close_fct

let init_prog =
  move fp sp
  (*@@ addi fp fp (-4)*)
  @@ lw a0 0 a1
  @@ jal "atoi"
  (*@@ sw v0 0 fp*)
  @@ move a0 v0
  (*@@ addi sp sp sp_off*)
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
      (fun id info acc -> acc @@ (label id) @@ (generate_function info))
      p nop
  in
  { text = init_prog @@ close_prog @@ prog @@ built_ins; data = nop}
