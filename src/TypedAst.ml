module Symb_Tbl = SourceAst.Symb_Tbl

type literal         = SourceAst.literal
type binop           = SourceAst.binop
type typ             = SourceAst.typ
type identifier_info = SourceAst.identifier_info
type struct_info     = SourceAst.struct_info

type ('a, 'e) annotated_element = { annot: 'a ; elt: 'e }

type typed_expression = (typ, expression) annotated_element
and typed_location    = (typ, location) annotated_element
and typed_call        = ((typ option), call) annotated_element
and typed_f_access    = (typ, f_access) annotated_element
and call = string * typed_expression list
and f_access = typed_expression * string
and expression =
  | Literal   of literal      (* Valeur immédiate   *)
  | Location  of typed_location   (* Valeur en mémoire  *)
  | Binop     of binop * typed_expression * typed_expression (* Opération binaire  *)
  | FunCall   of typed_call
  | NewArray  of typed_expression * typ
  | NewDirectArray of typed_expression list
  | NewRecord of string

and instruction =
  | Set   of typed_location * typed_expression    (* Affectation *)
  | While of typed_expression * block         (* Boucle      *)
  | If    of typed_expression * block * block (* Branchement *)
  | ProcCall of typed_call

and location =
  | Identifier of string * Lexing.position (* Variable en mémoire *)
  | ArrayAccess of typed_expression * typed_expression * Lexing.position
  | FieldAccess of typed_f_access * Lexing.position


and block = instruction list

and prog = {
  functions: function_info list Symb_Tbl.t;
  structs:   struct_info Symb_Tbl.t
}

and function_info = {
  return:  typ option;
  (* On aura besoin de la liste des identifiants des formels
      pour l'affectation des formels *)
  formals: (typ * string) list;
  locals:  identifier_info Symb_Tbl.t;
  code:    block
}
