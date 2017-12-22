# Devoir de compilation
_Samuel BERRIEN, M1 Informatique 2017 / 2018 Université Paris-Saclay_

_Auteur : Thibaut Balabonski [TP  Compilation](https://www.lri.fr/~blsk/Compilation/ "TP Compilation")_

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
ont du être retiré de la fonction principale pour éviter les erreurs à
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
    - Tableaux initialisés

+ **TP 7 - Sémantique et interprétation**

+ **TP 8 - Types**

**Autres informations**
+ Du fait de la colorations de graphe pour l'allocation des registres,
les paramètres formels ont du être colorié de la même manière que
les paramètres locaux. L'affectation au sein d'une fonction de ces paramètres
formels n'a donc pas été traité dans IrtoAllocated mais dans AllocatedtoMips
(sauf pour result qui a sa place dans le stack) ce qui permet de bénéficier
du travail de la coloration de graphe pour les formels.

+ Diverses fonctions ont été rajouté de manière statique pour chaque programme
généré _via_ ce compilateur telles que (voir MipsMisc.ml) :
  - Fonction pour les tableaux :
    - `integer arr_length( []τ )` (visible pour l'utilisateur)
    - `_new_array_`            (non visible pour l'utilisateur)
    - `_check_array_bounds`    (non visible pour l'utilisateur)
    - `_load_array_elt`           (non visible pour l'utilisateur)
    - `_store_in_array`           (non visible pour l'utilisateur)
  - Fonctions conversion entier en asciiz
  (visibles pour l'utilisateur et générées depuis a6000) :
    - `integer log10( n )`          
    - `[]integer string_of_int( n )`

## Acte III

Parties ayant été faites et fonctionnelles :
+ **TP 9 - Syntaxe abstraite annotée et surcharge statique**
  - _extentions :_
    - Améliorer les messages d'erreur

+ **TP 10 - Structures**
  - _extentions :_
    - Égalité structurelle guidée par les types
    - Extensions de structures
    - Transtypage

**Autres informations**
+ La surcharge a été traité le plus tôt possible, c'est à dire dans SourcetoTyped.
+ Les fonctions `integer arr_length( []τ )` et `[]integer string_of_int( n )` ont été supprimé. Les fonctions `integer random(integer seed, integer upperBound)`
et `print_int( n )` ont été ajouté.  
+ L'interpréteur n'est plus utilisable.
+ Le transtypage n'est effectif que lors du passage de paramètres formels
pour une fonction, il n'est pas possible de "cast" _via_ `(NewType) myVar`
comme dans la syntaxe de Java.
De plus il ne marche que pour un type étendu vers un type plus général.
