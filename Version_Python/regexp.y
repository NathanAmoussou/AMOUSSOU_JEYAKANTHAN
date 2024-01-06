%{
#include <stdio.h>    // Nécessaire pour les fonctions d'impression
// Définir la fonction yyerror attendue par Bison
void yyerror(const char *s) {
  fprintf(stderr, "Erreur de syntaxe : %s\n", s);
}
%}

%token PAR_O PAR_F PLUS DOT STAR EPSILON EMPTY_SET LETTER

%right STAR       // * est plus prioritaire
%left DOT         // . vient ensuite
%left PLUS        // + est le moins prioritaire

%%

// La grammaire suit la structure et la priorité des opérateurs des expressions régulières

reg_exp:
    reg_exp PLUS reg_term   { printf("Opérateur PLUS (union) reconnu.\n"); }
  | reg_term                { /* rien à faire ici */ }
  ;

reg_term:
    reg_term DOT reg_factor { printf("Opérateur DOT (concaténation) reconnu.\n"); }
  | reg_factor              { /* rien à faire ici */ }
  ;

reg_factor:
    reg_factor STAR         { printf("Opérateur STAR (répétition) reconnu.\n"); }
  | PAR_O reg_exp PAR_F     { printf("Parenthèses ouvrante et fermante reconnues.\n"); }
  | LETTER                  { printf("Lettre reconnue.\n"); }
  | EPSILON                 { printf("Epsilon reconnu.\n"); }
  | EMPTY_SET               { printf("Ensemble vide reconnu.\n"); }
  ;

%%
