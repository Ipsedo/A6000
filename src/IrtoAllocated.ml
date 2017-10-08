module S = IrAst
module T = AllocatedAst

(* Allocation *)
let allocate_main reg_flag p =
  let current_offset = ref 0 in

  let tbl =
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
            | FormalX -> T.Stack 0
            | Local -> (let elt = GraphColoring.NodeMap.find id coloring in
                        if elt <= 7 then
                          T.Reg ("$t"^(string_of_int (elt + 2)))
                        else begin
                          current_offset := !current_offset - 4;
                          T.Stack (!current_offset)
                        end)
          ) p.S.locals
      end
    else
      (* Tout sur la pile *)
      S.Symb_Tbl.mapi (fun id (info: S.identifier_info) ->
          match info with
          | FormalX -> T.Stack 0
          | Local -> current_offset := !current_offset - 4;
            T.Stack (!current_offset)
        ) p.S.locals
  in

  { T.locals = tbl; T.offset = !current_offset; T.code = p.S.code }
