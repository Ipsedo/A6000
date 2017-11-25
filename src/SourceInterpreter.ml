open SourceAst

module State = Map.Make(String)
type state = int State.t

module Heap = Map.Make(Int32)
type heap = int array Heap.t

let heap_offset = ref 0

let eval_main p x =

  let rec eval_block env heap b =
    match b with
      [] -> env, heap
    | i::b -> let env1, h = eval_instruction env heap i in
      eval_block env1 h b

  and eval_instruction env heap i =
    match i with
    | Set(Identifier(id, _), e) ->
      let h, res = eval_expression env heap e in
      State.add id res env, h
    | Set(ArrayAccess(e1, e2, _), e) ->
      let h, res1 = eval_expression env heap e1 in
      let h, res2 = eval_expression env h e2 in
      let h, res3 = eval_expression env h e in
      let arr = Heap.find (Int32.of_int res1) h in
      Array.set arr res2 res3;
      env, Heap.add (Int32.of_int res1) arr h
    | While(c, b) as iw ->
      let h, res = eval_expression env heap c in
      if res <> 0
      then let env, h = eval_block env h b in
        eval_instruction env h iw
      else env, heap
    | If(c, b1, b2) ->
      let h, res = eval_expression env heap c in
      if res <> 0
      then eval_block env h b1
      else eval_block env h b2
    | ProcCall(c) -> let str, e = c in
      if str = "print" then
        (* Cas spécial pour la fonction print -> faire log10, string_of_int et arr_length *)
        begin
          match e with
            e1::[] -> let h, res = eval_expression env heap e1 in
            Printf.printf "%c" (Char.chr res);
            env, h
          | _ -> failwith "invalid args for print interpreteur"
        end
      else
        (* On évalue les paramètres *)
        let h1, l = List.fold_left
            (fun (h, acc) elt -> let hnew, res = eval_expression env h elt in
              (hnew, acc@[res]))
            (heap, []) e
        in
        (* Puis on récupère la fonction et on crée un nouvel environnement avec
            avec les résultats pour le passage des paramètres *)
        let proc = Symb_Tbl.find str p in
        let proc_state = Symb_Tbl.fold
            (fun k a acc ->
               match a.kind with
                 Formal n -> State.add k (List.nth l (n - 1)) acc
               | _ -> acc)
            proc.locals State.empty
        in
        let _, hnew = eval_block proc_state h1 proc.code in
        env, hnew

  and eval_expression env heap e =
    match e with
      Literal lit  -> heap, eval_literal env lit
    | Location loc -> eval_location env heap loc
    | Binop(op, e1, e2) -> let h, v1 = eval_expression env heap e1 in
      let h, v2 = eval_expression env h e2 in
      let op = match op with
        | Add  -> (+)
        | Mult -> ( * )
        | Sub  -> (-)
        | Div  -> (/)
        | Eq   -> eval_bool_op (=)
        | Neq  -> eval_bool_op (<>)
        | Lt   -> eval_bool_op (<)
        | Le   -> eval_bool_op (<=)
        | Me   -> eval_bool_op (>=)
        | Mt   -> eval_bool_op (>)
        | And  -> min
        | Or   -> max
      in
      h, op v1 v2
    | FunCall(c) ->
      (* Même chose que pour ProcCall *)
      let str, e = c in
      let h1, l = List.fold_left
          (fun (h, acc) elt -> let hnew, res = eval_expression env h elt in
            (hnew, acc@[res]))
          (heap, []) e
      in
      (* On doit evaluer arr_length separement -> voir MipsMisc.ml *)
      let fct_state, hnew = eval_fct str h1 l in

      (* On récupère le resultat dans l'environnement de la fonction *)
      hnew, State.find "result" fct_state
    | NewArray(e, _) ->
      (* On évalue l'expression donnant le nombre d'élément du tableau à créer *)
      let h, nb_elt = eval_expression env heap e in
      (* On crée un nouveau tableau pour la représentation du tas *)
      let arr = Array.make nb_elt 0 in
      (* On récupère l'@ courrante du début du tableau *)
      let addr = !heap_offset in
      (* On incrémente pour le prochain tableau *)
      heap_offset := addr + nb_elt;
      (* On ajoute le tableau avec comme clef l'@ courrante *)
      Heap.add (Int32.of_int addr) arr h, addr
    | NewDirectArray(e) ->
      let length = List.length e in
      let arr = Array.make length 0 in
      let addr = !heap_offset in
      heap_offset := !heap_offset + length;
      (* On ajoute les sous-éléments*)
      let h,_ = List.fold_left
          (fun (acc, index) elt -> let hnew, v = eval_expression env acc elt in
            Array.set arr index v;
            (hnew, index + 1)) (heap, 0) e
      in
      Heap.add (Int32.of_int addr) arr h, addr

  and eval_fct str h l =
    let proc = Symb_Tbl.find str p in
    if str = "arr_length" then
      let length =
        match l with
          a::[] -> Array.length (Heap.find (Int32.of_int a) h)
        | _ -> failwith "No arg for arr_length interpreteur !"
      in
      State.singleton "result" length, h
    else if str = "log10" then
      let res =
        match l with
          a::[] -> int_of_float (log10 (float_of_int a))
        | _ -> failwith "No arg for arr_length interpreteur !"
      in
      State.singleton "result" res, h
    else if str = "string_of_int" then
      match l with
        a::[] -> let str = string_of_int a in
        let nb_elt = String.length str in
        let arr = Array.make nb_elt 0 in
        let addr = !heap_offset in
        heap_offset := addr + nb_elt;
        String.iteri (fun i c -> arr.(i) <- Char.code c) str;
        let hnew = Heap.add (Int32.of_int addr) arr h in
        State.singleton "result" addr, hnew
      | _ -> failwith "No arg for arr_length interpreteur !"
    else
      let fct_state = Symb_Tbl.fold
          (fun k a acc ->
             match a.kind with
               Formal n -> State.add k (List.nth l (n - 1)) acc
             | _ -> acc)
          proc.locals State.empty
      in
      eval_block fct_state h proc.code

  and eval_bool b = if b then 1 else 0
  and eval_bool_op op = fun v1 v2 -> eval_bool (op v1 v2)

  and eval_literal env = function
    | Int(i, _)  -> i
    | Bool(b, _) -> eval_bool b

  and eval_location env heap = function
    | Identifier(id, _) -> heap, State.find id env
    | ArrayAccess(e1, e2, _) ->
      (* On récupère le sous tableau / tableau courrant  *)
      let h, res1 = eval_expression env heap e1 in
      (* On récupère l'indice du tableau *)
      let h, res2 = eval_expression env h e2 in
      (* On récupère le tableau dans la représentation du tas *)
      let arr = Heap.find (Int32.of_int res1) h in
      h, arr.(res2)
  in

  let fct = Symb_Tbl.find "main" p in
  eval_block (State.singleton "x" x) Heap.empty fct.code
