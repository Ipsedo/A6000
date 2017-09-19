open AllocatedAst
open Mips

let bool_to_int b = if b then 1 else 0

let generate_main p =

  (* Affecte des emplacements mémoire aux variables locales. *)
  let sp_off   = p.offset in
  let symb_tbl = p.locals in
  let nb_var = AllocatedAst.Symb_Tbl.cardinal symb_tbl in
  let find_alloc id =
    try  AllocatedAst.Symb_Tbl.find id symb_tbl
    with Not_found -> failwith (Printf.sprintf "Node %s not found" id)
  in

  let find_index_var v = let aux v = AllocatedAst.Symb_Tbl.fold (fun k _ accu -> match accu with
        (cpt, res) -> let new_cpt = cpt + 1 in if k = v then (new_cpt, new_cpt) else (new_cpt, res)) symb_tbl (0, -1)
    in match aux v with
      (_, index) -> index
  in
  let make_register i : Mips.register = Obj.magic ("$t"^(string_of_int i)) in
  let get_register v = make_register (find_index_var v) in
  let get_stack_addr id : int = let i = find_index_var id in -i * 4 in
  let rec generate_block = function
    | []       -> nop
    | (l,i)::b -> comment l @@ generate_instr i @@ generate_block b

  (* Un appel [load_value r v] génère du code qui place la valeur [v]
     dans le registre [r]. *)
  and load_value r : AllocatedAst.value -> 'a Mips.asm = function
    | Identifier id -> (match find_alloc id with
        | Stack o -> lw r o ~$fp
        | Reg reg -> move r (get_register reg))
    | Literal id ->   (match id with
        | Int i  -> li r i
        | Bool b -> li r (bool_to_int b))

  and generate_instr : AllocatedAst.instruction -> 'a Mips.asm = function
    | Print(v) -> load_value ~$a0 v @@ li ~$v0 11 @@ syscall
    | Value(id, v) -> (let reg = get_register id in load_value reg v @@ sw reg (get_stack_addr id) ~$fp)
    | Binop(id, b, v1, v2) -> (
        let r1 = make_register (nb_var) in
        let r2 = make_register (nb_var + 1) in
        load_value r1 v1
        @@ load_value r2 v2
        @@ (
          match b with
          | Add -> add  (get_register id)  r1  r2
          | Mult -> mul  (get_register id)  r1  r2
          | Sub -> sub  (get_register id)  r1  r2
          | Eq -> and_  (get_register id)  r1  r2 (* pas bon !!!*)
          | Neq -> and_  (get_register id)  r1  r2 @@ not_  (get_register id)  (get_register id) (*  pas bon !!!*)
          | Lt -> slt  (get_register id)  r1  r2
          | Le -> failwith("unsuported <= !")
          | And -> and_  (get_register id)  r1  r2
          | Or -> or_  (get_register id)  r1  r2
        ))
    @@ sw (get_register id) (get_stack_addr id) ~$fp
    | Label(label) -> failwith("label unsuported")                             (* Point de saut           *)
    | Goto(label) -> failwith("label unsuported")                              (* Saut                    *)
    | CondGoto(value, label) -> failwith("label unsuported") (*beq value (bool_to_int true) label*)
    | Comment(str) -> comment str   
  in

  let init =
    move fp sp
    @@ addi fp fp (-4)
    @@ lw a0 0 a1
    @@ jal "atoi"
    @@ sw v0 0 fp
    @@ addi sp sp sp_off
  in

  let close = li v0 10 @@ syscall in

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
  in

  let asm = generate_block p.code in
  { text = init @@ asm @@ close @@ built_ins; data = nop }
