module S = IrAst
module T = AllocatedAst

(* Allocation *)
let allocate_main reg_flag p =
  let current_offset = ref 0 in
  
  let tbl =
    if reg_flag
    then failwith "A completer"
    else
      (* Tout sur la pile *)
      S.Symb_Tbl.mapi (fun id (info: S.identifier_info) ->
	match info with
	  | FormalX -> T.Stack 0
	  | _       -> failwith "A completer"
      ) p.S.locals
  in
  
  { T.locals = tbl; T.offset = !current_offset; T.code = p.S.code }
    
