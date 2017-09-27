%{

  open SourceAst

%}

%token <string> IDENT
%token BEGIN END
%token SEMI

%token BOOL
%token INT

%token WHILE

%token FOR

%token IF
%token THEN
%token ELSE

%token PRINT
%token EOF
%token MAIN

%token SET

%token VAR

%token <int> LITINT

%token TRUE FALSE

%token PLUS MULT SUB EQ NEQ LT LE AND OR

%left AND OR
%left EQ NEQ LT LE
%left PLUS SUB
%left MULT

%token INCR

%start main
%type <SourceAst.main> main

%%

main:
| MAIN; BEGIN; INT; x=IDENT; END;
  BEGIN; vds=var_decls; is=instructions; END; EOF  {
	let infox = { typ=TypInteger; kind=FormalX } in
    let init  = Symb_Tbl.singleton x infox in
    let union_vars = fun _ _ v -> Some v in
    let locals = Symb_Tbl.union union_vars init vds in
    {locals = locals; code=is} }
;

var_decls:
| (* empty *)                                { Symb_Tbl.empty    }
| VAR; t=typ; id=IDENT; SEMI; tbl=var_decls  { let info = {typ=t; kind=Local} in
                                              Symb_Tbl.add id info tbl}
(* À compléter *)
;

typ:
| INT { TypInteger }
| BOOL { TypBoolean }

instructions:
| (* empty *)                             { []                }
| i=instruction; SEMI; is=instructions    { i @ is           }
;

instruction:
| PRINT; BEGIN; e=expression; END
  { [Print(e)] }
| s=set { s }
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
  id2=location; SET; e3=expression;
  BEGIN; bl=instructions; END
  {
    let block = bl @ [Set(id2, e3)] in
    [Set(id1, e1); While(e2, block)]
  }
;

set:
|id=location; SET; e=expression
  { [Set(id, e)] }
|id=location; INCR
  {
    [Set(id, Binop(Add, Location(id), Literal(Int(1, Parsing.symbol_end_pos ()))))]
  }

expression:
| loc=location                            { Location(loc) }
(* À compléter *)
| lit=literal                             { Literal(lit) }
| e1=expression; b=binop; e2=expression   { Binop(b, e1, e2) }
;

%inline binop:
| MULT { Mult }
| PLUS { Add }
| SUB  { Sub }
| LT   { Lt }
| LE   { Le }
| EQ   { Eq }
| NEQ  { Neq }
| AND  { And }
| OR   { Or }

literal:
| i=LITINT { Int (i, Parsing.symbol_end_pos ()) }
| TRUE { Bool (true, Parsing.symbol_end_pos ()) }
| FALSE { Bool (false, Parsing.symbol_end_pos ()) }


location:
| id=IDENT  { Identifier (id, Parsing.symbol_end_pos ()) }
;
