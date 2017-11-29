module S = TypedAst
module T = UntypedAst


let erase_prog p =

  let rec erase_location typed_location =
    match typed_location.S.elt with
      S.Identifier(i, _) -> T.Identifier(i)
    | S.ArrayAccess(e1, e2, _) -> let ne1 = erase_expression e1 in
      let ne2 = erase_expression e2 in
      T.ArrayAccess(ne1, ne2)

  and erase_literal literal =
    match literal with
      SourceAst.Int(i, _) -> T.Int(i)
    | SourceAst.Bool(b, _) -> T.Bool(b)

  and string_of_typ t =
    match t with
    | SourceAst.TypInteger -> "integer"
    | SourceAst.TypBoolean -> "boolean"
    | SourceAst.TypArray(sub_t) -> "arrayof" ^ (string_of_typ sub_t)

  and rename_fct_call expr str =
    List.fold_left (fun acc elt -> acc ^ "_" ^ (string_of_typ elt.S.annot)) str expr

  and erase_call typed_call =
    let c = typed_call.S.elt in
    let str, e = c in
    let str = rename_fct_call e str in
    let e = List.map erase_expression e in
    (str, e)

  and erase_expression typed_expression =
    match typed_expression.S.elt with
      S.Literal l -> T.Literal(erase_literal l)
    | S.Location l -> T.Location(erase_location l)
    | S.Binop(b, e1, e2) -> T.Binop(b, erase_expression e1, erase_expression e2)
    | S.FunCall(c) -> T.FunCall(erase_call c)
    | S.NewArray(es, _) -> T.NewArray(erase_expression es)
    | S.NewDirectArray(es) ->
      let es = List.map erase_expression es in
      T.NewDirectArray(es)

  and erase_instruction i =
    match i with
      S.Set(l, e) -> T.Set(erase_location l, erase_expression e)
    | S.While(e, b) -> T.While(erase_expression e, erase_block b)
    | S.If(e, b1, b2) -> T.If(erase_expression e, erase_block b1, erase_block b2)
    | S.ProcCall(c) -> T.ProcCall(erase_call c)

  and erase_block b =
    List.map erase_instruction b

  and erase_formal f =
    List.map (fun (_, str) -> str) f

  and erase_identifier_info i = i.SourceAst.kind
  in
  let rename_fct str formals =
    List.fold_left (fun acc (t,_) -> acc ^ "_" ^ (string_of_typ t)) str formals
  in

  let erase_fct_decl key infos acc =
    let locals = S.Symb_Tbl.fold
        (fun id info tbl -> T.Symb_Tbl.add id (erase_identifier_info info) tbl)
        infos.S.locals
        T.Symb_Tbl.empty
    in
    let ninfos = {
      T.formals = erase_formal infos.S.formals;
      T.locals = locals;
      T.code = erase_block infos.S.code
    }
    in
    let str = rename_fct key infos.S.formals in
    T.Symb_Tbl.add str ninfos acc
  in

  let erase_fct_decl_list key infos_l symb_tbl =
    List.fold_left (fun acc infos -> erase_fct_decl key infos acc) symb_tbl infos_l
  in
  S.Symb_Tbl.fold
    (fun key infos_l acc -> erase_fct_decl_list key infos_l acc)
    p T.Symb_Tbl.empty
(*S.Symb_Tbl.fold
  (fun key infos acc ->
     let locals = S.Symb_Tbl.fold
         (fun id info tbl -> T.Symb_Tbl.add id (erase_identifier_info info) tbl)
         infos.S.locals
         T.Symb_Tbl.empty
     in
     let ninfos = {
       T.formals = erase_formal infos.S.formals;
       T.locals = locals;
       T.code = erase_block infos.S.code
     }
     in
     T.Symb_Tbl.add key ninfos acc)
  p T.Symb_Tbl.empty*)