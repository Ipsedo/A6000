open IrAst
open IrLiveness

(**
   Construction du graphe d'interférence :

   1. Pour chaque instruction définissant une variable a, hors copies,
   où les variables vivantes en sortie sont b₁, ..., bₖ, ajouter les
   arêtes (a, b₁), ..., (a, bₖ).

   2. Pour chaque instruction de copie a ← c, où les variables vivantes
   en sortie sont b₁, ..., bₖ, ajouter les arêtes (a, b₁), ..., (a, bₖ)
   pour les bᵢ distincts de c.
*)

(* Fonction auxiliaire : ajoute à un graphe l'ensemble des interférences
   dues à une instruction donnée, connaissant l'ensemble des variables
   vivantes en sortie de cette instruction. *)
let add_interferences g lv_out_at_node = function
  | Value(a, Identifier c) ->
    (* Copie : ne pas introduire de conflit entre [a] et [c]. *)
    (* À compléter. *)
    VarSet.fold (fun elt acc -> Graph.add_edge g a elt) lv_out_at_node g
  | Binop(a, _, Identifier c1, Identifier c2) ->
    let tmp = VarSet.fold (fun elt acc -> Graph.add_edge g a elt) lv_out_at_node g
    in Graph.add_edge tmp c1 c2
  | _ -> g

let add_node_bourrin g str =
  try Graph.add_node g str
  with Graph.InvalidNode -> g

let make_instruction_node g = function
| Value(id, Identifier c) ->
  let tmp = add_node_bourrin g id
  in add_node_bourrin tmp c
| Binop(id, _,  Identifier c1,  Identifier c2) ->
  let tmp1 = add_node_bourrin g id in
  let tmp2 = add_node_bourrin tmp1 c1 in
  add_node_bourrin tmp2 c2
| Print( Identifier c) ->
  add_node_bourrin g c
| CondGoto(Identifier c, _) ->
  add_node_bourrin g c
| _ -> g

(* Fonction principale, qui itère sur l'ensemble des points du programme. *)
let interference_graph p : Graph.t =
  (* D'abord, définir le graphe sans arêtes contenant un sommet pour chaque
     identifiant de la table des symboles. *)
  let g = List.fold_left
          (fun acc (_, instr) ->
            make_instruction_node acc instr)
          Graph.empty p.code
  in

  (* Ensuite, récupérer le résultat de l'analyse de vivacité. *)
  let _, lv_out = mk_lv p in

  (* Enfin, itérer sur l'ensemble des points du programme. *)
  (* À compléter *)
  List.fold_left
  (fun acc (lab, instr) ->
    add_interferences acc (Hashtbl.find lv_out lab) instr)
  g p.code
