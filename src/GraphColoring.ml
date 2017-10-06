(**
   Les couleurs sont des entiers.
   Une coloration associe les identifiants à des couleurs.
*)
module NodeMap = Map.Make(String)
type color = int
type coloring = color NodeMap.t

(** Plus grande couleur utilisée dans une coloration.
    Sera utile plus tard pour initialiser le pointeur de pile. *)
let max_color coloring =
  NodeMap.fold (fun _ c mc -> max c mc) coloring 0

(** Étant donnés un graphe partiellement coloré et un sommet [n], renvoie la
    plus petite couleur pouvant être affectée à [n]. On supposera que les
    voisins de [n] sont déjà tous colorés. *)
let pick_color g coloring n =
  (* À compléter *)
  failwith "Not implemented"
  
(** Renvoie une coloration pour le graphe [g]. *)
let rec colorize (g : Graph.t) : coloring =
  (* À compléter *)
  failwith "Not implemented"

