(* Syntaxe abstraite non typée *)
(* Cette version est obtenu en retirant tous les indications de typage *)
module Symb_Tbl = SourceAst.Symb_Tbl

type identifier_kind = SourceAst.identifier_kind
type identifier_info = identifier_kind
type binop = SourceAst.binop
type block = instruction list
(* Il faut tout redéfinir car la position du lexème courant
   (pour erreur de type)
   était placée dans les types literal et location *)
and instruction =
  | Set   of location   * expression    (* Affectation *)
  | While of expression * block         (* Boucle      *)
  | If    of expression * block * block (* Branchement *)
  | Print of expression                 (* Affichage   *)

and expression =
  | Literal   of literal      (* Valeur immédiate   *)
  | Location  of location   (* Valeur en mémoire  *)
  | Binop     of binop * expression * expression (* Opération binaire  *)
and location =
  | Identifier of string
and literal =
  | Int  of int  (* Constante entière   *)
  | Bool of bool

(* Programme principal : une table de symboles et un bloc de code *)
type main = {
  locals: identifier_info Symb_Tbl.t;
  code:   block;
}
