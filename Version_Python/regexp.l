%{
#include "regexp.tab.h"  // Inclure les définitions de tokens générées par Bison
%}

%option noyywrap

%x EXPRESSION
%x WORDS

%%

<INITIAL>{
    "("           { BEGIN(EXPRESSION); return PAR_O; }
}

<EXPRESSION>{
    "("           { return PAR_O; }
    ")"           { return PAR_F; }
    "+"           { return PLUS; }
    "."           { return DOT; }
    "*"           { return STAR; }
    "E"           { return EPSILON; }
    "O"           { return EMPTY_SET; }
    [a-z]         { yylval.str = strdup(yytext); return LETTER; }
    "\n"          { BEGIN(WORDS); return NEWLINE; }
}

<WORDS>{
    [a-zA-Z]+     { yylval.str = strdup(yytext); return WORD; }
    "\n"          { return NEWLINE; }
}

%%
