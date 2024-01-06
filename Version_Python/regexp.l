%{
#include "regexp.tab.h"  // Inclure les définitions de tokens générées par Bison
%}

int yylex(void);

%%

"("           { printf("PAR_O\n"); return PAR_O; }
")"           { printf("PAR_F\n"); return PAR_F; }
"+"           { printf("PLUS\n"); return PLUS; }
"."           { printf("DOT\n"); return DOT; }
"*"           { printf("STAR\n"); return STAR; }
"E"           { printf("EPSILON\n"); return EPSILON; }
"O"           { printf("EMPTY_SET\n"); return EMPTY_SET; }
[a-z]         { printf("LETTER\n"); return LETTER; }

%%

int yywrap() {
    return 1;
}

