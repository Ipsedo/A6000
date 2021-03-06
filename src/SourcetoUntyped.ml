(* Transformation de la syntaxe abstraite typée
   en syntaxe abstraite non typée. *)

module S = SourceAst  (* Source de la transformation *)
module T = UntypedAst (* Cible de la transformation  *)

(* erase_identifier_info: S.identifier_info -> T.identifier_info *)
let rec erase_identifier_info i = i.S.kind

(* On enlève la position des location et literal -> on a déjà check les types *)
and erase_location l = match l with
    S.Identifier (str, _) -> T.Identifier str
  | S.ArrayAccess(e1, e2, _) -> T.ArrayAccess(erase_expression e1, erase_expression e2)

and erase_literal l = match l with
    S.Int (i, _) -> T.Int i
  | S.Bool (b, _) -> T.Bool b

and erase_expression e = match e with
  | S.Location id -> T.Location(erase_location id)
  | S.Literal v -> T.Literal(erase_literal v)
  | S.Binop(b, e1, e2) -> let ne1 = erase_expression e1 in
    let ne2 = erase_expression e2 in
    T.Binop(b, ne1, ne2)
  | S.FunCall(c) -> let str, e = c in
    let ne = List.fold_left
        (fun acc elt -> acc@[(erase_expression elt)]) [] e in
    T.FunCall((str, ne))
  | S.NewArray(e, _) -> T.NewArray(erase_expression e)
  | S.NewDirectArray(e1) -> let e2 = List.map erase_expression e1 in
    T.NewDirectArray(e2)

and erase_instruction i = match i with
  | S.Set(loc, e) -> T.Set(erase_location loc, erase_expression e)
  | S.While(e, b) -> T.While(erase_expression e, erase_code b)
  | S.If(e, b1, b2) -> T.If(erase_expression e, erase_code b1, erase_code b2)
  | S.ProcCall(c) -> let str, e = c in
    let ne = List.fold_left
        (fun acc elt -> acc@[(erase_expression elt)]) [] e in
    T.ProcCall((str, ne))

and erase_code c = let rec aux c accu = match c with
    | [] -> accu
    | i::t -> aux t ((erase_instruction i)::accu)
  in List.rev (aux c [])

let erase_prog p =
  S.Symb_Tbl.fold
    (fun id infos acc ->
       let locals = S.Symb_Tbl.fold
           (fun id info tbl -> T.Symb_Tbl.add id (erase_identifier_info info) tbl)
           infos.S.locals
           T.Symb_Tbl.empty
       in
       let formal = List.fold_left
           (fun acc (_, a) -> acc@[a])
           [] infos.S.formals
       in
       T.Symb_Tbl.add id
         { T.locals = locals;
           T.formals = formal;
           T.code = erase_code infos.S.code }
         acc)
    p T.Symb_Tbl.empty
