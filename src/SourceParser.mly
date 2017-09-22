%{

  open SourceAst

%}

%token <string> IDENT
%token BEGIN END
%token SEMI

%token BOOL
%token INT

%token WHILE
%token IF
%token THEN
%token ELSE
%token PRINT
%token EOF
%token MAIN

%token PLUS MULT SUB EQ NEQ LT LE AND OR
%right PLUS SUB
%left MULT
%right EQ NEQ LT LE
%right AND OR
%token SET

%token VAR

%token <int> LITINT

%token TRUE FALSE

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
| (* empty *)                             { Symb_Tbl.empty    }
| VAR; t=typ; id=IDENT; SEMI; tbl=var_decls        {let info = {typ=t; kind=Local} in Symb_Tbl.add id info tbl}
(* À compléter *)
;

typ:
| INT { TypInteger }
| BOOL { TypBoolean }

instructions:
| (* empty *)                             { []                }
| i=instruction; SEMI; is=instructions    { i :: is           }
;

instruction:
| PRINT; BEGIN; e=expression; END         { Print(e)          }
(* À compléter *)
| id=location; SET; e=expression        { Set(id, e) }
| IF; e=expression; THEN;
 BEGIN; is1=instructions; END;
 ELSE;
 BEGIN; is2=instructions; END;
  { If(e, is1, is2) }
| WHILE; e=expression; BEGIN; is=instructions; END
  { While(e, is) }
;

expression:
| loc=location                            { Location(loc)     }
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
| i=LITINT { Int i }
| TRUE { Bool true }
| FALSE { Bool false }


location:
| id=IDENT  { Identifier id }
;
