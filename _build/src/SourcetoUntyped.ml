(* Transformation de la syntaxe abstraite typée
   en syntaxe abstraite non typée. *)

module S = SourceAst  (* Source de la transformation *)
module T = UntypedAst (* Cible de la transformation  *)

(* erase_identifier_info: S.identifier_info -> T.identifier_info *)
let erase_identifier_info i = i.S.kind

let erase_location l = match l with
    S.Identifier (str, _) -> T.Identifier str

let erase_literal l = match l with
    S.Int (i, _) -> T.Int i
  | S.Bool (b, _) -> T.Bool b

let rec erase_expression e = match e with
  | S.Location id -> T.Location(erase_location id)
  | S.Literal v -> T.Literal(erase_literal v)
  | S.Binop(b, e1, e2) -> let ne1 = erase_expression e1 in
    let ne2 = erase_expression e2 in
    T.Binop(b, ne1, ne2)

let rec erase_instruction i = match i with
  | S.Set(loc, e) -> T.Set(erase_location loc, erase_expression e)
  | S.While(e, b) -> T.While(erase_expression e, erase_code b)
  | S.If(e, b1, b2) -> T.If(erase_expression e, erase_code b1, erase_code b2)
  | S.Print(e) -> T.Print(erase_expression e)

and erase_code c = let rec aux c accu = match c with
    | [] -> accu
    | i::t -> aux t ((erase_instruction i)::accu)
  in List.rev (aux c [])

let erase_main p =
  let locals =
    S.Symb_Tbl.fold
      (fun id info tbl ->
         T.Symb_Tbl.add id (erase_identifier_info info) tbl)
      p.S.locals
      T.Symb_Tbl.empty
  in
  { T.locals = locals; T.code = erase_code p.S.code }
