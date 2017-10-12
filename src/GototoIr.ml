(* Traduction de la syntaxe abstraite "goto"
   vers la représentation intermédiaire. *)
module S = GotoAst
module T = IrAst


let flatten_main p =

  (* On extrait la table des symboles de notre programme, qui sera étendue
     avec les registres virtuels créés à la volée. *)
  let symb_tbl = ref p.S.locals in

  (* Ajout à la table des symboles d'un nouveau registre virtuel *)
  let add_symb s =
    symb_tbl := T.Symb_Tbl.add s (Local: T.identifier_info) !symb_tbl;
  in

  let reinit_tmp = ref true in

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
    | S.Print(e) ->
      let ce, ve = flatten_expression 0 e in
      ce @ [ T.Print(ve) ]
    | S.Goto(l) -> [ T.Goto(l) ]
    | S.CondGoto(c, l) ->
      let ce, ve = flatten_expression 0 c in
      ce @ [ T.CondGoto(ve, l) ]
    | S.Label(l) -> [ T.Label(l) ]
    | S.Set(loc, e) -> (match loc with
          Identifier(id) ->
          let ce, ve = flatten_expression 0 e in
          ce @ [ T.Value(id, ve) ])
    | S.Comment(str) -> [ T.Comment(str) ]

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
    | Location(Identifier id) -> [], T.Identifier(id)
    | Literal (l) -> [], T.Literal(l)
    | Binop(b, e1, e2) -> let ce1, ve1 = flatten_expression nb e1 in
      let ce2, ve2 = flatten_expression (nb + 1) e2 in
      let id_tmp = new_tmp nb in
      ce1 @ ce2 @ [ T.Binop(id_tmp, b, ve1, ve2) ], T.Identifier(id_tmp)
  in

  (* label_instruction: T.instruction -> T.label * T.instruction *)
  (* Un appel [label_instruction i] crée une nouvelle étiquette pour
     identifier l'instruction [i], si celle-ci n'est pas déjà une étiquette
     de saut. *)
  let label_instruction =
    let cpt = ref 0 in
    fun i -> let lab = Printf.sprintf "_main_%d" !cpt in
      incr cpt;
      match i with
      (* On force une correspondance entre étiquette de saut
         		  et étiquette d'analyse. *)
      | T.Label l -> l, i
      | _         -> lab, i
  in

  let flattened_code = flatten_block p.S.code in
  { T.locals = !symb_tbl; T.code = List.map label_instruction flattened_code }
