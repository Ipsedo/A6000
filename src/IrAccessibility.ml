open IrAst

let mk_pred code =
  let pred = Hashtbl.create 257 in

  let rec mk_pred : IrAst.block -> unit = function
    | _ -> failwith "Not implemented"
  in
  mk_pred (List.rev code);

  pred

let mk_ac p =

  let code = p.code in
  let ac_in  = Hashtbl.create 257
  and ac_out = Hashtbl.create 257
  and pred = mk_pred code
  in
  failwith "Not Implemented"
