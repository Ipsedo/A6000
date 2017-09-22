open AllocatedAst
open Mips

let bool_to_int b = if b then 1 else 0

let generate_main p =

  (* Affecte des emplacements mémoire aux variables locales. *)
  let sp_off   = p.offset in
  let symb_tbl = p.locals in
  let find_alloc id =
    try  AllocatedAst.Symb_Tbl.find id symb_tbl
    with Not_found -> failwith (Printf.sprintf "Node %s not found" id)
  in

  let rec generate_block = function
    | []       -> nop
    | (l,i)::b -> comment l @@ generate_instr i @@ generate_block b

  (* Un appel [load_value r v] génère du code qui place la valeur [v]
     dans le registre [r]. *)
  and load_value r : AllocatedAst.value -> 'a Mips.asm = function
    | Identifier id -> (match find_alloc id with
        | Stack o -> lw r o ~$fp
        | Reg reg -> move r reg) (* /!\ on utilise tt le temps les regitres [0-3] *)
    | Literal id -> (match id with
        | Int i  -> li r i
        | Bool b -> li r (bool_to_int b))

  and generate_binop id (b : IrAst.binop) v1 v2 : 'a Mips.asm  =
    let r1 = ~$t1 in
    let r2 = ~$t2 in
    let res = ~$t0 in
    let op = (match b with
        | Add -> add res r1 r2
        | Mult -> mul res r1 r2
        | Sub -> sub res r1 r2
        | Eq -> (*let un = ~$t4 in
          let tmp = ~$t3 in
          slt res r1 r2 (* res <- r1 < r2 *)
          @@ slt tmp r2 r1 (* tmp < - r2 < r1 *)
          @@ li un 1
          @@ sub res un res (* *)
          @@ sub tmp un tmp
          @@ and_ res res tmp*)
          seq res r1 r2
        | Neq -> (*let tmp = ~$t3 in
         slt res r1 r2
         @@ slt tmp r2 r1
         @@ or_ res res tmp*)
         let un = ~$t3 in
         li un 1
         @@ seq res r1 r2
         @@ sub res un res
        | Lt -> slt res r1 r2 (* < *)
        | Le -> let un = ~$t3 in
        slt res r2 r1
        @@ li un 1
        @@ sub res un res
        | And -> and_ res r1 r2
        | Or -> or_ res r1 r2)
    in
    load_value r1 v1
    @@ load_value r2 v2
    @@ op
    @@ (match find_alloc id with
      |Stack o -> sw res o ~$fp
      |Reg r -> move r res )

  and generate_instr : AllocatedAst.instruction -> 'a Mips.asm = function
    | Print(v) -> load_value ~$a0 v @@ li ~$v0 11 @@ syscall
    | Value(id, v) -> (let reg = ~$t5 in
                       load_value reg v
                       @@ (match find_alloc id with
                         |Stack o -> sw reg o ~$fp
                         |Reg r -> move r reg ))
    | Binop(id, b, v1, v2) -> generate_binop id b v1 v2
    | Label(l) -> label l
    | Goto(l) -> jal l
    | CondGoto(value, l) -> (let tmp1 = ~$t0 in
                             let tmp2 = ~$t1 in
                             li tmp1 1
                             @@ load_value tmp2 value
                             @@ beq tmp2 tmp1 l)
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
