%{
#include <stdio.h>    // Nécessaire pour les fonctions d'impression
#include <string.h>
#include <stdlib.h>   // Pour la fonction exit

// Définir la fonction yyerror attendue par Bison
void yyerror(const char *s) {
  fprintf(stderr, "Erreur de syntaxe : %s\n", s);
}

extern int yylex(void);
char* regex; // Pour stocker l'expression régulière résultante.
FILE *py_file;  // Fichier pour écrire le code Python

%}

%union {
  char* str;
}

%token <str> WORD
%token <str> LETTER  // Déclare que les tokens LETTER auront une valeur de type char*
%type <str> expression term factor  // Déclare que ces symboles non terminaux auront une valeur de type char*
%token PAR_O PAR_F PLUS DOT STAR EPSILON EMPTY_SET NEWLINE

%right STAR       // * est plus prioritaire
%left DOT         // . vient ensuite
%left PLUS        // + est le moins prioritaire

%%

input:
    expression NEWLINE words { printf("Expression régulière complète : %s\n", $1); }
    ;

expression:
    expression NEWLINE words {
        py_file = fopen("main.py", "w");  // Ouvre le fichier pour écrire
        if (py_file == NULL) {
            fprintf(stderr, "Erreur d'ouverture du fichier main.py\n");
            exit(1);
        }

        // Écrire le code Python pour créer l'automate
        fprintf(py_file, "from automate import *\n\n");
        fprintf(py_file, "a_final = %s\n", $1);  // $1 est l'expression régulière construite
        fprintf(py_file, "print(a_final);\n\n");

        // Écrire le code pour tester les mots
        // Vous devrez ajouter la logique pour passer les mots du fichier d'entrée ici
        fprintf(py_file, "print(reconnait(a_final,\"ab\"))\n");
        fprintf(py_file, "print(reconnait(a_final,\"aaaaac\"))\n");
        fprintf(py_file, "print(reconnait(a_final,\"c\"))\n");

        fclose(py_file);  // Fermer le fichier
    }
    ;


expression:
    expression PLUS term   { $$ = strdup($1); strcat($$, "+"); strcat($$, $3); printf("Union reconnue : %s\n", $$); }
  | term                   { $$ = strdup($1); }
  ;

term:
    term DOT factor        { $$ = strdup($1); strcat($$, "."); strcat($$, $3); printf("Concaténation reconnue : %s\n", $$); }
  | factor                 { $$ = strdup($1); }
  ;

factor:
    factor STAR            { $$ = strdup($1); strcat($$, "*"); printf("Répétition reconnue : %s\n", $$); }
  | PAR_O expression PAR_F { $$ = strdup("("); strcat($$, $2); strcat($$, ")"); printf("Groupement reconnu : %s\n", $$); }
  | LETTER                 { $$ = $1; printf("Lettre reconnue : %s\n", $$); }
  | EPSILON                { $$ = strdup("E"); printf("Epsilon reconnu\n"); }
  | EMPTY_SET              { $$ = strdup("O"); printf("Ensemble vide reconnu\n"); }
  ;

words:
    words WORD { printf("Mot reconnu: %s\n", $2); /* Libérer la mémoire après utilisation */ free($2); }
  | words NEWLINE
  | /* epsilon */
  ;

%%

int main(int argc, char **argv) {
    yyparse();
    return 0;
}