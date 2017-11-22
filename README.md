# Devoir de compilation
_Auteur : Samuel BERRIEN_

## Acte I

Parties ayant été faites et fonctionnelles :
+ **TP 1 - Représentations intermédiaires et génération de code assembleur MIPS**

+ **TP 2 - Analyse lexicale, analyse syntaxique**
  - _extentions :_
    - Sucre syntaxique pour la boucle for.
      Ainsi que d'autres éléments tel l'in/decrémentation ++/--,
      la mise à jour d'une variable via l'affectation OP=
      (+=, -=, /=, \*= ).
    - Le simple branchement if sans else.
    - Divers operateurs manquants ( /, >, >= ...).
    - Aider son prochain : messages d'erreur :
      Message d'erreur pour caractère non reconnu,
      lexème non attendu et erreur de typage
      (NB : les erreur de lexème ne sont pas gérées par les outils
      d'erreurs de menhir).
    - Macros constantes (la valeur du macro est à mettre sur
      une seule ligne).

+ **TP 3 - Analyse de flot de données et optimisations**
  - _extentions :_
    - Calcul de point fixe avec liste de tâches, on parcourt le
      code en "zig-zag" de bas en haut (comme vu en TD) ce qui
      permet d'économiser un grand nombre d'itérations.

+ **TP 4 - Allocation de registres par coloration de graphe (Allocation de
  registres, pour de vrai)**
  - _extentions :_
    - Réutilisation d'identifiants inter-instructions.
    - Réutilisation d'identifiants intra-expressions.
    - Économiser les mouvements (ad hoc)

**Autres informations :**
+ Du fait de l'ajout de nouveaux opérateurs, PrebuiltParser et PrebuiltLexer
ont du être retiré de la fonction principale pour eviter les erreurs à
la compilation

+ La deuxième extension du 3e TP figure dans les fichiers sources mais n'est
pas implémentée (IrAccessibility et IrConstantPropagation).

+ Les erreurs de lexème ne retournent pas bien la colonne courante.

## Acte II

Parties ayant été faites et fonctionnelles :
+ **TP 5 - Fonctions et conventions d'appel**
  - _extentions :_
    - Uniformisation
    - Sauvegarder les registres
    - Paramètres et résultat (partiellement, voir autres informations)

+ **TP 6 - Tableaux**
  - _extentions :_
    - Vérification des bornes des tableaux

+ **TP 7 - Sémantique et interprétation**

+ **TP 8 - Types**

**Autres informations**
+ Du fait de la colorations de graphe pour l'allocation des registres,
les paramètres formels ont du être colorié de la même manière que
les paramètres locaux. L'affectation au sein d'une fonction de ces paramètres
formels n'a donc pas été traité dans IrtoAllocated mais dans AllocatedtoMips
(sauf pour result qui a sa place dans le stack) ce qui permet de bénéficier
du travail de la coloration de graphe pour les formels.

+ Diverses fonction on été rajouté de manière statique pour chaque programmes
généré _via_ ce compilateur telle que (voir MipsMisc.ml) :
  - Fonction pour les tableaux :
    - `integer arr_length( []τ )` (visible pour l'utilisateur)
    - `_new_array_`            (non visible pour l'utilisateur)
    - `_check_array_bounds`    (non visible pour l'utilisateur)
    - `_load_array_elt`           (non visible pour l'utilisateur)
    - `_store_in_array`           (non visible pour l'utilisateur)
  - Fonctions conversion entier en asciiz (visibles pour l'utilisateur) :
    - `integer log10( n )`          
    - `[]integer string_of_int( n )`
