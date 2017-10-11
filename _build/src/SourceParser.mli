
(* The type of tokens. *)

type token = 
  | WHILE
  | VAR
  | THEN
  | SUBSET
  | SUB
  | SET
  | SEMI
  | PRINT
  | PLUS
  | OR
  | NEQ
  | MULTSET
  | MULT
  | MT
  | ME
  | MAIN
  | LT
  | LITINT of (int)
  | LITBOOL of (bool)
  | LE
  | INT
  | INCR
  | IF
  | IDENT of (string)
  | FOR
  | EQ
  | EOF
  | END
  | ELSE
  | DIVSET
  | DIV
  | DECR
  | BOOL
  | BEGIN
  | AND
  | ADDSET

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (SourceAst.main)
