open SourceAst

module State = Map.Make(String)
type state = int State.t

module Heap = Map.Make(Int32)
type heap = int array Heap.t

let heap_offset = ref 0

let rec eval_main p x =

  let rec eval_block env heap b =
    match b with
      [] -> env, heap
    | i::b -> let env1, h = eval_instruction env heap i in
      eval_block env1 h b

  and eval_instruction env heap i =
    match i with
    | Set(Identifier(id, _), e) ->
      let h, res = eval_expression env heap e in
      State.add id res env, h
    | Set(ArrayAccess(e1, e2, _), e) ->
      let h, res1 = eval_expression env heap e1 in
      let h, res2 = eval_expression env h e2 in
      let h, res3 = eval_expression env h e in
      let arr = Heap.find (Int32.of_int res1) h in
      Array.set arr res2 res3;
      env, Heap.add (Int32.of_int res1) arr h
    | While(c, b) as iw ->
      let h, res = eval_expression env heap c in
      if res <> 0
      then let env, h = eval_block env h b in
        eval_instruction env h iw
      else env, heap
    | If(c, b1, b2) ->
      let h, res = eval_expression env heap c in
      if res <> 0
      then eval_block env h b1
      else eval_block env h b2
    | ProcCall(c) -> let str, e = c in
      if str = "print" then
        begin
          match e with
            e1::[] -> let h, res = eval_expression env heap e1 in
            Printf.printf "%c" (Char.chr res);
            env, h
          | _ -> failwith "invalid args for print interpreteur"
        end
      else
        let h1, l = List.fold_left
            (fun (h, acc) elt -> let hnew, res = eval_expression env h elt in
              (hnew, acc@[res]))
            (heap, []) e
        in
        let proc = Symb_Tbl.find str p in
        let proc_state = Symb_Tbl.fold
            (fun k a acc ->
               match a.kind with
                 Formal n -> State.add k (List.nth l (n - 1)) acc
               | _ -> acc)
            proc.locals State.empty
        in
        let _, hnew = eval_block proc_state h1 proc.code in
        env, hnew

  and eval_expression env heap e =
    match e with
      Literal lit  -> heap, eval_literal env lit
    | Location loc -> eval_location env heap loc
    | Binop(op, e1, e2) -> let h, v1 = eval_expression env heap e1 in
      let h, v2 = eval_expression env h e2 in
      let op = match op with
        | Add  -> (+)
        | Mult -> ( * )
        | Sub  -> (-)
        | Div  -> (/)
        | Eq   -> eval_bool_op (=)
        | Neq  -> eval_bool_op (<>)
        | Lt   -> eval_bool_op (<)
        | Le   -> eval_bool_op (<=)
        | Me   -> eval_bool_op (>=)
        | Mt   -> eval_bool_op (>)
        | And  -> min
        | Or   -> max
      in
      h, op v1 v2
    | FunCall(c) -> let str, e = c in
      let h1, l = List.fold_left
          (fun (h, acc) elt -> let hnew, res = eval_expression env h elt in
            (hnew, acc@[res]))
          (heap, []) e
      in
      let proc = Symb_Tbl.find str p in
      let fct_state = Symb_Tbl.fold
          (fun k a acc ->
             match a.kind with
               Formal n -> State.add k (List.nth l (n - 1)) acc
             | _ -> acc)
          proc.locals State.empty
      in
      let fct_state, hnew = eval_block fct_state h1 proc.code in
      hnew, State.find "result" fct_state
    | NewArray(e, _) ->
      let h, nb_elt = eval_expression env heap e in
      let arr = Array.make nb_elt 0 in
      let addr = !heap_offset in
      heap_offset := addr + nb_elt;
      Heap.add (Int32.of_int addr) arr h, addr

  and eval_bool b = if b then 1 else 0
  and eval_bool_op op = fun v1 v2 -> eval_bool (op v1 v2)

  and eval_literal env = function
    | Int(i, _)  -> i
    | Bool(b, _) -> eval_bool b

  and eval_location env heap = function
    | Identifier(id, _) -> heap, State.find id env
    | ArrayAccess(e1, e2, _) ->
      let h, res1 = eval_expression env heap e1 in
      let h, res2 = eval_expression env h e2 in
      let arr = Heap.find (Int32.of_int res1) h in
      h, arr.(res2)
  in

  let fct = Symb_Tbl.find "main" p in
  eval_block (State.singleton "x" x) Heap.empty fct.code



(*let rec eval_main p x =
  let fct = Symb_Tbl.find "main" p in
  eval_block (State.singleton "x" x) Heap.empty fct.code

  (* [eval_block: state -> heap -> block -> state * heap] *)
  and eval_block env heap = function
  | []   -> env, heap
  | i::b -> let env1, h = eval_instruction env heap i in
    eval_block env1 h b


  (* [eval_instruction: state -> instruction -> state * heap] *)
  and eval_instruction env (heap : heap) = function
  | Set(Identifier(id, _), e) -> State.add id (eval_expression env e) env, heap
  | Set(ArrayAccess(e1, e2, _), e) -> failwith "unimplemented store in array interpreteur"
  | While(c, b) as iw ->
    let h, res = eval_expression env heap c in
    if res <> 0
    then let env, h = eval_block env h b in
      eval_instruction env h iw
    else env, h
  | If(c, b1, b2) ->
    let h, res = eval_expression env heap c in
    if res <> 0
    then eval_block env h b1
    else eval_block env h b2
  | ProcCall(c) -> failwith "unimplemented procedure interpreteur"

  (* [eval_expression: state -> heap -> expression -> heap * int] *)
  and eval_expression env (heap : heap) = function
  | Literal lit  -> heap, eval_literal env lit
  | Location loc -> heap, eval_location env loc
  | Binop(op, e1, e2) -> let h, v1 = eval_expression env heap e1 in
    let h, v2 = eval_expression env h e2 in
    let op = match op with
      | Add  -> (+)
      | Mult -> ( * )
      | Sub  -> (-)
      | Div  -> (/)
      | Eq   -> eval_bool_op (=)
      | Neq  -> eval_bool_op (<>)
      | Lt   -> eval_bool_op (<)
      | Le   -> eval_bool_op (<=)
      | Me   -> eval_bool_op (>=)
      | Mt   -> eval_bool_op (>)
      | And  -> min
      | Or   -> max
    in
    h, op v1 v2
  | FunCall(c) -> failwith "unimplemented fun interpreteur"
  | NewArray(e, _) ->
    let nb_elt = eval_expression e in
    let arr = Array.make nb_elt 0 in
    let addr = !heap_offset in
    heap_offset := addr + nb_elt;
    Heap.add addr arr heap, addr


  and eval_bool b = if b then 1 else 0
  and eval_bool_op op = fun v1 v2 -> eval_bool (op v1 v2)

  and eval_literal env = function
  | Int(i, _)  -> i
  | Bool(b, _) -> eval_bool b

  and eval_location env = function
  | Identifier(id, _) -> State.find id env
  | ArrayAccess(str, e, _) -> failwith "unimplemented array access interpreteur"*)
