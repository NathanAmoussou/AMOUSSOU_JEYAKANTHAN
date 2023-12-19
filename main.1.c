#include "automate.h"
#include <stdio.h>

int main () {
AUTOMATE A0, A1, A2, A3, A4, A5;
AUTOMATE A_final;
A0 = creer_automate_une_lettre('a');
A1 = creer_automate_une_lettre('b');
A2 = union_automate(A0,A1);
A3 = etoile_automate(A2);
A4 = creer_automate_une_lettre('c');
A5 = concat_automate(A3,A4);

A_final = supprime_epsilon_transitions (A5);
afficher(A_final);

reconnait(A_final,"ab");
reconnait(A_final,"aaaaac");
reconnait(A_final,"c");

return 0;
}
