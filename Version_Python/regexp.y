%{
#include <stdio.h>    // Nécessaire pour les fonctions d'impression
#include <string.h>

// Définir la fonction yyerror attendue par Bison
void yyerror(const char *s) {
  fprintf(stderr, "Erreur de syntaxe : %s\n", s);
}

extern int yylex(void);
char* regex; // Pour stocker l'expression régulière résultante.

%}

%union {
  char* str;
}

%token <str> WORD
%token PAR_O PAR_F PLUS DOT STAR EPSILON EMPTY_SET LETTER NEWLINE WORD

%right STAR       // * est plus prioritaire
%left DOT         // . vient ensuite
%left PLUS        // + est le moins prioritaire

%%

// La grammaire suit la structure et la priorité des opérateurs des expressions régulières

input:
    expression NEWLINE words
    ;

expression:
    expression PLUS term   { /* Construisez ici l'expression régulière */ }
  | term                   { /* Construisez ici l'expression régulière */ }
  ;

term:
    term DOT factor        { /* Construisez ici l'expression régulière */ }
  | factor                 { /* Construisez ici l'expression régulière */ }
  ;

factor:
    factor STAR            { /* Construisez ici l'expression régulière */ }
  | PAR_O expression PAR_F { /* Construisez ici l'expression régulière */ }
  | LETTER                 { /* Construisez ici l'expression régulière */ }
  | EPSILON                { /* Construisez ici l'expression régulière */ }
  | EMPTY_SET              { /* Construisez ici l'expression régulière */ }
  ;

words:
    words NEWLINE WORD { /* Testez ici le mot avec l'expression régulière */ }
  | /* epsilon */
  ;

%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}