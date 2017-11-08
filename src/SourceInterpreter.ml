open SourceAst

module State = Map.Make(String)
type state = int State.t

let rec eval_main p x =
  let fct = Symb_Tbl.find "main" p in
  eval_block (State.singleton "x" x) fct.code

(* [eval_block: state -> block -> state] *)
and eval_block env = function
  | []   -> env
  | i::b -> let env1 = eval_instruction env i in
    eval_block env1 b

(* [eval_instruction: state -> instruction -> state] *)
and eval_instruction env = function
  | Set(Identifier(id, _), e) -> State.add id (eval_expression env e) env
  | While(c, b) as iw ->
    if eval_expression env c <> 0
    then let env = eval_block env b in
      eval_instruction env iw
    else env
  | If(c, b1, b2) ->
    if eval_expression env c <> 0
    then eval_block env b1
    else eval_block env b2
  | ProcCall(c) -> failwith "unimplemented proc interpreteur"
  | _ -> failwith "unimplemented source interpreteur 1"

(* [eval_expression: state -> expression -> int] *)
and eval_expression env = function
  | Literal lit  -> eval_literal env lit
  | Location loc -> eval_location env loc
  | FunCall(c) -> failwith "unimplemented fun interpreteur"
  | Binop(op, e1, e2) -> let v1 = eval_expression env e1 in
    let v2 = eval_expression env e2 in
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
    op v1 v2
  | NewArray(e, t) -> failwith "unimplemented new array interpreteur"

and eval_bool b = if b then 1 else 0
and eval_bool_op op = fun v1 v2 -> eval_bool (op v1 v2)

and eval_literal env = function
  | Int(i, _)  -> i
  | Bool(b, _) -> eval_bool b

and eval_location env = function
  | Identifier(id, _) -> State.find id env
  | ArrayAccess(str, e, _) -> failwith "unimplemented array access interpreteur"
