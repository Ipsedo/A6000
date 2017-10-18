open Format

exception UnexpectedToken of string

let usage = "usage: compilo [options] file.a6m"

(* Par défaut : génération de code MIPS sans optimisation. *)
let interpret      = ref false
let reg_allocation = ref false
let dead_code_elim = ref false
let prebuilt_frontend = ref false
let preprocessor = ref false
let input = ref 0

let spec =
  [ "-r", Arg.Set reg_allocation, "  with register allocation";
    "-dce", Arg.Set dead_code_elim, "  with dead code elimination";
    "-O", Arg.Tuple [Arg.Set reg_allocation; Arg.Set dead_code_elim],
    "  full optimisation";
    "-i", Arg.Tuple [Arg.Set_int input; Arg.Set interpret],
    "  interpreter only";
    "-frontend", Arg.Set prebuilt_frontend, "  use prebuilt frontend";
    "-pp", Arg.Set preprocessor, " use macros preprocessing"
  ]

let file =
  let file = ref None in
  let set_file s =
    if not (Filename.check_suffix s ".a6m") then
      raise (Arg.Bad "no .a6m extension");
    file := Some s
  in
  Arg.parse spec set_file usage;
  match !file with Some f -> f
                 | None -> Arg.usage spec usage; exit 1


let raise_token_excpetion lb = let start_p = Lexing.lexeme_start_p lb in
  raise (UnexpectedToken ("Unexpected token \""
                          ^ (Lexing.lexeme lb)
                          ^ "\" in "
                          ^ start_p.pos_fname
                          ^ " at line "
                          ^ (string_of_int start_p.pos_lnum)
                          ^ ", col "
                          ^ (string_of_int (start_p.pos_cnum - start_p.pos_bol))))

let preprocess f =
  let c = open_in file in
  let output_file = (Filename.chop_suffix file ".a6m") ^ ".pp.a6m" in
  let out = open_out output_file in
  let rec aux lb accu =
    match Preprocessor.macro lb with
    | "EOF" -> accu
    | _ as str -> aux lb (accu^str)
  in
  Printf.fprintf out "%s\n" (aux (Lexing.from_channel c) "");
  close_out out;
  open_in output_file

let () =
  let c = if !preprocessor then preprocess file
    else open_in file in
  let lb = Lexing.from_channel c in
  let p  = if !prebuilt_frontend
    then (*PrebuiltParser.main PrebuiltLexer.token lb*)
      failwith "c + possible..."
    else begin
      try SourceParser.prog SourceLexer.token lb
      with SourceParser.Error -> raise_token_excpetion lb
    end
  in
  close_in c;
  SourceTypeChecker.typecheck_main p;
  if !interpret
  then let _ = SourceInterpreter.eval_main p !input in ()
  else begin
    let p = SourcetoUntyped.erase_main p in
    let p = UntypedtoGoto.destructure_main p in
    let p = GototoIr.flatten_main p in
    (* Code à réintégrer à la séance 3 *)
    let p =
      if   !dead_code_elim
      then IrDeadCodeElim.dce p
      else p
    in
    let p = IrtoAllocated.allocate_main !reg_allocation p in
    let asm = AllocatedtoMips.generate_main p in
    let output_file = (Filename.chop_suffix file ".a6m") ^ ".asm" in
    let out = open_out output_file in
    let outf = formatter_of_out_channel out in
    Mips.print_program outf asm;
    pp_print_flush outf ();
    close_out out;
  end;
  exit 0
