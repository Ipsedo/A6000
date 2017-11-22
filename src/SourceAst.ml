(* Syntaxe abstraite typée *)

module Symb_Tbl = Map.Make(String)

(* Programme principal : une table de symboles et un bloc de code *)

(* La table des symboles contient, pour chaque variable :
   - sa nature  : variable locale ou paramètre formel
   - son type : entier ou booléen
*)
type prog = function_info Symb_Tbl.t
and function_info = {
  return:  typ option;
  formals: (typ * string) list; (* On en aura besoin pour l'affectation des formels *)
  locals:  identifier_info Symb_Tbl.t;
  code:    block
}
and call = string * expression list
and identifier_kind =
  | Local   (* Variable locale    *)
  | Formal of int
  | Return
and identifier_info = { typ: typ; kind: identifier_kind }
and typ =
  | TypInteger
  | TypBoolean
  | TypArray of typ

(* Un bloc de code est une liste d'instructions *)
and block = instruction list
and instruction =
  | Set   of location   * expression    (* Affectation *)
  | While of expression * block         (* Boucle      *)
  | If    of expression * block * block (* Branchement *)
  | ProcCall of call

and expression =
  | Literal   of literal      (* Valeur immédiate   *)
  | Location  of location   (* Valeur en mémoire  *)
  | Binop     of binop * expression * expression (* Opération binaire  *)
  | FunCall of call
  | NewArray of expression * typ

(* On ajoute une position de lexeme pour les erreurs de type,
   sera enlevé dans UntypedAst *)
and literal =
  | Int  of int * Lexing.position  (* Constante entière   *)
  | Bool of bool * Lexing.position (* Constante booléenne *)

and location =
  | Identifier of string * Lexing.position (* Variable en mémoire *)
  | ArrayAccess of expression * expression * Lexing.position

and binop =
  | Add (* +  *) | Mult (* *  *) | Sub (* - *) | Div (* / *)
  | Eq  (* == *) | Neq  (* != *)
  | Lt  (* <  *) | Le   (* <= *) | Mt (* > *) | Me (* >= *)
  | And (* && *) | Or   (* || *)

(* Fonction pour le parser *)
let generate_formals_symb_tbl f_list =
  let index = ref 0 in
  List.fold_left
    (fun acc (t, ident) -> incr index;
      Symb_Tbl.add
        ident
        {typ=t; kind=Formal(!index)}
        acc)
    Symb_Tbl.empty f_list

(* Cadeau pour le débogage : un afficheur.
   [print_main m] produit une chaîne de caractère représentant le programme
*)
open Printf

let rec print_typ = function
  | TypInteger -> "integer"
  | TypBoolean -> "boolean"
  | TypArray(t) -> sprintf "[]%s" (print_typ t)
and print_identifier_info i = print_typ i.typ

and print_symb_tbl tbl =
  Symb_Tbl.fold (fun v i s ->
      (sprintf "  var %s %s;\n" (print_identifier_info i) v) ^ s
    ) tbl ""

and print_literal = function
  | Int (i,_) -> sprintf "%d" i
  | Bool (b,_) -> if b then "true" else "false"
and print_location = function
  | Identifier (x,_) -> x
  | ArrayAccess(e1, e2, _) -> sprintf "%s[%s]" (print_expression e1) (print_expression e2)
and print_binop = function
  | Add  -> "+"
  | Mult -> "*"
  | Sub  -> "-"
  | Div  -> "/"
  | Eq   -> "=="
  | Neq  -> "!="
  | Lt   -> "<"
  | Le   -> "<="
  | Mt   -> ">"
  | Me   -> ">="
  | And  -> "&&"
  | Or   -> "||"

and print_call c =
  match c with
    (str, e) ->
    sprintf "%s(%s)" str
      (List.fold_left
         (fun acc elt -> acc^(print_expression elt)^", ")
         "" e)

and print_expression = function
  | Literal lit -> print_literal lit
  | Location id -> print_location id
  | Binop(op, e1, e2) ->
    sprintf "( %s %s %s )"
      (print_expression e1)
      (print_binop op)
      (print_expression e2)
  | FunCall(c) -> print_call c
  | NewArray(e, t) -> sprintf "[%s]%s" (print_expression e) (print_typ t)
(*| NewDirectArray(e, es) ->
  sprintf "{%s}"
  (List.fold_left
  (fun acc elt -> sprintf "%s%s," acc (print_expression elt))
  "" es)*)

let offset o = String.make (2*o) ' '
let rec print_block o = function
  | [] -> ""
  | i::b -> (offset o) ^ (print_instruction o i) ^ ";\n" ^ (print_block o b)
and print_instruction o = function
  | Set(id, e) -> sprintf "%s := %s" (print_location id) (print_expression e)
  | While(e, b) ->
    sprintf "while %s (\n%s%s)"
      (print_expression e)
      (print_block (o+1) b) (offset o)
  | If(e, b1, b2) ->
    sprintf "if %s then (\n%s%s) else (\n%s%s)"
      (print_expression e)
      (print_block (o+1) b1) (offset o)
      (print_block (o+1) b2) (offset o)
  | ProcCall(c) -> print_call c

let print_main m =
  sprintf "main(int x) (\n%s%s)\n"
    (print_symb_tbl m.locals) (print_block 1 m.code)
