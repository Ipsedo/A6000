module S = IrAst
module T = AllocatedAst

(* Allocation *)
let allocate_prog reg_flag prog =
  let current_offset = ref 0 in

  let delete_formal p =
    { S.locals = S.Symb_Tbl.filter
          (fun _ (id_info: S.identifier_info) ->
             match id_info with Formal _ -> false | _ -> true)
      p.S.locals;
      S.code = p.S.code }
in


  let tbl p =
    if reg_flag
    then
      begin
        let g = IrInterferenceGraph.interference_graph p in
        Printf.printf "%s\n" (Graph.dump g);
        let coloring = GraphColoring.colorize g in
        GraphColoring.NodeMap.iter
          (fun key elt -> Printf.printf "%s %d\n" key elt)
          coloring;

        S.Symb_Tbl.mapi (fun id (info: S.identifier_info) ->
            match info with
            | Formal n -> if n < 4 then
                T.Reg (Printf.sprintf "$a%d" n)
              else begin
                current_offset := !current_offset - 4;
                T.Stack (!current_offset)
              end
            | Local -> (let elt = GraphColoring.NodeMap.find id coloring in
                        if elt <= 7 then
                          T.Reg ("$t"^(string_of_int (elt + 2)))
                        else begin
                          current_offset := !current_offset - 4;
                          T.Stack (!current_offset)
                        end)
            | Return -> failwith "Unimplemented Return IrToAllocated"
          ) p.S.locals
      end
    else
      (* Tout sur la pile *)
      S.Symb_Tbl.mapi (fun id (info: S.identifier_info) ->
          match info with
          | Formal n -> failwith "unimplemented Formal IrToAllacated"
          | Local -> current_offset := !current_offset - 4;
            T.Stack (!current_offset)
          | Return -> failwith "Return pas fait"
        ) p.S.locals
  in

  S.Symb_Tbl.fold
    (fun id info acc ->
       current_offset := 0;
        Printf.printf "%s\n" id;
        T.Symb_Tbl.add id
        { T.locals = tbl info; T.offset = !current_offset; T.code = info.S.code }
        acc)
    prog T.Symb_Tbl.empty
