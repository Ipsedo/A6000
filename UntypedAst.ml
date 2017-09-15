(* Syntaxe abstraite non typée *)
(* Cette version est obtenu en retirant tous les indications de typage *)
module Symb_Tbl = SourceAst.Symb_Tbl

type identifier_kind = SourceAst.identifier_kind
type identifier_info = identifier_kind

type expression  = SourceAst.expression
type location    = SourceAst.location
type block       = SourceAst.block
type instruction = SourceAst.instruction
type literal     = SourceAst.literal
type binop       = SourceAst.binop
    
(* Programme principal : une table de symboles et un bloc de code *)
type main = {
  locals: identifier_info Symb_Tbl.t;
  code:   block;
}
