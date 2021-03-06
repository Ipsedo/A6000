open SourceAst

(* Rapports d'erreurs *)
exception Type_error of string
exception InvalidArray of string

let current_pos = ref Lexing.dummy_pos

let rec string_of_typ t = match t with
  | SourceAst.TypInteger -> "integer"
  | SourceAst.TypBoolean -> "boolean"
  | SourceAst.TypArray(t) -> Printf.sprintf "array of %s" (string_of_typ t)

let raise_type_exception t1 t2 = let needed = string_of_typ t1 in
  let actual = string_of_typ t2 in
  let start_p = !current_pos in
  let msg = Printf.sprintf
      "Wrong type, actual : %s, needed : %s at line %d, col %d"
      actual
      needed
      start_p.pos_lnum
      (start_p.pos_cnum - start_p.pos_bol)
  in
  raise (Type_error msg)

let raise_invalid_array_excepion msg =
  raise (InvalidArray msg)

(* comparetype: typ -> typ -> unit
   Lève une exception si les types diffèrent. *)
let comparetype t1 t2 =
  if t1 <> t2
  then raise_type_exception t1 t2

(* Vérification des types d'un programme *)
let typecheck_prog p =
  (* L'analyse de tout le programme se fait dans le contexte de la même
     table de symboles. On la définit ici puis on définit les fonctions
     d'analyse récursives dans ce contexte. *)
  let symb_tbl = ref Symb_Tbl.empty in

  (* [typecheck_block/instruction] vérifient le bon typage des instructions
     et lèvent une exception en cas de problème. *)
  (* typecheck_block: block -> unit *)
  let rec typecheck_block b = List.iter typecheck_instruction b

  (* typecheck_instruction: instruction -> unit *)
  and typecheck_instruction = function
    | Set(l, e) ->
      comparetype (type_location l) (type_expression e)
    | While(e, b) ->
      comparetype TypBoolean (type_expression e);
      typecheck_block b
    | If(e, b1, b2) ->
      comparetype TypBoolean (type_expression e);
      typecheck_block b1;
      typecheck_block b2;
    | ProcCall(c) ->
      let str, e = c in
      let infos = Symb_Tbl.find str p in
      List.iter2
        (fun (a, _) b -> comparetype a (type_expression b))
        infos.formals e

  (* [type_expression/literal/location] vérifient le bon typage des
     expressions et renvoient leur type. *)
  (* type_expression: expression -> typ *)
  and type_expression = function
    | NewArray(e, t) ->
      comparetype TypInteger (type_expression e);
      TypArray t
    | NewDirectArray(e) ->
      let aux l acc =
        match l with
          [] -> acc
        | elt::tl -> let typ = type_expression elt in
          List.fold_left
            (fun a ex -> comparetype (type_expression ex) typ; typ)
            acc e
      in
      TypArray (aux e TypInteger) (* default value *)
    | Literal lit  -> type_literal lit
    | Location loc -> type_location loc
    | Binop(op, e1, e2) ->
      let ty_op, ty_r = type_binop op in
      comparetype ty_op (type_expression e1);
      comparetype ty_op (type_expression e2);
      ty_r
    | FunCall(c) ->
      begin
        let str, e = c in
        let infos = Symb_Tbl.find str p in
        let _ = if str <> "arr_length" then
            List.iter2
              (fun (a, _) b -> comparetype a (type_expression b))
              infos.formals e
          else
            (* pseudo polymorphisme *)
            match e with
            | a::[] ->
              begin
                match type_expression a with
                  TypArray _ -> ()
                | _ ->
                  let msg = "Location is not an array !" in
                  raise_invalid_array_excepion msg
              end
            | _ -> failwith "No / Too much argument(s) for arr_length !"
        in
        match infos.return with
          Some t -> t
        | None -> failwith "No return type for function"
      end

  (* type_literal: literal -> typ *)
  and type_literal = function
    | Int (_, pos)  -> current_pos := pos; TypInteger
    | Bool (_, pos) -> current_pos := pos; TypBoolean

  (* type_location: location -> typ *)
  and type_location = function
    | Identifier(id, pos) -> current_pos := pos;
      (Symb_Tbl.find id !symb_tbl).typ
    | ArrayAccess(e1, e2, pos) -> current_pos := pos;
      comparetype TypInteger (type_expression e2);
      let loc =
        match e1 with
          Location i -> i
        | _ ->
          let msg = "Array expression must be : location (of exression)+ !" in
          raise_invalid_array_excepion msg

      in
      match type_location loc with
        TypArray t -> t
      | _ ->
        let msg = "Location is not an array !" in
        raise_invalid_array_excepion msg

  (* [type_binop] renvoie le type des opérandes et le type du résultat
     d'un opérateur binaire. *)
  (* type_binop: binop -> typ * typ *)
  and type_binop = function
    | Add | Sub | Mult | Div     -> TypInteger, TypInteger
    | Eq  | Neq | Lt  | Le | Me | Mt -> TypInteger, TypBoolean
    | And | Or             -> TypBoolean, TypBoolean

  in

  Symb_Tbl.iter
    (fun id fct-> symb_tbl := fct.locals; typecheck_block fct.code)
    p
