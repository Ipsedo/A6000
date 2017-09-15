(* Syntaxe abstraite de la représentation intermédiaire *)
(* Les expressions sont aplaties, dans un style 'code trois adresses' *)
(* Chaque instruction est associée à une étiquette, qui servira pour
   les analyses ultérieures du code (séances 3 et 4). *)

module Symb_Tbl = GotoAst.Symb_Tbl

type label           = GotoAst.label
type literal         = GotoAst.literal
type identifier_info = GotoAst.identifier_info
type binop           = GotoAst.binop
    
type main = {
  locals: identifier_info Symb_Tbl.t;
  code:   block;
}

and block = (label * instruction) list
and instruction =
  | Value    of identifier * value                 (* Chargement d'une valeur *)
  | Binop    of identifier * binop * value * value (* Opération binaire       *)
  | Print    of value                              (* Affichage               *)
  | Label    of label                              (* Point de saut           *)
  | Goto     of label                              (* Saut                    *)
  | CondGoto of value * label                      (* Saut conditionnel       *)
  | Comment  of string                             (* Commentaire             *)

and identifier = string (* Identifiant d'un registre virtuel *)
    
and value =
  | Literal    of literal    (* Valeur immédiate *)
  | Identifier of identifier (* Registre virtuel *)


open Printf
      
let rec print_block = function
  | []          -> "\n"
  | (l, i) :: b -> sprintf "%s: %s\n%s" l (print_instruction i) (print_block b)

and print_instruction = function
  | Value(dest, v)   -> sprintf "%s <- %s" dest (print_value v)
  | Binop(dest, op, v1, v2) -> sprintf "%s <- %s %s %s"
    dest (print_value v1) (SourceAst.print_binop op) (print_value v2)
  | Print(v)         -> sprintf "print(%s)" (print_value v)
  | Label(lab)       -> lab
  | Goto(lab)        -> sprintf "goto %s" lab
  | CondGoto(v, lab) -> sprintf "goto %s when %s" lab (print_value v)
  | Comment(c)       -> sprintf "# %s" c
    
and print_value = function
  | Literal(lit)   -> SourceAst.print_literal lit
  | Identifier(id) -> id
