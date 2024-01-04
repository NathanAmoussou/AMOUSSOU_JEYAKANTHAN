%{
#include "tokens.h"  // Un fichier où vous définissez vos tokens, comme #define PLUS 201

// Vous pouvez inclure d'autres bibliothèques C ici si nécessaire.
%}

%%

[a-z]             { return SIGMA; }  // Reconnaît une lettre minuscule et retourne le token SIGMA
"E"               { return EPSILON; }  // Reconnaît le caractère 'E' et retourne le token EPSILON
"O"               { return EMPTY_SET; }  // Reconnaît le caractère 'O' et retourne le token EMPTY_SET
"+"               { return PLUS; }  // Reconnaît le caractère '+' et retourne le token PLUS
"."               { return DOT; }  // Reconnaît le caractère '.' et retourne le token DOT
"*"               { return STAR; }  // Reconnaît le caractère '*' et retourne le token STAR
"("               { return PAR_O; }  // Reconnaît le caractère '(' et retourne le token PAR_O
")"               { return PAR_F; }  // Reconnaît le caractère ')' et retourne le token PAR_F

[\t\n ]+          ;  // Ignore les espaces, les tabulations et les nouvelles lignes
.                 { printf("Caractère non reconnu: %c\n", yytext[0]); }  // Gère les caractères non reconnus

%%

int yywrap(void) { return 1; }