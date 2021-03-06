(* Transformation de la syntaxe abstraite non typée
   vers la syntaxe abstraite "goto". *)
module S = UntypedAst
module T = GotoAst

let destructure_prog p =

  (* new_label: unit -> string *)
  (* Un appel [new_label()] crée une nouvelle étiquette qui peut être
     utilisée pour créer des sauts. *)

  (* Besoin de ces deux ref pour la création de label *)
  let fct_name = ref "" in

  let cpt_label = ref 0 in

  let new_label =
    fun () -> incr cpt_label;
      Printf.sprintf "_label_%s_%i" !fct_name !cpt_label
  in

  (* destructure_block: S.block -> T.block *)
  let rec destructure_block = function
    | []     -> []
    | i :: b -> destructure_instruction i @ (destructure_block b)

  (* destructure_instruction: S.instruction -> T.block *)
  and destructure_instruction : S.instruction -> T.block = function
    | S.ProcCall(c) -> [ T.ProcCall(c) ]
    | S.While(c, b) -> let loop_text = new_label () in
      let loop_code = new_label () in
      [ T.Goto(loop_text);
        T.Label(loop_code) ]
      @ (destructure_block b)
      @ [ T.Label(loop_text);
          T.CondGoto(c, loop_code) ]
    | S.Set(l, e) -> [ T.Set(l, e) ]
    | S.If(c, b1, b2) -> let label_then = new_label () in
      let label_else = new_label () in
      [ T.CondGoto(c, label_then) ]
      @ (destructure_block b2)
      @ [ T.Goto(label_else);
          T.Label(label_then) ]
      @ (destructure_block b1)
      @ [ T.Label(label_else) ]
  in

  S.Symb_Tbl.fold
    (fun id infos acc ->
       fct_name := id;
       cpt_label := 0;
       T.Symb_Tbl.add id
         { T.formals = infos.S.formals;
           T.locals = infos.S.locals;
           T.code = destructure_block infos.S.code }
         acc)
    p T.Symb_Tbl.empty
