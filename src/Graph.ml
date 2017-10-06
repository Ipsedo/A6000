(**
   A module for undirected graphs with nodes labelled by strings.
   Adapted (and grossly simplified) from a library by Yann Régis-Gianas.
*)

(** A type for maps whose keys are integers. *)
module IntMap = Map.Make (struct type t = int let compare = compare end)
let int_map_update key map default f =
  try let v = IntMap.find key map in
      IntMap.add key (f v) map
  with Not_found ->
    IntMap.add key (f default) map
      
(** A type for maps whose keys are node labels. *)
module NodeMap = Map.Make (String)
let nodelabel_map_update key map default f =
  try let v = NodeMap.find key map in
      NodeMap.add key (f v) map
  with Not_found ->
    NodeMap.add key (f default) map

(** A type for sets of node labels. *)
module NodeSet = Set.Make (String)

(** The type for graphs.

    The datastructure maintains redundant information about the
    graph using multiple maps. Each map provides a logarithmic
    complexity for important services of the datastructure, namely
    the computation of nodes of least [degrees] and the computation
    of a node [neighbourhood].
    
    A node is externally characterized by a list of node labels
    while internally it is characterized by a node identifier. We
    also maintain this mapping using maps, namely [node_of_label]
    and [labels].
    
    [next_node_id] is a counter that helps determining the identifier
    for a newly created node.
*)

type t = {
    neighbours : NodeSet.t NodeMap.t;
    degrees    : NodeSet.t IntMap.t
}

(** [dump g] returns a text-based representation of the graph, for
    debugging. *)
let dump g =
  let neighbours =
    NodeMap.bindings g.neighbours |> List.map (fun (id, ids) ->
      Printf.sprintf "%s --> %s"
	id (String.concat "," (NodeSet.elements ids))
    )
	 |> String.concat "\n"
  in
  let degrees =
    IntMap.bindings g.degrees |> List.map (fun (d, ids) ->
      Printf.sprintf "%d ==> %s"
	d
	(String.concat "," (NodeSet.elements ids))
    )
	 |> String.concat "\n"
  in
  Printf.sprintf "%s\n%s\n" neighbours degrees

(** The empty graph. *)
let empty = {
  neighbours = NodeMap.empty;
  degrees = IntMap.empty;
}

exception InvalidNode
  
let defined_node g n = NodeMap.mem n g.neighbours
    
let update_neighbour update_set g id1 id2 =
  (** What is the degree of id1? *)
  let id1_nbg =
    try NodeMap.find id1 g.neighbours
    with _ ->
      (Printf.printf "Node %s not found\n" id1;
       assert false)
  in
  let id1_deg = NodeSet.cardinal id1_nbg in
  
  (** Update the neighbours of id1 with update_set id2. *)
  let nbg =
    nodelabel_map_update id1 g.neighbours NodeSet.empty (update_set id2)
  in
  
  (** Update the degree of id1. *)
  let deg =
    int_map_update id1_deg g.degrees NodeSet.empty (NodeSet.remove id1)
  in
  let deg =
    if IntMap.find id1_deg deg = NodeSet.empty then
      IntMap.remove id1_deg deg
    else
      deg
  in
  let id1_nbg = try NodeMap.find id1 nbg with _ -> assert false in
  let id1_deg = NodeSet.cardinal id1_nbg in
  let deg = int_map_update id1_deg deg NodeSet.empty (NodeSet.add id1) in
  
  (** Finally, update the graph. *)
  let g = { neighbours = nbg; degrees = deg } in
  g
    
let add_neighbour = update_neighbour NodeSet.add
let del_neighbour = update_neighbour NodeSet.remove
  
(** [add_node g [n1;...;nN]] returns a new graph that extends [g] with
    a new node labelled by [n1;...;nN]. None of the [nI] can be used
    by another node in [g]. Otherwise, [InvalidNode] is raised.
    
    In the sequel, the new node can be identified by any [nI].
*)
let add_node g n =
  (** Second, we check that [ns] are not used by any other node. *)
  if defined_node g n then
    raise InvalidNode;
  
  (** Third, update maps. *)
  let neighbours =
    NodeMap.add n NodeSet.empty g.neighbours
  in
  (** Initially, the node has a degree 0 since it has no neighbour. *)
  let degrees =
    int_map_update 0 g.degrees NodeSet.empty (NodeSet.add n)
  in
  { neighbours; degrees }
    
(** [add_edge g n1 e n2] returns a new graph that extends [g] with a
    new edge between [n1] and [n2]. The edge is labelled by [e]. If [n1]
    or [n2] does not exist, then [InvalidNode] is raised. *)
let add_edge g n1 n2 =
  if not (defined_node g n1 && defined_node g n2) then
    raise InvalidNode;
  if n1 = n2
  then g
  else let g = add_neighbour g n1 n2 in
       let g = add_neighbour g n2 n1 in
       g
    
(** [neighbours g e n] returns the neighbours of [n] in [g]. *)
let neighbours g n =
  NodeSet.elements (NodeMap.find n g.neighbours)
    
(** [del_node g n] returns a new graph that contains [g] minus the
    node [n] and its edges. *)
let del_node g n =
  let g =
    let nbg = NodeMap.find n g.neighbours in
    NodeSet.fold (fun n' g ->
      let g = del_neighbour g n' n in
      let g = del_neighbour g n n' in
      g
    ) nbg g
  in
  let neighbours =
    NodeMap.remove n g.neighbours
  in
  let degrees =
    let deg0 = IntMap.find 0 g.degrees in
    let deg0 = NodeSet.remove n deg0 in
    if deg0 = NodeSet.empty then
      IntMap.remove 0 g.degrees
    else
      IntMap.add 0 deg0 g.degrees
  in
  { neighbours; degrees }
    
let rec uniq = function
  | [] -> []
  | [x] -> [x]
  | x :: ((y :: _) as xs) -> if x = y then uniq xs else x :: uniq xs
      
(** [edges g e] returns all the edges of kind [e] in [g]. *)
let edges g =
  let edges =
    NodeMap.fold (fun id ids edges ->
      NodeSet.fold (fun id' edges ->
  	(id, id') :: edges
      ) ids edges) g.neighbours []
  in
  let edges = List.map (fun (n1, n2) ->
    if n1 < n2 then (n1, n2) else (n2, n1)
  ) edges
  in
  let edges = List.sort compare edges in
  uniq edges
    
let min_degree g =
  let rec aux degrees =
    try
      let k, ids = IntMap.min_binding degrees in
      try
	let id = NodeSet.choose ids in
	Some id
      with Not_found ->
	aux (IntMap.remove k degrees)
    with Not_found -> None
  in
  aux g.degrees
    
