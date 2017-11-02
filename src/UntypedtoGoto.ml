(* Transformation de la syntaxe abstraite non typée
   vers la syntaxe abstraite "goto". *)
module S = UntypedAst
module T = GotoAst

let destructure_prog p =

  (* new_label: unit -> string *)
  (* Un appel [new_label()] crée une nouvelle étiquette qui peut être
     utilisée pour créer des sauts. *)
  (*let rec aux p acc = match p with
      [] -> acc
    | (str, fct)::tl -> *)

  let new_label =
    let cpt = ref 0 in
    fun () -> incr cpt; Printf.sprintf "_label_%i" !cpt
  in

  (* destructure_block: S.block -> T.block *)
  let rec destructure_block = function
    | []     -> []
    | i :: b -> destructure_instruction i @ (destructure_block b)

  (* destructure_instruction: S.instruction -> T.block *)
  and destructure_instruction : S.instruction -> T.block = function
    | S.Print(e) -> [ T.Print(e)  ]
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
       T.Symb_Tbl.add id
         { T.locals = infos.S.locals; T.code = destructure_block infos.S.code }
         acc)
    p T.Symb_Tbl.empty



(*aux tl ((str,{ T.locals = fct.S.locals; T.code = destructure_block fct.S.code })::acc))
  in aux p []*)
