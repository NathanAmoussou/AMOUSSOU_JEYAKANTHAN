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
int automate_count = 0;
FILE *fichier = NULL; // Déclaration de la variable fichier comme globale
char* final_expression = NULL; // Pour stocker l'expression régulière finale

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
    expression NEWLINE words { 
      final_expression = strdup($1); // Capture l'expression régulière finale
      printf("Expression régulière complète : %s\n", $1); 
      }
    ;

expression:
    expression PLUS term   { 
    char var[20], buffer[200];
    sprintf(var, "a%d", automate_count++);
    sprintf(buffer, "%s = union(%s, %s)\n", var, $1, $3);
    fputs(buffer, fichier);
    $$ = strdup(var);
    printf("Union reconnue : %s\n", $$); }
  | term                   { $$ = strdup($1); }
  ;

term:
    term DOT factor        { 
                            char var[20], buffer[200];
                            sprintf(var, "a%d", automate_count++);
                            sprintf(buffer, "%s = concatenation(%s, %s)\n", var, $1, $3);
                            fputs(buffer, fichier);
                            $$ = strdup(var);
                            printf("Concaténation reconnue : %s\n", $$); }
  | factor                 { $$ = strdup($1); }
  ;

factor:
    factor STAR            { 
                            char var[20], buffer[200];
                            sprintf(var, "a%d", automate_count++);
                            sprintf(buffer, "%s = etoile(%s)\n", var, $1);
                            fputs(buffer, fichier);
                            $$ = strdup(var);
                            printf("Répétition reconnue : %s\n", $$); }
  | PAR_O expression PAR_F { 
                            // Ici, vous pouvez choisir de simplement transmettre l'automate de l'expression
                            // ou de créer un nouvel automate pour le groupement.
                            $$ = strdup($2);
                            printf("Groupement reconnu : %s\n", $$); }
  | LETTER                 { 
                            char var[20];
                            sprintf(var, "a%d", automate_count++); // Crée un nom de variable unique.
                            char buffer[100]; // Assurez-vous que le buffer est suffisamment grand pour le contenu que vous voulez écrire.
                            sprintf(buffer, "%s = automate(\"%s\")\n", var, $1); // Formatte la chaîne dans buffer.
                            fputs(buffer, fichier); ; // Écrit le code dans main.py.
                            $$ = strdup(var); // Stocke le nom de la variable pour une utilisation ultérieure.
                            printf("Lettre reconnue : %s\n", $$); }
  | EPSILON                { 
                            char var[20], buffer[100];
                            sprintf(var, "a%d", automate_count++);
                            sprintf(buffer, "%s = automate_epsilon()\n", var); // Adaptez en fonction de votre implémentation
                            fputs(buffer, fichier);
                            $$ = strdup(var);
                            printf("Epsilon reconnu\n"); }
  | EMPTY_SET              { 
                            char var[20], buffer[100];
                            sprintf(var, "a%d", automate_count++);
                            sprintf(buffer, "%s = automate_empty_set()\n", var); // Adaptez en fonction de votre implémentation
                            fputs(buffer, fichier);
                            $$ = strdup(var);
                            printf("Ensemble vide reconnu\n"); }
  ;

words:
    words WORD { printf("Mot reconnu: %s\n", $2); /* Libérer la mémoire après utilisation */ free($2); }
  | words NEWLINE
  | /* epsilon */
  ;

%%

int main(int argc, char **argv) {
    fichier = fopen("main.py", "w"); // Ouvre le fichier une seule fois
    if (!fichier) {
        fprintf(stderr, "Erreur lors de l'ouverture du fichier\n");
        exit(1);
    }
    fputs("from automate import *\n\n", fichier);
    yyparse();
    if(final_expression) {
        fprintf(fichier, "\na_final = %s\nprint(a_final)\n", final_expression);
    }
    fclose(fichier);
    free(final_expression);
    return 0;
}