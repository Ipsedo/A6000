%{

  open SourceAst

%}

%token <string> IDENT
%token BEGIN END
%token SEMI
%token INT
%token PRINT
%token EOF
%token MAIN

%token PLUS MULT
%token SET

%token BOOL

%token VAR

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
| id=location; SET; e=expression; END        { Set(id, e) }
;

expression:
| loc=location                            { Location(loc)     }
(* À compléter *)
;

%inline binop:
| PLUS { Add }
| MULT { Mult }

location:
| id=IDENT  { Identifier id }
;
