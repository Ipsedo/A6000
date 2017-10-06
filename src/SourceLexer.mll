{

open Lexing
open SourceParser

exception UnknowChar of string
exception UnknowToken of string

let id_or_keyword =
  let h = Hashtbl.create 17 in
  List.iter (fun (s, k) -> Hashtbl.add h s k)
    [	"integer",  INT;
      "print",    PRINT;
      "main",     MAIN;
      "var",      VAR;
      "boolean",  BOOL;
      "true",     LITBOOL(true);
      "false",    LITBOOL(false);
      "while",    WHILE;
      "if",       IF;
      "then",     THEN;
      "else",     ELSE;
      "for",      FOR
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
          | ";"
              { SEMI }
          | "+"
              { PLUS }
          | "*"
              { MULT }
          | "-"
              { SUB }
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
                raise (UnknowChar ("Unknow char(s) \""
                                   ^ (lexeme lexbuf)
                                   ^ "\" in "
                                   ^ start_p.pos_fname (* /!\ j'arrive pas à recup nom fichier *)
                                   ^ " at line "
                                   ^ (string_of_int start_p.pos_lnum)
                                   ^ ", col "
                                   ^ (string_of_int (start_p.pos_cnum - start_p.pos_bol))))}

and comment = parse
            | "(*"
                { comment lexbuf; comment lexbuf }
            | "*)"
                { () }
            | _
                { comment lexbuf }
            | eof
                { failwith "Unterminated comment" }
