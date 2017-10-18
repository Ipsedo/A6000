(* Syntaxe abstraite "goto" *)
(* Cette syntaxe abstraite possède les mêmes expressions que la syntaxe
   abstraite non typée, mais abandonne les structures de contrôle. *)
module Symb_Tbl = UntypedAst.Symb_Tbl

type expression      = UntypedAst.expression
type location        = UntypedAst.location
type identifier_info = UntypedAst.identifier_info
type literal         = UntypedAst.literal
type binop           = UntypedAst.binop

type label = string

type block = instruction list
and instruction =
  | Set      of location * expression (* Affectation       *)
  | Print    of expression            (* Affichage         *)
  | Label    of label                 (* Point de saut     *)
  | Goto     of label                 (* Saut              *)
  | CondGoto of expression * label    (* Saut conditionnel *)
  | Comment  of string                (* Commentaire       *)

type function_info = {
  locals:  identifier_info Symb_Tbl.t;
  code:    block
}

type prog = (string * function_info) list    
