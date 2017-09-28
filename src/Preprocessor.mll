{
  open Lexing

  module Macro_Tbl = Map.Make(String)

  let macros = ref Macro_Tbl.empty

}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let ident = ['a'-'z' '_'] (alpha | '_' | '\'' | digit)*

rule macro = parse
    | "#DEFINE <" (ident as m) "> <" ([^ '\n' ]* as t) ">\n"
      {
        macros := Macro_Tbl.add m t !macros;
        ""
      }
    | "#" (ident as m) { Macro_Tbl.find m !macros }
    | [' ' '\t' '\r' '\n']+ as tmp
      { tmp }
    | eof { "EOF" }
    | _ as c    { Char.escaped c }
