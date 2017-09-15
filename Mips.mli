(* Registres *)
type register
val v0 : register
val v1 : register
val a0 : register
val a1 : register
val a2 : register
val a3 : register
val t0 : register
val t1 : register
val t2 : register
val t3 : register
val t4 : register
val t5 : register
val t6 : register
val t7 : register
val t8 : register
val t9 : register
val s0 : register
val s1 : register
val s2 : register
val s3 : register
val s4 : register
val s5 : register
val s6 : register
val s7 : register
val ra : register
val sp : register
val fp : register
val gp : register
val zero : register

val ( ~$ ) : register -> register

(* Groupe d'instructions assembleur *)
type label = string
type 'a asm
type text = [ `text ] asm
type data = [ `data ] asm

(* Arithmétique et logique *)
val add  : register -> register -> register -> 'a asm
val addi : register -> register -> int      -> 'a asm
val sub  : register -> register -> register -> 'a asm
val mul  : register -> register -> register -> 'a asm
val div  : register -> register -> register -> 'a asm
val rem  : register -> register -> register -> 'a asm
val and_ : register -> register -> register -> 'a asm
val or_  : register -> register -> register -> 'a asm
val not_ : register -> register -> 'a asm
val neg  : register -> register -> 'a asm

(* Comparaisons *)
val seq : register -> register -> register -> 'a asm
val sne : register -> register -> register -> 'a asm
val slt : register -> register -> register -> 'a asm
val sle : register -> register -> register -> 'a asm
val sgt : register -> register -> register -> 'a asm
val sge : register -> register -> register -> 'a asm

(* Branchements *)
val b    : label -> 'a asm
val beq  : register -> register -> label -> 'a asm
val bne  : register -> register -> label -> 'a asm
val bge  : register -> register -> label -> 'a asm
val bgt  : register -> register -> label -> 'a asm
val ble  : register -> register -> label -> 'a asm
val blt  : register -> register -> label -> 'a asm
val beqz : register -> label -> 'a asm
val bnez : register -> label -> 'a asm
val bgez : register -> label -> 'a asm
val bgtz : register -> label -> 'a asm
val blez : register -> label -> 'a asm
val bltz : register -> label -> 'a asm

val jr : register -> 'a asm
val jal : label -> 'a asm

(* Lecture/écriture *)
val li  : register -> int -> 'a asm
val la  : register -> label -> 'a asm
val lbu : register -> int -> register -> 'a asm
val lw  : register -> int -> register -> 'a asm
val sw  : register -> int -> register -> 'a asm
val move : register -> register -> 'a asm

(* Divers *)
val nop     : 'a asm
val label   : label -> 'a asm
val syscall : 'a asm
val comment : string -> 'a asm
val asciiz  : string -> 'a asm
val dword   : int list -> 'a asm

(* Concaténation *)
val ( @@ ) : 'a asm -> 'a asm -> 'a asm

type program = { text : [ `text ] asm; data : [ `data ] asm; }

val print_program : Format.formatter -> program -> unit
