(* Transformation de la syntaxe abstraite typée
   en syntaxe abstraite non typée. *)

module S = SourceAst  (* Source de la transformation *)
module T = UntypedAst (* Cible de la transformation  *)

(* erase_identifier_info: S.identifier_info -> T.identifier_info *)
let erase_identifier_info i = i.S.kind

let erase_main p =
  let locals =
    S.Symb_Tbl.fold
      (fun id info tbl ->
	T.Symb_Tbl.add id (erase_identifier_info info) tbl)
      p.S.locals
      T.Symb_Tbl.empty
  in
  { T.locals = locals; T.code = p.S.code }    
