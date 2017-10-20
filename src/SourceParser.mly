%{

  open SourceAst

%}

%token <string> IDENT
%token BEGIN END
%token SEMI
%token COMMA

%token BOOL
%token INT

%token WHILE

%token FOR

%token IF
%token THEN
%token ELSE

%token PRINT
%token EOF

%token SET

%token VAR

%token <int> LITINT
%token <bool> LITBOOL

%token PLUS MULT DIV SUB EQ NEQ LT LE MT ME AND OR

%left IDENT
%right BEGIN

%left AND OR
%nonassoc EQ NEQ LT LE MT ME
%left PLUS SUB
%left MULT DIV

%token INCR DECR
%token ADDSET SUBSET
%token MULTSET DIVSET

%start prog
%type <SourceAst.prog> prog

%%

prog:
  (*MAIN; BEGIN; INT; x=IDENT; END;
  BEGIN; vds=var_decls; is=instructions; END; EOF  {
	let infox = { typ=TypInteger; kind=FormalX } in
    let init  = Symb_Tbl.singleton x infox in
    let union_vars = fun _ _ v -> Some v in
    let locals = Symb_Tbl.union union_vars init vds in
    {locals = locals; code=is} }*)
    EOF { [] }
  | fct=fun_delc; m=prog { fct::m }
;

var_decls:
 (* empty *)                                 { Symb_Tbl.empty    }
| VAR; t=typ; id=IDENT; SEMI; tbl=var_decls  { let info = {typ=t; kind=Local} in
                                              Symb_Tbl.add id info tbl}
;

typ:
  INT { TypInteger }
| BOOL { TypBoolean }
;

instructions:
 (* empty *)                              { []               }
| i=instruction; SEMI; is=instructions    { i @ is           }
;

(* Pour ajouter la boucle for de façon "sucre styntaxique",
   il faut placer avant la boucle while une affectation.
   De ce fait il a fallu modifier la signature de la règle instruction
   en une list au lieu d'un élément simple *)
(* syntaxe for :
  for id := expr; cond; instr ( block );
*)
instruction:
  c=call { [ProcCall(c)] }
| PRINT; BEGIN; e=expression; END
  { [Print(e)] }
| s=set { [s] }
| IF; e=expression; THEN;
 BEGIN; is1=instructions; END;
 ELSE;
 BEGIN; is2=instructions; END
  { [If(e, is1, is2)] }
| IF; e=expression; THEN;
  BEGIN; is=instructions; END
  { [If(e, is, [])] }
| WHILE; e=expression; BEGIN; is=instructions; END
  { [While(e, is)] }
| FOR;
  id1=location; SET; e1=expression; SEMI;
  e2=expression; SEMI;
  s=set;
  BEGIN; bl=instructions; END
  {
    let block = bl @ [s] in
    [Set(id1, e1); While(e2, block)]
  }
;

set:
  id=location; SET; e=expression
  { Set(id, e) }
| id=location; op=instant_set_op
  {
    let to_c = Int(1, $startpos(id)) in
    let expr = Literal(to_c) in
    let from = Location(id) in
    let op = Binop(op, from, expr) in
    Set(id, op)
  }
| id=location; op=set_op; e=expression
  { Set(id, Binop(op, Location(id), e)) }
;

%inline instant_set_op:
  INCR { Add }
| DECR { Sub }
;

%inline set_op:
  ADDSET { Add }
| SUBSET { Sub }
| MULTSET { Mult }
| DIVSET  { Div }
;

expression:
  c=call                                  { FunCall(c)       }
| loc=location                            { Location(loc)    }
| lit=literal                             { Literal(lit)     }
| e1=expression; b=binop; e2=expression   { Binop(b, e1, e2) }
;

call:
id=IDENT; BEGIN; args=arguments; END; { id, args }
;

%inline binop:
  MULT { Mult }
| DIV  { Div }
| PLUS { Add }
| SUB  { Sub }
| LT   { Lt }
| LE   { Le }
| MT   { Mt }
| ME   { Me }
| EQ   { Eq }
| NEQ  { Neq }
| AND  { And }
| OR   { Or }
;

literal:
  i=LITINT { Int (i, $startpos(i)) }
| b=LITBOOL { Bool (b, $startpos(b)) }
;


location:
  id=IDENT  { Identifier (id, $startpos(id)) }
;

arguments:
  (* empty *) { [] }
  | a=args { a }
;

args:
| e=expression { [e] }
| e=expression; COMMA; a=args { e::a }
;

fun_delc:
  |t=typ; id=IDENT; BEGIN; p=parameters; END;
  BEGIN; vds=var_decls; is=instructions; END
  {
    let (_,params) = List.fold_left
    (fun (index, acc) (t1, ident) ->
      (index + 1, Symb_Tbl.add ident {typ=t1; kind=Formal(index)} acc))
    (0, Symb_Tbl.empty) p in
    let union_vars = fun _ _ v -> Some v in
    let tmp = Symb_Tbl.union union_vars params vds in
    let local = Symb_Tbl.add "result" {typ=t; kind=Return} tmp in
    let formal = Symb_Tbl.fold
      (fun _ v acc -> acc@[v.typ]) params [] in
    id, {
      return = Some t;
      formals = formal;
      locals = local;
      code = is
    }
  }
  |id=IDENT; BEGIN; p=parameters; END;
  BEGIN; vds=var_decls; is=instructions; END
  {
    let (_,params) = List.fold_left
    (fun (index, acc) (t, ident) ->
      (index + 1, Symb_Tbl.add ident {typ=t; kind=Formal(index)} acc))
    (0, Symb_Tbl.empty) p in
    let union_vars = fun _ _ v -> Some v in
    let local = Symb_Tbl.union union_vars params vds in
    let formal = Symb_Tbl.fold
      (fun _ v acc -> acc@[v.typ]) params [] in
    id, {
      return = None;
      formals = formal;
      locals = local;
      code = is
    }
  }
;

parameters:
| (* empty *) { [] }
| p=params { p }
;

params:
| t=typ; id=IDENT { [(t, id)] }
| t=typ; id=IDENT; COMMA; p=params { (t, id)::p }
;
