(**
   Les couleurs sont des entiers.
   Une coloration associe les identifiants à des couleurs.
*)
module NodeMap = Map.Make(String)
type color = int
type coloring = color NodeMap.t

exception ColoringFinished

(** Plus grande couleur utilisée dans une coloration.
    Sera utile plus tard pour initialiser le pointeur de pile. *)
let max_color coloring =
  NodeMap.fold (fun _ c mc -> max c mc) coloring 0

(** Étant donnés un graphe partiellement coloré et un sommet [n], renvoie la
    plus petite couleur pouvant être affectée à [n]. On supposera que les
    voisins de [n] sont déjà tous colorés. *)
let pick_color g coloring n =
  (* À compléter *)
  let node_interference = Graph.neighbours g n in
  List.fold_left
    (fun acc elt ->
      let color = NodeMap.find elt coloring in
      if color < acc then color
      else acc)
  max_int node_interference

let min_deg_node g =
  match Graph.min_degree g with
  | Some str -> str
  | None -> raise ColoringFinished


(** Renvoie une coloration pour le graphe [g]. *)
let rec colorize (g : Graph.t) : coloring =
  (* À compléter *)
  (*let rec stack_node g list_acc =
    match Graph.min_degree g with
    | Some str -> stack_node (Graph.del_node g str) (str::list_acc)
    | None -> list_acc
  in*)
  try
    let min_node = min_deg_node g in
    let new_g = Graph.del_node g min_node in
    let coloring = colorize new_g in
    NodeMap.add min_node (pick_color new_g coloring min_node) coloring
  with ColoringFinished -> NodeMap.empty
