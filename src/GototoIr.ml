(* Traduction de la syntaxe abstraite "goto"
   vers la représentation intermédiaire. *)
module S = GotoAst
module T = IrAst


let flatten_prog p =

  (* On extrait la table des symboles de notre programme, qui sera étendue
     avec les registres virtuels créés à la volée. *)
  (*let rec aux p acc =
    match p with
    | [] -> acc
    | (str, fct)::tl ->*)
  let symb_tbl = ref S.Symb_Tbl.empty in

  (* Ajout à la table des symboles d'un nouveau registre virtuel *)
  let add_symb s =
    symb_tbl := T.Symb_Tbl.add s (Local: T.identifier_info) !symb_tbl;
  in

  (* new_tmp: unit -> string *)
  (* Un appel [new_tmp()] crée un nouvel identifiant de registre virtuel
     et l'ajoute à la table des symboles. *)
  (* On ajoute un argument qui donne l'index du registre temporel à utiliser *)
  let new_tmp nb =
    let tmp = Printf.sprintf "_tmp_%i" nb in
    add_symb tmp;
    tmp
  in

  (* flatten_block: S.block -> T.instruction list *)
  let rec flatten_block = function
    | []   -> []
    | i::b -> flatten_instruction i @ (flatten_block b)

  (* flatten_instruction: S.instruction -> T.instruction list *)
  and flatten_instruction = function
    | S.Goto(l) -> [ T.Goto(l) ]
    | S.CondGoto(c, l) ->
      let ce, ve = flatten_expression 0 c in
      ce @ [ T.CondGoto(ve, l) ]
    | S.Label(l) -> [ T.Label(l) ]
    | S.Set(loc, e) ->
      begin
        match loc with
          Identifier(id) ->
          let ce, ve = flatten_expression 0 e in
          ce @ [ T.Value(id, ve) ]
        | ArrayAccess(str, index) -> let ce1, ve1 = flatten_expression 0 index in
          let ce2, ve2 = flatten_expression 0 e in
          ce2 @ ce1 @ [ T.Store((Identifier str, ve1), ve2)]
      end
    | S.Comment(str) -> [ T.Comment(str) ]
    | S.ProcCall(c) -> let (str, args) = c in
      let tmp_cpt = ref 0 in
      let (es, vs) = List.fold_left
          (fun (ce_acc, ve_acc) expr ->
             let (ce, ve) = flatten_expression !tmp_cpt expr in
             incr tmp_cpt;
             ce_acc@ce, ve_acc@[ve])
          ([], []) args in
      es @ [ T.ProcCall(str, vs) ]

  (* flatten_expression: S.expression -> T.instruction list -> T.value *)
  (* Appliquée à une expression, [flatten_expression] renvoie une liste
     d'instructions calculant le résultat de cette expression, ainsi qu'une
     valeur contenant ce résultat.
     Cas représentatifs :
     - l'expression est déjà une valeur, la liste d'instructions sera vide
       et l'expression sera retournée elle-même ;
     - l'expression est composée, et la valeur sera l'identifiant du registre
       virtuel dans lequel a été placé le résultat.
  *)
  and flatten_expression nb : S.expression -> T.instruction list * T.value =
    function
    | NewArray e ->
      let ce, ve = flatten_expression nb e in
      let id_tmp = new_tmp nb in
      ce @ [ T.New(id_tmp, ve) ], T.Identifier(id_tmp)
    | Location(ArrayAccess(str, e)) ->
      let ce, ve = flatten_expression nb e in
      let id_tmp = new_tmp nb in
      ce @ [ T.Load(id_tmp, (T.Identifier str, ve)) ], T.Identifier(id_tmp)
    | Location(Identifier id) -> [], T.Identifier(id)
    | Literal (l) -> [], T.Literal(l)
    | Binop(b, e1, e2) -> let ce1, ve1 = flatten_expression nb e1 in
      let ce2, ve2 = flatten_expression (nb + 1) e2 in
      let id_tmp = new_tmp nb in
      ce1 @ ce2 @ [ T.Binop(id_tmp, b, ve1, ve2) ], T.Identifier(id_tmp)
    | FunCall(c) -> let (str, args) = c in
      let tmp_cpt = ref nb in
      let (es, vs) = List.fold_left
          (fun (ce_acc, ve_acc) expr ->
             let (ce, ve) = flatten_expression !tmp_cpt expr in
             incr tmp_cpt;
             ce_acc @ ce, ve_acc @ [ve])
          ([], []) args in
      let id_tmp = new_tmp nb in
      es @ [ T.FunCall(id_tmp, str, vs) ], T.Identifier(id_tmp)
    | NewDirectArray(e, es) ->
      let ce, ve = flatten_expression nb e in
      let id_tmp = new_tmp nb in
      let tmp_nb = ref nb in
      let es, vs = List.fold_left
          (fun (es_acc, vs_acc) elt ->
             incr tmp_nb;
             let tmp_ce, tmp_ve = flatten_expression !tmp_nb elt in
             (es_acc @ tmp_ce, vs_acc @ [tmp_ve]))
          ([], []) es
      in
      let _, sets = List.fold_left
          (fun (index, acc) v ->
             (index + 1, T.Store((T.Identifier id_tmp, T.Literal(Int(index))), v)::acc))
          (0, []) vs
      in
      ce @ [ T.New(id_tmp, ve) ] @ es @ sets, T.Identifier(id_tmp)
  in

  (* label_instruction: T.instruction -> T.label * T.instruction *)
  (* Un appel [label_instruction i] crée une nouvelle étiquette pour
     identifier l'instruction [i], si celle-ci n'est pas déjà une étiquette
     de saut. *)

  let fct_name = ref "" in
  let cpt_label = ref 0 in
  let label_instruction =
    fun i -> let lab = Printf.sprintf "_%s_%d" !fct_name !cpt_label in
      incr cpt_label;
      match i with
      (* On force une correspondance entre étiquette de saut
         et étiquette d'analyse. *)
      | T.Label l -> l, i
      | _         -> lab, i
  in
  S.Symb_Tbl.fold
    (fun id infos acc ->
       symb_tbl := infos.S.locals;
       fct_name := id;
       cpt_label := 0;
       let flattened_code = flatten_block infos.S.code in
       T.Symb_Tbl.add id
         { T.formals = infos.S.formals;
           T.locals = !symb_tbl;
           T.code = List.map label_instruction flattened_code }
         acc)
    p T.Symb_Tbl.empty
