%{

  open SourceAst

%}

%token <string> IDENT
%token BEGIN END
%token O_BRACKETS C_BRACKETS O_BRACE C_BRACE
%token SEMI
%token COMMA

%token BOOL
%token INT

%token WHILE

%token FOR

%token IF
%token THEN
%token ELSE

%token EOF

%token SET

%token VAR

%token <int> LITINT
%token <bool> LITBOOL

%token PLUS MULT DIV SUB EQ NEQ LT LE MT ME AND OR

%token INCR DECR
%token ADDSET SUBSET
%token MULTSET DIVSET

%left AND OR
%nonassoc EQ NEQ LT LE MT ME
%left PLUS SUB
%left MULT DIV
%nonassoc O_BRACKETS

%start prog
%type <SourceAst.prog> prog

%%

prog:
    fcts=fun_delcs; EOF
    {
  (* On ajoute des fausses fonctions -> besoin pour typechecker et Ir-stuff,
      on les remplacera dans AllocatedtoMips *)
      let print =
        {
          return = None;
          formals = (TypInteger, "x")::[];
          locals = Symb_Tbl.singleton "x" { typ=TypInteger; kind=Formal(1) };
          code = []
        }
        in
        let print_int =
          {
            return = None;
            formals = (TypInteger, "x")::[];
            locals = Symb_Tbl.singleton "x" { typ=TypInteger; kind=Formal(1) };
            code = []
          }
          in
        let log10 =
        {
          return = Some TypInteger;
          formals = (TypInteger, "x")::[];
          locals = Symb_Tbl.singleton "x" { typ=TypInteger; kind=Formal(1) };
          code = []
        }
        in
        let random =
          let locals = Symb_Tbl.singleton "seed" { typ=TypInteger; kind=Formal(1) } in
          let locals = Symb_Tbl.add "range" { typ=TypInteger; kind=Formal(2) } locals in
        {
          return = Some TypInteger;
          formals = (TypInteger, "seed")::(TypInteger, "range")::[];
          locals = locals;
          code = []
        }
        in
        let tbl = Symb_Tbl.add "print" [print] fcts in
        let tbl = Symb_Tbl.add "print_int" [print_int] tbl in
        let tbl = Symb_Tbl.add "log10" [log10] tbl in
        let tbl = Symb_Tbl.add "random" [random] tbl in
        tbl

    }
;

fun_delcs:
    (* empty *) { Symb_Tbl.empty }
  | fct=fun_delc; fcts=fun_delcs
    { let id, infos = fct in
      let infos_l =
        match Symb_Tbl.find_opt id fcts with
          None -> []
        | Some s -> s
      in
    Symb_Tbl.add id (infos::infos_l) fcts }

var_decls:
  (* empty *) { Symb_Tbl.empty }
| VAR; t=typ; id=IDENT; SEMI; tbl=var_decls
  {
    let info = { typ=t; kind=Local } in
    Symb_Tbl.add id info tbl
  }
;

typ:
  INT  { TypInteger }
| BOOL { TypBoolean }
| O_BRACKETS; C_BRACKETS; t=typ { TypArray(t) }
;

instructions:
 (* empty *)                              { []     }
| i=instruction; SEMI; is=instructions    { i @ is }
;

(* Pour ajouter la boucle for de façon "sucre styntaxique",
   il faut placer avant la boucle while une affectation.
   De ce fait il a fallu modifier la signature de la règle instruction
   en une list au lieu d'un élément simple *)
(* syntaxe for :
  for id := expr; cond; set ( block );
*)
instruction:
  c=call { [ProcCall(c)] }
| s=set { [s] }
| IF; e=expression; THEN;
 BEGIN; is1=instructions; END;
 ELSE;
 BEGIN; is2=instructions; END
  { [If(e, is1, is2)] }
| IF; e=expression; THEN;
  BEGIN; is=instructions; END
  { [If(e, is, [])] }
| WHILE;
  BEGIN; e=expression; END;
  BEGIN; is=instructions; END
  { [While(e, is)] }
| FOR; BEGIN;
  id1=location; SET; e1=expression; SEMI;
  e2=expression; SEMI;
  s=set;
  END;
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
  ADDSET  { Add  }
| SUBSET  { Sub  }
| MULTSET { Mult }
| DIVSET  { Div  }
;

expression:
    c=call                                       { FunCall(c)       }
  | loc=location                                 { Location(loc)    }
  | lit=literal                                  { Literal(lit)     }
  | e1=expression; b=binop; e2=expression        { Binop(b, e1, e2) }
  | O_BRACKETS; e=expression; C_BRACKETS; t=typ  { NewArray(e, t)   }
  | O_BRACE; es=separated_list(COMMA, expression); C_BRACE { NewDirectArray(es) }
  ;

%inline binop:
  MULT { Mult }
| DIV  { Div  }
| PLUS { Add  }
| SUB  { Sub  }
| LT   { Lt   }
| LE   { Le   }
| MT   { Mt   }
| ME   { Me   }
| EQ   { Eq   }
| NEQ  { Neq  }
| AND  { And  }
| OR   { Or   }
;

call:
  id=IDENT; BEGIN; args=arguments; END { id, args }
;

arguments:
  a=separated_list(COMMA, expression) { a }
;

literal:
  i=LITINT  { Int (i, $startpos)  }
| b=LITBOOL { Bool (b, $startpos) }
;


location:
    id=IDENT  { Identifier (id, $startpos) }
  | e1=expression; O_BRACKETS; e2=expression; C_BRACKETS
    { ArrayAccess(e1, e2, $startpos)  }
;

fun_delc:
  t=typ; id=IDENT; BEGIN; p=parameters; END;
  BEGIN; vds=var_decls; is=instructions; END
  {
    let params = generate_formals_symb_tbl p in

    let union_vars = fun _ _ v -> Some v in
    let local = Symb_Tbl.union union_vars params vds in
    let local = Symb_Tbl.add "result" {typ=t; kind=Return} local in

    id, {
      return = Some t;
      formals = p;
      locals = local;
      code = is
    }
  }
  | id=IDENT; BEGIN; p=parameters; END;
    BEGIN; vds=var_decls; is=instructions; END
  {
    let params = generate_formals_symb_tbl p in

    let union_vars = fun _ _ v -> Some v in
    let local = Symb_Tbl.union union_vars params vds in

    id, {
      return = None;
      formals = p;
      locals = local;
      code = is
    }
  }
;

parameters:
  p=separated_list(COMMA, params) { p }
;

params:
| t=typ; id=IDENT { t, id }
;
