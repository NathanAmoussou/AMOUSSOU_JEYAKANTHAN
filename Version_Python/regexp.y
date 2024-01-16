%{
#include <stdio.h>    // Nécessaire pour les fonctions d'impression
#include <string.h>   // Nécessaire pour la fonction strdup
#include <stdlib.h>   // Pour la fonction exit

// Définit la fonction yyerror attendue par Bison
// (pour palier au problème de compilation)
void yyerror(const char *s) {
  fprintf(stderr, "Erreur de syntaxe : %s\n", s);
}

extern int yylex(void); // Déclare la fonction yylex() générée par Flex
// (pour palier au problème de compilation)
char* regex; // Pour stocker l'expression régulière résultante.
int automate_count = 0; // Pour compter le nombre d'automates créés.
FILE *fichier = NULL; // Déclaration de la variable fichier comme globale
char* final_expression = NULL; // Pour stocker l'expression régulière finale
char* recognized_words[100]; // Tableau pour stocker les mots reconnus, ajuster la taille selon les besoins
int word_count = 0; // Compteur pour les mots reconnus

%}

// Utilisée pour définir un type d'union que Yacc/Bison 
// utilisera pour stocker les valeurs sémantiques.
%union {
  char* str;
  // Les valeurs sémantiques de vos symboles de grammaire peuvent 
  // être des chaînes de caractères.
}

%token <str> WORD // Déclare que les tokens WORD auront une valeur de type char*
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
                            $$ = strdup($2);
                            printf("Groupement reconnu : %s\n", $$); }
  | LETTER                 { 
                            char var[20];
                            sprintf(var, "a%d", automate_count++); // Crée un nom de variable unique.
                            char buffer[100]; // S'assurer que le buffer est suffisamment grand pour le contenu à écrire.
                            sprintf(buffer, "%s = automate(\"%s\")\n", var, $1); // Formatte la chaîne dans buffer.
                            fputs(buffer, fichier); ; // Écrit le code dans main.py.
                            $$ = strdup(var); // Stocke le nom de la variable pour une utilisation ultérieure.
                            printf("Lettre reconnue : %s\n", $$); }
  | EPSILON                { 
                            char var[20], buffer[100];
                            sprintf(var, "a%d", automate_count++);
                            sprintf(buffer, "%s = automate_epsilon()\n", var);
                            fputs(buffer, fichier);
                            $$ = strdup(var);
                            printf("Epsilon reconnu\n"); }
  | EMPTY_SET              { 
                            char var[20], buffer[100];
                            sprintf(var, "a%d", automate_count++);
                            sprintf(buffer, "%s = automate_empty_set()\n", var);
                            fputs(buffer, fichier);
                            $$ = strdup(var);
                            printf("Ensemble vide reconnu\n"); }
  ;

words:
    words WORD {
        printf("Mot reconnu: %s\n", $2); // Affiche le mot reconnu dans la console.
        recognized_words[word_count++] = strdup($2); // Stocke le mot reconnu
        free($2); // Libère la mémoire après utilisation.
    }
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
    for(int i = 0; i < word_count; i++) {
        fprintf(fichier, "print(reconnait(a_final,\"%s\"))\n", recognized_words[i]);
        free(recognized_words[i]); // Libère la mémoire après utilisation
    }
    fclose(fichier);
    free(final_expression);
    return 0;
}
