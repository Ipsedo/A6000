module S = SourceAst
module T = TypedAst

let rec string_of_typ t = match t with
  | S.TypInteger -> "integer"
  | S.TypBoolean -> "boolean"
  | S.TypArray(t) -> Printf.sprintf "array of %s" (string_of_typ t)

(* Rapports d'erreurs *)
exception Type_error of string
exception InvalidArray of string

let current_pos = ref Lexing.dummy_pos

let raise_type_exception t1 t2 =
  let pos = !current_pos in
  let needed = string_of_typ t1 in
  let actual = string_of_typ t2 in
  let msg = Printf.sprintf
      "Wrong type, actual : %s, needed : %s at line %d, col %d"
      actual
      needed
      pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol)
  in
  raise (Type_error msg)

let raise_invalid_array_excepion msg =
  raise (InvalidArray msg)

(* comparetype: typ -> typ -> unit
   Lève une exception si les types diffèrent. *)
let comparetype t1 t2=
  if t1 <> t2
  then raise_type_exception t1 t2

(* Vérification des types d'un programme *)

let type_prog p =

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

  and mk_typed_call c symb_tbl =
    let str, es = c in
    let infos = S.Symb_Tbl.find str p in
    let mk_check_args acc elt (a, _) =
      let ne, ty = type_expression elt symb_tbl in
      let _ = if str <> "arr_length" then
          comparetype a ty
        else
          match ty with
            TypArray _ -> ()
          | _ -> let msg = "Not an array (function : integer arr_length) !" in
            raise (raise_invalid_array_excepion msg)
      in
      acc @ [ne]
    in
    let nes = List.fold_left2 mk_check_args [] es infos.S.formals in
    { T.annot = infos.S.return; T.elt = (str, nes) }

  (* location -> S.Symb_tbl.t -> typed_location * S.typ *)
  and type_location l symb_tbl =
    match l with
      S.Identifier(str, pos) ->
      current_pos := pos;
      let l_type = (S.Symb_Tbl.find str symb_tbl).S.typ in
      { T.annot = l_type; T.elt = T.Identifier(str, pos) }, l_type
    | S.ArrayAccess(e1, e2, pos) -> type_array e1 e2 pos symb_tbl

  and type_array e1 e2 pos symb_tbl =
    current_pos := pos;
    let ne2, t2 = type_expression e2 symb_tbl in
    comparetype TypInteger t2;
    let ne1, t1 = type_expression e1 symb_tbl in
    let res_type = match t1 with
        TypArray t -> t
      | _ -> let msg = "Location is not an array !" in
        raise_invalid_array_excepion msg
    in
    { T.annot = res_type; T.elt = T.ArrayAccess(ne1, ne2, pos) }, res_type

  and type_literal i =
    match i with
    | S.Int (i, pos)  -> current_pos := pos;
      SourceAst.Int(i, pos), SourceAst.TypInteger
    | S.Bool (b, pos) -> current_pos := pos;
      SourceAst.Bool(b, pos), SourceAst.TypBoolean

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
             nacc @ [ne], tacc @ [te]) ([], []) e in
      let rec aux l =
        match l with
          [] -> ()
        | a::tl -> List.iter (comparetype a) tl;
          aux tl
      in aux tes;
      let t = match tes with
          [] -> failwith "empty direct tab can't be created"
        | a::_ -> a
      in
      { T.annot = TypArray t; T.elt = T.NewDirectArray(nes) }, TypArray t
    | S.Literal lit  -> let nl, tl = type_literal lit in
      { T.annot = tl; T.elt = T.Literal(nl) }, tl
    | S.Location loc -> let nl, tl = type_location loc symb_tbl in
      { T.annot = tl; T.elt = T.Location(nl) }, tl
    | Binop(op, e1, e2) ->
      let ty_op, ty_r = type_binop op in
      let ne1, ty1 = type_expression e1 symb_tbl in
      let ne2, ty2 = type_expression e2 symb_tbl in
      comparetype ty_op ty1;
      comparetype ty_op ty2;
      { T.annot = ty_r; T.elt = T.Binop(op, ne1, ne2) }, ty_r
    | FunCall(c) -> let fc, ty = type_fct c symb_tbl in
      { T.annot = ty; T.elt = T.FunCall(fc) }, ty

  and type_fct c symb_tbl =
    let str, _ = c in
    let res = match (S.Symb_Tbl.find str p).return with
        Some t -> t
      | None -> failwith "No return type for focntion !"
    in
    mk_typed_call c symb_tbl, res

  and type_binop = function
    | Add | Sub | Mult | Div          -> TypInteger, TypInteger
    | Eq  | Neq | Lt   | Le | Me | Mt -> TypInteger, TypBoolean
    | And | Or                        -> TypBoolean, TypBoolean

  and type_fun_decls id infos acc  =
    T.Symb_Tbl.add id { T.return = infos.S.return;
                        T.formals = infos.S.formals;
                        T.locals = infos.S.locals;
                        T.code = typecheck_block infos.S.code infos.S.locals}
      acc

  in
  S.Symb_Tbl.fold type_fun_decls p T.Symb_Tbl.empty
