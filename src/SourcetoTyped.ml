module S = SourceAst
module T = TypedAst

let rec string_of_typ t = match t with
  | S.TypStruct s -> "struct " ^ s ^ " { ... }"
  | S.TypInteger -> "integer"
  | S.TypBoolean -> "boolean"
  | S.TypArray(t) -> Printf.sprintf "array of %s" (string_of_typ t)

let rec string_of_typ2 t = match t with
  | S.TypStruct s -> "struct_" ^ s
  | S.TypInteger -> "integer"
  | S.TypBoolean -> "boolean"
  | S.TypArray(t) -> Printf.sprintf "array_of_%s" (string_of_typ2 t)

(* Rapports d'erreurs *)
exception Type_error of string
exception InvalidArray of string
exception FunctionError of string
exception StructError of string
exception SymbolError of string

let current_pos = ref Lexing.dummy_pos

let raise_type_exception t1 t2 =
  let pos = !current_pos in
  let needed = string_of_typ t1 in
  let actual = string_of_typ t2 in
  let msg = Printf.sprintf
      "Wrong type, actual : %s, needed : %s at line %d, col %d !"
      actual
      needed
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (Type_error msg)

let raise_no_symbol_found str =
  let pos = !current_pos in
  let msg = Printf.sprintf
      "No symbol \"%s\" found at line %d, col %d !"
      str
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (SymbolError msg)

let raise_incorrect_struct t =
  let pos = !current_pos in
  let msg = Printf.sprintf
      "%s is not type struct at line %d, col %d !"
      (string_of_typ t)
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (StructError msg)

let raise_incorrect_array t =
  let pos = !current_pos in
  let msg = Printf.sprintf
      "%s is not an array at line %d, col %d !"
      (string_of_typ t)
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (InvalidArray msg)

let raise_empty_direct_tab () =
  let pos = !current_pos in
  let msg = Printf.sprintf
      "Empty direct tab can't be created at line %d, col %d"
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (InvalidArray msg)

let raise_no_function_return () =
  let pos = !current_pos in
  let msg = Printf.sprintf
      "No return type for fonction at line %d, col %d"
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (FunctionError msg)

let find_struct str symb_tbl =
  let struct_fields = S.Symb_Tbl.find_opt str symb_tbl in
  match struct_fields with
  | Some s -> s
  | None -> let pos = !current_pos in
    let msg = Printf.sprintf
        "No struct found at line %d, col %d !"
        pos.pos_lnum
        (pos.pos_cnum - pos.pos_bol)
    in
    raise (StructError msg)

let raise_no_function_found_exception () =
  let pos = !current_pos in
  let msg = Printf.sprintf
      "No function / procedure found at line %d, col %d !"
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (FunctionError msg)

(* Vérification des types d'un programme *)

let type_prog p =

  (* comparetype: typ -> typ -> unit
     Lève une exception si les types diffèrent. *)
  let comparetype t1 t2 =
    let rec find_compatibility needed curr =
      let (_,found) = find_struct curr p.S.structs in
      match found with
      | None -> raise_type_exception t1 t2
      | Some s -> if needed <> s then find_compatibility needed s
    in
    match t1, t2 with
      S.TypStruct s1, S.TypStruct s2 ->
      if s1 = s2 then () else find_compatibility s1 s2
    | t1, t2 ->
      if t1 <> t2
      then raise_type_exception t1 t2
  in

  let rec typecheck_block b symb_tbl =
    List.map (typecheck_instruction symb_tbl) b

  (* typecheck_instruction: S.Symb_Tbl.t -> S.instruction -> T.instruction *)
  and typecheck_instruction symb_tbl i =
    match i with
    | S.Set(l, e) ->
      let nl, tyl = type_location l symb_tbl in
      let ne, tye = type_expression e symb_tbl in
      comparetype tyl tye;
      T.Set(nl, ne)
    | S.While(e, b) ->
      let ne, tye = type_expression e symb_tbl in
      comparetype TypBoolean tye;
      let nb = typecheck_block b symb_tbl in
      T.While(ne, nb)
    | S.If(e, b1, b2) ->
      let ne, tye = type_expression e symb_tbl in
      comparetype TypBoolean tye;
      let nb1 = typecheck_block b1 symb_tbl in
      let nb2 = typecheck_block b2 symb_tbl in
      T.If(ne, nb1, nb2)
    | S.ProcCall(c) -> T.ProcCall(mk_typed_call c symb_tbl)

  and find_fct_with_call ty_expr info_l =
    let check_types tys ty_exprs =
      if (List.length tys) = (List.length ty_expr) then begin
        List.iter2 (fun (ty,_) ty_e -> comparetype ty ty_e) tys ty_exprs;
        true end
      else false
    in
    let rec finder l acc =
      match l with
        [] -> acc
      | i::tl ->
        try
          if check_types i.S.formals ty_expr then Some i
          else finder tl acc
        with Type_error _ -> finder tl acc
    in
    let info = finder info_l None in
    match info with
    | Some s -> s
    | None -> raise_no_function_found_exception ()

  and rename_fct str formals =
    List.fold_left
      (fun acc (t, _) -> acc ^ "_" ^ (string_of_typ2 t))
      str formals

  and mk_typed_call c symb_tbl =
    let str, es = c in
    let tmp = List.map (fun elt -> type_expression elt symb_tbl) es in
    let (es, tys) = List.fold_left
        (fun (e_acc, t_acc) (e, t) -> e_acc @ [e], t_acc @ [t])
        ([], []) tmp
    in
    let infos_l = S.Symb_Tbl.find_opt str p.S.functions in
    let infos_l = match infos_l with
      | Some s -> s
      | None -> raise_no_function_found_exception ()
    in
    let infos = find_fct_with_call tys infos_l in
    let str = rename_fct str infos.S.formals in
    { T.annot = infos.S.return; T.elt = (str, es) }

  (* location -> S.Symb_tbl.t -> typed_location * S.typ *)
  and type_location l symb_tbl =
    match l with
      S.Identifier(str, pos) ->
      current_pos := pos;
      let l_type = S.Symb_Tbl.find_opt str symb_tbl in
      let l_type = match l_type with
        | Some s -> s
        | None -> raise_no_symbol_found str
      in
      let l_type = l_type.S.typ in
      { T.annot = l_type; T.elt = T.Identifier(str) }, l_type
    | S.ArrayAccess(e1, e2, pos) -> current_pos := pos;
      type_array e1 e2 symb_tbl
    | S.FieldAccess(f_a, pos) -> current_pos := pos;
      let t_f_access, t = mk_field_access f_a symb_tbl in
      { T.annot = t; T.elt = T.FieldAccess(t_f_access) }, t

  and mk_field_access (e, str) symb_tbl =
    let e, t = type_expression e symb_tbl in
    let struct_name =
      match t with
        TypStruct s -> s
      | t -> raise_incorrect_struct t
    in
    let struct_fields, _ = find_struct struct_name p.S.structs in
    let f_t = List.assoc str struct_fields in
    { T.annot = f_t; T.elt = (e, str)}, f_t


  and type_array e1 e2 symb_tbl =
    let ne2, t2 = type_expression e2 symb_tbl in
    comparetype TypInteger t2;
    let ne1, t1 = type_expression e1 symb_tbl in
    let res_type = match t1 with
        TypArray t -> t
      | t -> raise_incorrect_array t
    in
    { T.annot = res_type; T.elt = T.ArrayAccess(ne1, ne2) }, res_type

  and type_literal i =
    match i with
    | S.Int (i, pos)  -> current_pos := pos;
      T.Int(i), SourceAst.TypInteger
    | S.Bool (b, pos) -> current_pos := pos;
      T.Bool(b), SourceAst.TypBoolean

  and type_expression expr symb_tbl =
    match expr with
    | S.NewArray(e, t) ->
      let ne, te = type_expression e symb_tbl in
      comparetype TypInteger te;
      { T.annot = TypArray t; T.elt = T.NewArray(ne, t) },
      TypArray t
    | S.NewDirectArray(e) ->
      let nes, tes = List.fold_left
          (fun (nacc, tacc) elt ->
             let ne, te = type_expression elt symb_tbl in
             nacc @ [ne], tacc @ [te]) ([], []) e
      in
      let rec aux l =
        match l with
          [] -> ()
        | a::tl -> List.iter (comparetype a) tl;
          aux tl
      in aux tes;
      let t = match tes with
          [] -> raise_empty_direct_tab ()
        | a::_ -> a
      in
      { T.annot = TypArray t; T.elt = T.NewDirectArray(nes) }, TypArray t
    | S.NewRecord(str) ->
      let _ = find_struct str p.S.structs in
      { T.annot = TypStruct str; T.elt = T.NewRecord(str) }, TypStruct str
    | S.Literal lit  -> let nl, tl = type_literal lit in
      { T.annot = tl; T.elt = T.Literal(nl) }, tl
    | S.Location loc -> let nl, tl = type_location loc symb_tbl in
      { T.annot = tl; T.elt = T.Location(nl) }, tl
    | Binop(op, e1, e2) ->
      let ne1, ty1 = type_expression e1 symb_tbl in
      let ne2, ty2 = type_expression e2 symb_tbl in
      let (ty_op1, ty_op2), ty_r = type_binop op ty1 ty2 in
      comparetype ty_op1 ty1;
      comparetype ty_op2 ty2;
      { T.annot = ty_r; T.elt = T.Binop(op, ne1, ne2) }, ty_r
    | FunCall(c) -> let fc, ty = type_fct c symb_tbl in
      { T.annot = ty; T.elt = T.FunCall(fc) }, ty

  and type_fct c symb_tbl =
    let typed_call = mk_typed_call c symb_tbl in
    match typed_call.annot with
    | Some t -> typed_call, t
    | None -> raise_no_function_return ()

  (* faire autorisation eq structurelle array *)
  and type_binop b t1 t2 =
    match b with
      EqStruct | Eq | Neq -> begin
        match t1, t2 with
          TypStruct s1, TypStruct s2 ->
          (TypStruct s1, TypStruct s2), TypBoolean
        | TypStruct s, t -> (TypStruct s, t), TypBoolean
        | t, TypStruct s -> (t, TypStruct s), TypBoolean
        | _ -> type_binop_simple b
      end
    | _ -> type_binop_simple b

  and type_binop_simple = function
    | Add | Sub | Mult | Div                   ->
      (TypInteger, TypInteger), TypInteger
    | Eq  | Neq | Lt | Le | Me | Mt | EqStruct ->
      (TypInteger, TypInteger), TypBoolean
    | And | Or                                 ->
      (TypBoolean,TypBoolean), TypBoolean

  and type_fun_decls id fct_list acc =
    let aux acc infos =
      let ninfos =
        { T.return = infos.S.return;
          T.formals = infos.S.formals;
          T.locals = infos.S.locals;
          T.code = typecheck_block infos.S.code infos.S.locals }
      in
      let str = rename_fct id infos.S.formals in
      T.Symb_Tbl.add str ninfos acc
    in
    List.fold_left aux acc fct_list
  in

  {
    T.functions = S.Symb_Tbl.fold type_fun_decls p.S.functions T.Symb_Tbl.empty;
    T.structs = p.S.structs
  }
