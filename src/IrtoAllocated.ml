module S = IrAst
module T = AllocatedAst

(* Allocation *)
let allocate_prog reg_flag prog =

  let current_offset = ref 0 in

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
            | _ -> let elt = GraphColoring.NodeMap.find id coloring in
              if elt <= 7 then
                T.Reg (Printf.sprintf "$t%d" (elt + 2))
              else begin
                current_offset := !current_offset - 4;
                T.Stack (!current_offset)
              end
          ) p.S.locals
      end
    else
      S.Symb_Tbl.mapi (fun id (info: S.identifier_info) ->
          match info with
          | _ -> current_offset := !current_offset - 4;
            T.Stack (!current_offset)
        ) p.S.locals
  in

  S.Symb_Tbl.fold
    (fun id info acc ->
       current_offset := 0;
       Printf.printf "%s\n" id;
       T.Symb_Tbl.add id
         { T.formals = info.S.formals;
           T.locals = tbl info;
           T.offset = !current_offset;
           T.code = info.S.code }
         acc)
    prog T.Symb_Tbl.empty
