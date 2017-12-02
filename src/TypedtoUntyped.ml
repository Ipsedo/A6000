module S = TypedAst
module T = UntypedAst


let erase_prog p =

  let rec erase_location typed_location =
    match typed_location.S.elt with
      S.Identifier(i) -> T.Identifier(i)
    | S.ArrayAccess(e1, e2) -> let ne1 = erase_expression e1 in
      let ne2 = erase_expression e2 in
      T.ArrayAccess(ne1, ne2)
    | S.FieldAccess(f_a) ->
      let (e, str) = f_a.S.elt in
      let struct_name =
        match e.S.annot with
          TypStruct str -> str
        | _ -> failwith "Field acces must be done on struct !"
      in
      let (struct_fields, _) = S.Symb_Tbl.find struct_name p.S.structs in
      let index, _ = List.fold_left
          (fun (acc, index) (field, _) ->
             if str = field then (index, index + 1) else (acc, index + 1))
          (-1, 0) struct_fields
      in
      T.ArrayAccess(erase_expression e, Literal(Int(index)))

  and erase_call typed_call =
    let c = typed_call.S.elt in
    let str, e = c in
    let e = List.map erase_expression e in
    (str, e)

  and erase_expression typed_expression =
    match typed_expression.S.elt with
      S.Literal l -> T.Literal(l)
    | S.Location l -> T.Location(erase_location l)
    | S.Binop(b, e1, e2) -> erase_binop b e1 e2
    | S.FunCall(c) -> T.FunCall(erase_call c)
    | S.NewArray(es, _) -> T.NewArray(erase_expression es)
    | S.NewDirectArray(es) ->
      let es = List.map erase_expression es in
      T.NewDirectArray(es)
    | S.NewRecord(str) ->
      let (struct_field, _) = S.Symb_Tbl.find str p.S.structs in
      let nb_field = List.length struct_field in
      T.NewArray(Literal(Int(nb_field)))

  and erase_op b =
    match b with
    | SourceAst.Add -> T.Add
    | SourceAst.Mult -> T.Mult
    | SourceAst.Sub -> T.Sub
    | SourceAst.Div -> T.Div
    | SourceAst.Eq -> T.Eq
    | SourceAst.Neq -> T.Neq
    | SourceAst.EqStruct -> T.Eq
    | SourceAst.Lt -> T.Lt
    | SourceAst.Le -> T.Le
    | SourceAst.Mt -> T.Mt
    | SourceAst.Me -> T.Me
    | SourceAst.And -> T.And
    | SourceAst.Or -> T.Or

  and erase_binop b e1 e2 =
    match e1.S.annot, e2.S.annot with
      TypStruct s1, TypStruct s2 when s1 = s2 && b = SourceAst.EqStruct ->
      mk_struct_compare e1 e2
    | _ -> T.Binop(erase_op b, erase_expression e1, erase_expression e2)

  and mk_struct_compare e1 e2 =
    match e1.S.annot, e2.S.annot with
      TypStruct s1, TypStruct s2 when s1 = s2 ->
      let (field, _) = S.Symb_Tbl.find s1 p.S.structs in
      List.fold_left
        (fun acc (str, t) ->
           let access_1 = { S.annot = t; S.elt = (e1, str) } in
           let ne1 = { S.annot = t; S.elt = S.FieldAccess(access_1) } in
           let ne1 = { S.annot = t; S.elt = S.Location(ne1) } in
           let access_2 = { S.annot = t; S.elt = (e2, str) } in
           let ne2 = { S.annot = t; S.elt = S.FieldAccess(access_2) } in
           let ne2 = { S.annot = t; S.elt = S.Location(ne2) } in
           T.Binop(T.And, acc, mk_struct_compare ne1 ne2))
        (T.Literal(S.Bool true)) field
    | t1, t2 when t1 <> t2 -> T.Literal(S.Bool false)
    | _ -> T.Binop(T.Eq, erase_expression e1, erase_expression e2)

  (* faire egalité structurelle array *)
  and mk_array_compare e1 e2 =
    match e1.S.annot, e2.S.annot with
      _ -> ()

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

  and erase_identifier_info i = i.SourceAst.kind in

  let erase_fct_decl key infos acc =
    let locals = S.Symb_Tbl.fold
        (fun id info tbl ->
           T.Symb_Tbl.add id (erase_identifier_info info) tbl)
        infos.S.locals
        T.Symb_Tbl.empty
    in
    let ninfos = {
      T.formals = erase_formal infos.S.formals;
      T.locals = locals;
      T.code = erase_block infos.S.code
    }
    in
    let str = key in
    T.Symb_Tbl.add str ninfos acc
  in

  S.Symb_Tbl.fold erase_fct_decl p.S.functions T.Symb_Tbl.empty
