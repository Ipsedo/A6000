(**
   Les couleurs sont des entiers.
   Une coloration associe les identifiants à des couleurs.
*)
module NodeMap = Map.Make(String)
type color = int
type coloring = color NodeMap.t

exception ColoringCanBegin

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

  let list_color = List.fold_left
      (fun acc elt -> (NodeMap.find elt coloring)::acc)
      [] node_interference
  in

  let sorted_list = List.sort compare list_color in

  List.fold_left
    (fun acc color -> if color = acc then (acc + 1) else acc)
    0 sorted_list

(* L'exception sera levée quand il ne restera plus de noeuds dans notre graphe
   (ie. il faut commencer à colorier notre graphe),
   cette exception sera rattrapée dans colorize où nous renverrons le NodeMap.t
   dans lequel il faudra ajouter la couleur de chaque variables. *)
let min_deg_node g =
  match Graph.min_degree g with
  | Some str -> str
  | None -> raise ColoringCanBegin

(** Renvoie une coloration pour le graphe [g]. *)
let rec colorize (g : Graph.t) : coloring =
  try
    let min_node = min_deg_node g in
    let new_g = Graph.del_node g min_node in
    let coloring = colorize new_g in
    NodeMap.add min_node (pick_color g coloring min_node) coloring
  with ColoringCanBegin -> NodeMap.empty
