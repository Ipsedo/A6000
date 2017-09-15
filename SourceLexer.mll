{

  open Lexing
  open SourceParser

  let id_or_keyword =
    let h = Hashtbl.create 17 in
    List.iter (fun (s, k) -> Hashtbl.add h s k)
      [	"integer",  INT;
	"print",    PRINT;
	"main",     MAIN;
      ] ;
    fun s ->
      try  Hashtbl.find h s
      with Not_found -> IDENT(s)

}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let ident = ['a'-'z' '_'] (alpha | '_' | '\'' | digit)*

rule token = parse
  | ['\n' ' ' '\t' '\r']+
      { token lexbuf }
  | ident
      { id_or_keyword (lexeme lexbuf) }
  | "("
      { BEGIN }
  | ")"
      { END }
  | ";"
      { SEMI }
  | _
      { failwith ("Unknown character : " ^ (lexeme lexbuf)) }
  | eof
      { EOF }

and comment = parse
  | "(*"
      { comment lexbuf; comment lexbuf }
  | "*)"
      { () }
  | _
      { comment lexbuf }
  | eof
      { failwith "Unterminated comment" }
