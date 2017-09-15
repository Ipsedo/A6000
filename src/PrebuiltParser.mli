
(* The type of tokens. *)

type token = 
  | WHILE
  | VAR
  | THEN
  | STAR
  | SET
  | SEMI
  | PRINT
  | PLUS
  | OR
  | NEQ
  | MINUS
  | MAIN
  | LT
  | LE
  | INT
  | IF
  | IDENT of (string)
  | EQUAL
  | EOF
  | END
  | ELSE
  | CONST_INT of (int)
  | CONST_BOOL of (bool)
  | BOOL
  | BEGIN
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (SourceAst.main)
