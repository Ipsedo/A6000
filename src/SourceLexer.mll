{

open Lexing
open SourceParser

exception UnknowChar of string
exception UnknowToken of string

let id_or_keyword =
  let h = Hashtbl.create 17 in
  List.iter (fun (s, k) -> Hashtbl.add h s k)
    [	"integer",  INT;
      "var",      VAR;
      "boolean",  BOOL;
      "true",     LITBOOL(true);
      "false",    LITBOOL(false);
      "while",    WHILE;
      "if",       IF;
      "then",     THEN;
      "else",     ELSE;
      "for",      FOR;
      "struct",   STRUCT;
      "new",      NEW;
      "extends",  EXTENDS
    ] ;
  fun s ->
    try  Hashtbl.find h s
    with Not_found -> IDENT(s)


}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let ident = (['a'-'z' '_'] (alpha | '_' | '\'' | digit)*)

rule token = parse
  | [' ' '\t' '\r']+
    { token lexbuf }
  | '\n'
    { new_line lexbuf; token lexbuf }
  | ident
    { id_or_keyword (lexeme lexbuf) }
  | digit+
    { LITINT (int_of_string (lexeme lexbuf))}
  | "("
    { BEGIN }
  | ")"
    { END }
  | "["
    { O_BRACKETS }
  | "]"
    { C_BRACKETS }
  | "{"
    { O_BRACE }
  | "}"
    { C_BRACE }
  | "."
    { DOT }
  | ";"
    { SEMI }
  | ","
    { COMMA }
  | "+"
    { PLUS }
  | "*"
    { MULT }
  | "-"
    { SUB }
  | "="
    { EQ_STR }
  | "=="
    { EQ }
  | "!="
    { NEQ }
  | "<"
    { LT }
  | "<="
    { LE }
  | ">"
    { MT }
  | ">="
    { ME }
  | "&&"
    { AND }
  | "||"
    { OR }
  | ":="
    { SET }
  | "++"
    { INCR }
  | "--"
    { DECR }
  | "/"
    { DIV }
  | "+="
    { ADDSET }
  | "-="
    { SUBSET }
  | "*="
    { MULTSET }
  | "/="
    { DIVSET }
  | eof
    { EOF }
  | _
    {
      let start_p = lexeme_start_p lexbuf in
      let msg = Printf.sprintf
        "Unknow char(s) \"%s\" in %s at line %d, col %d"
        (lexeme lexbuf)
        start_p.pos_fname
        start_p.pos_lnum
        (start_p.pos_cnum - start_p.pos_bol)
      in
      raise (UnknowChar (msg))
    }

and comment = parse
            | "(*"
                { comment lexbuf; comment lexbuf }
            | "*)"
                { () }
            | _
                { comment lexbuf }
            | eof
                { failwith "Unterminated comment" }
