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

  and ad_hoc dest_ref id =
    match find_alloc id with
    | Reg reg -> dest_ref := reg; true
    | _ -> false

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
    let will_ad_hoc = ad_hoc dest id in
    let instr1, o1 = load_value_ad_hoc ~$t0 v1 in
    let instr2, o2 = load_value_ad_hoc ~$t1 v2 in
    let r1 = match o1 with Some r -> r | _ -> ~$t0 in
    let r2 = match o2 with Some r -> r | _ -> ~$t1 in
    let res = if will_ad_hoc then !dest else ~$t0 in
    let op =
      (match b with
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
        res r1 r2
    in
    instr1
    @@ instr2
    @@ op
    @@ if will_ad_hoc then nop else store_identifier res id

  and generate_instr : AllocatedAst.instruction -> 'a Mips.asm = function
    | Value(id, v) ->
      begin
        let dest = ref ~$t0 in
        let instr, o = load_value_ad_hoc ~$t0 v in
        let will_ad_hoc = ad_hoc dest id in
        let r1 = match o with
          | Some r -> r
          | _ -> ~$t0
        in
        instr
        @@ if will_ad_hoc then move !dest r1 else store_identifier r1 id
      end
    | Binop(id, b, v1, v2) -> generate_binop id b v1 v2
    | Label(l) -> label l
    | Goto(l) -> b l
    | CondGoto(value, l) ->
      begin
        let tmp1 = ~$t0 in
        let instr, o = load_value_ad_hoc tmp1 value in
        instr
        @@ match o with
          Some r -> bnez r l
        | _ -> bnez tmp1 l
      end
    | Comment(str) -> comment str
    | FunCall(res, str, v_list) -> generate_funcall str v_list res
    | ProcCall(str, v_list) -> generate_proccall str v_list
    | Load(id, (arr, index)) -> check_array_bound arr index
      @@ load_value a0 arr
      @@ load_value a1 index
      @@ jal "_load_array_elt"
      @@ store_identifier v0 id
    | Store((arr, index), v) -> check_array_bound arr index
      @@ load_value a0 arr
      @@ load_value a1 index
      @@ load_value a2 v
      @@ jal "_store_in_array"
    | New(id, v) ->
      load_value a0 v
      @@ jal "_new_array_"
      @@ match find_alloc id with
        Stack o -> sw ~$v0 o ~$fp
      | Reg r -> move r ~$v0

  (* array stuff -> faire ad_hoc + arret prgm si dépassement capacité *)

  and check_array_bound arr index =
    match arr with
      Identifier id -> begin
        load_value ~$a0 index
        @@ load_value ~$a1 arr
        @@ jal "_check_array_bounds"
      end
    | _ -> failwith "tab pointer can't be a Literal"

  (* proc & fun call stuff *)

  and allocate_reg_formal index value =
    load_value (Printf.sprintf "$a%d" index) value

  and allocate_stack_formal index value = (* index ne pas comprenant a0-a3 ! *)
    load_value ~$t0 value
    @@ sw ~$t0 (-index * 4) ~$sp (* -4 pour @ suivante de sp *)

  and alloc_formal index value =
    if index < 4 then
      allocate_reg_formal index value
    else
      allocate_stack_formal (index - 4) value

  and gen_arg_and_nb v_list =
    List.fold_left
      (fun (acc, index) elt -> (acc @@ alloc_formal index elt, index + 1))
      (nop, 0) v_list

  and nb_reg = Symb_Tbl.fold
      (fun id alloc_info acc ->
         match alloc_info with
           Reg s -> let index = int_of_string (String.sub s 2 1) in
           if index > acc then index else acc
         | _ -> acc)
      fct.locals 0

  and set_result res =
    match find_alloc res with
      Stack o -> sw ~$v0 o ~$fp
    | Reg r -> move r ~$v0

  and generate_funcall str v_list res =
    generate_proccall str v_list @@ set_result res

  and generate_proccall str v_list = (* ok *)
    let arg, nb = gen_arg_and_nb v_list in
    let stack_args = if nb < 4 then 0 else (nb - 4) * 4 in (* -4 pour a0-a3 *)
    let save_reg = str <> "print" && str <> "arr_length" in
    begin
      if save_reg then
        save_t_reg nb_reg else nop
    end
    @@ arg
    @@ addi sp sp (-stack_args)
    @@ jal str
    @@ addi sp sp stack_args
    @@ if save_reg then load_t_reg nb_reg else nop

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
      (*let reg = Printf.sprintf "$t%d" (nb - 1 - i + 2) in
        acc := !acc @@ lw reg (i * 4) sp*)
      let reg = Printf.sprintf "$t%d" (i + 2) in
      acc := !acc @@ lw reg (-i * 4 - 4) sp
    done;
    addi sp sp (nb * 4) @@ !acc
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
  in

  let result =
    let res = try Some (Symb_Tbl.find "result" symb_tbl)
      with Not_found -> None
    in
    match res with
      Some s -> (match s with
          Reg r -> move ~$v0 r
        | Stack o -> lw ~$v0 o ~$fp)
    | None -> nop
  in

  let close_fct = (* ok *)
    result
    @@ lw ra 0 fp
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

let generate_prog p =
  (* on supprime la fake-fonction print pour ajouter les bon code MIPS *)
  let p = Symb_Tbl.filter
      (fun k _ ->
         k <> "print"
         && k <> "log10"
         && k <> "string_of_int"
         && k <> "arr_length"
      ) p in
  let prog = Symb_Tbl.fold
      (fun id info acc -> acc @@ label id @@ generate_function info)
      p nop
  in
  { text = init_prog
      @@ close_prog
      @@ prog
      @@ MipsMisc.new_array
      @@ MipsMisc.load_array_elt
      @@ MipsMisc.store_in_array
      @@ MipsMisc.built_ins
      @@ MipsMisc.check_array_bounds
      @@ MipsMisc.print
      @@ MipsMisc.log10
      @@ MipsMisc.string_of_int
      @@ MipsMisc.arr_length;
    data = MipsMisc.arr_bounds_error_asciiz}
