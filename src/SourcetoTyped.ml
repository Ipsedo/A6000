module S = SourceAst
module T = TypedAst

let rec string_of_typ t = match t with
  | S.TypInteger -> "integer"
  | S.TypBoolean -> "boolean"
  | S.TypArray(t) -> Printf.sprintf "array of %s" (string_of_typ t)

(* Rapports d'erreurs *)
exception Type_error of string
exception InvalidArray of string

let raise_type_exception t1 t2 (pos : Lexing.position) = let needed = string_of_typ t1 in
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
let comparetype t1 t2 pos =
  if t1 <> t2
  then raise_type_exception t1 t2 pos

(* Vérification des types d'un programme *)

(* location -> S.Symb_tbl.t -> typed_location * S.typ *)
let rec type_location l symb_tbl =
  match l with
    S.Identifier(str, pos) ->
    let l_type = (S.Symb_Tbl.find str symb_tbl).S.typ in
    {T.annot = l_type; T.elt = SourceAst.Identifier(str, pos)}, l_type
  | ArrayAccess(e1, e2, pos) -> type_array e1 e2 pos symb_tbl

and type_array e1 e2 pos symb_tbl =
  let ne2, t2 = type_expression e2 symb_tbl in
  comparetype TypInteger t2 pos;
  let ne1, t1 = type_expression e1 symb_tbl in
  let res_type = match t1 with
      TypArray t -> t
    | _ -> let msg = "Location is not an array !" in
      raise_invalid_array_excepion msg
  in
  {T.annot = res_type; T.elt = SourceAst.ArrayAccess(e1, e2, pos)}, res_type

and type_expression expr symb_tbl =
  match expr with
  | S.NewArray(e, t) ->
    let ne, te = type_expression e symb_tbl in
    comparetype SourceAst.TypInteger te Lexing.dummy_pos;
    { T.annot = SourceAst.TypArray t; T.elt = T.NewArray(ne, t) }, SourceAst.TypArray t
  | NewDirectArray(e) ->
    (*let aux l acc =
      match l with
        [] -> acc
      | elt::tl -> let typ = type_expression elt in
        List.fold_left
          (fun a ex -> comparetype (type_expression ex) typ; typ)
          acc e
    in*)
    let nes, tes = List.fold_left
      (fun (nacc, tacc) elt -> let ne, te = type_expression elt symb_tbl in
        nacc@[ne], tacc@[te]) ([], []) e in
    let rec aux l =
      match l with
       [] -> ()
      | a::tl -> List.iter (fun elt -> comparetype a elt Lexing.dummy_pos) tl;
        aux tl
    in aux tes;
    let t::_ = tes in
    { T.annot = TypArray t; T.elt = T.NewDirectArray(nes) }, TypArray t
  | _ -> failwith "pas implémentée"
